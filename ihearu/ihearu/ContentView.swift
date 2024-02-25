//
//  ContentView.swift
//  ihearu
//
//  Created by khushi mittal on 01/02/24.
//

import SwiftUI
import ShazamKit
import AVFoundation

class ShazamManager: NSObject, ObservableObject, SHSessionDelegate {
    @State private var isAnimating = false
    var session: SHSession
    var audioEngine: AVAudioEngine
    var isListening = false
    @Published var songTitle: String = "Listening..."
    
    
    override init() {
        session = SHSession()
        audioEngine = AVAudioEngine()
        super.init()
        session.delegate = self
    }
    
    // Implement SHSessionDelegate methods here
    func session(_ session: SHSession, didFind match: SHMatch) {
        // Handle match
        DispatchQueue.main.async { // Ensure UI updates on main thread
            if let item = match.mediaItems.first {
                self.songTitle = item.title ?? "Unknown Song"
            }
        }
    }
    
    func session(_ session: SHSession, didNotFindMatchFor signature: SHSignature, error: Error?) {
        // Handle failure to find a match
        songTitle = "Song not found"
    }
    
    // Add your startListening and stopListening methods here
    func startListening() {
        let audioSession = AVAudioSession.sharedInstance()
        
        do {
            try audioSession.setCategory(.record, mode: .default)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
            let inputNode = audioEngine.inputNode
            let recordingFormat = inputNode.outputFormat(forBus: 0)
            inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, when in
                self.session.matchStreamingBuffer(buffer, at: when)
            }
            
            audioEngine.prepare()
            try audioEngine.start()
        } catch {
            print(error.localizedDescription)
            self.isAnimating = false
        }
    }
    
    func stopListening() {
        audioEngine.inputNode.removeTap(onBus: 0)
        audioEngine.stop()
        do {
            try AVAudioSession.sharedInstance().setActive(false)
        } catch {
            print(error.localizedDescription)
        }
    }
}

struct ContentView: View {
    @State private var isAnimating = false
    @State private var songTitle = "Listening..."
//    @State private var session = SHSession()
    @State private var audioEngine = AVAudioEngine()
    @StateObject private var shazamManager = ShazamManager()
    
    var body: some View {
        
        ZStack{
            Color(
                #colorLiteral(red: 0.9756619334, green: 0.9494382739, blue: 0.9180981517, alpha: 1)
                //F7EFE5
            )
            
            VStack(spacing: 16) {
                Text("ihearu 🎧")
                    .font(.system(size: 50, design: .rounded))
                    .fontWeight(.semibold)
//                    .padding(.trailing, 150)
                    .padding(.bottom, 120)
                
                Button(action: {
                    isAnimating.toggle()
                    
                    if shazamManager.isListening {
                        shazamManager.stopListening()
                    } else {
                        shazamManager.startListening()
                    }
                    shazamManager.isListening.toggle()
                    
                }, label: {
                    VStack(spacing: 5){
                        Text(isAnimating ? "🐣" : "🥚")
                            .font(.system(size: 100))
                        Text("Touch Me")
                            .fontWeight(.bold)
                            .font(.headline)
                            .foregroundStyle(Color.white)
                    }
                    .frame(width: 200, height: 200)
                    .background(Color(#colorLiteral(red: 0.3835805655, green: 0.3618805707, blue: 0.3406956792, alpha: 1)))
                    //4F4A45
                    .clipShape(Circle())
                    
                    .overlay(
                        Circle()
                            .stroke(isAnimating ? Color.green : Color.blue, lineWidth: 2)
                        
                            .scaleEffect(isAnimating ? 2 : 1)
                            .opacity(isAnimating ? 0 : 1)
                            .animation(.easeOut(duration: 0.6).repeatForever(autoreverses: true), value: isAnimating)
                    )
                    
                })
                
                if !shazamManager.songTitle.isEmpty {
                    GeometryReader { geometry in
                        VStack {
                            Spacer()
                            SongCardView(songTitle: $shazamManager.songTitle)   .padding(.top, 10)
                                .padding(.bottom, 15)
                                .cornerRadius(geometry.safeAreaInsets.bottom == 0 ? 35 : geometry.safeAreaInsets.bottom)
                        }
                    }
                    
                }
                
            }
            .padding(.top, 100)
//            .onAppear {
//                shazamManager.session.delegate = self
//            }
        }
        .edgesIgnoringSafeArea(.all)
    }
}

struct SongCardView: View {
    @Binding var songTitle: String
    
    var body: some View {
        VStack {
            Spacer()
            
            ZStack {
                Image(systemName: "waveform")
                    .font(.system(size: 50))
                    .foregroundColor(.white)
                    .padding(.bottom, 30)
                
                VStack(alignment: .leading) {
                    Spacer()
                    
                    Text("Now Playing")
                        .bold()
                        .foregroundColor(.white)
                        .padding(.leading)
                    
                    Text(songTitle)
                        .font(.title2)
                        .foregroundColor(.white)
                        .bold()
                        .padding(.leading)
                        .padding(.bottom)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: 180)
        .background(Color(#colorLiteral(red: 0.9506475329, green: 0.5670107603, blue: 0.2467300296, alpha: 1)))
        .cornerRadius(35)
        .shadow(radius: 5)
        .padding(.horizontal)
        //        .edgesIgnoringSafeArea(.bottom)
        
    }
}
#Preview {
    ContentView()
}
