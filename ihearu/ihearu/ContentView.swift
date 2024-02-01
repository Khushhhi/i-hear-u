//
//  ContentView.swift
//  ihearu
//
//  Created by khushi mittal on 01/02/24.
//

import SwiftUI
import ShazamKit
import AVFoundation

struct ContentView: View {
    @State private var isAnimating = false
    @State private var songTitle = "Listening..."
    @State private var session = SHSession()
    @State private var audioEngine = AVAudioEngine()
    
    var body: some View {
        
            ZStack{
                Color(
                    #colorLiteral(red: 0.9876887202, green: 0.9806448817, blue: 0.9561607242, alpha: 1)
                )
                VStack(spacing: 16) {
                    Text("ihearu 🎧")
                        .font(.system(size: 50, design: .rounded))
                        .fontWeight(.semibold)
                        .padding(.trailing, 150)
                        .padding(.bottom, 110)
                    
                    Button(action: {
                        isAnimating.toggle()
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
                        .background(.black)
                        .clipShape(Circle())
                        
                        .overlay(
                            Circle()
                                .stroke(isAnimating ? Color.green : Color.blue, lineWidth: 2)
                            
                                .scaleEffect(isAnimating ? 2 : 1)
                                .opacity(isAnimating ? 0 : 1)
                                .animation(.easeOut(duration: 0.6).repeatForever(autoreverses: true), value: isAnimating)
                        )
                        
                    })
                    
                    if !songTitle.isEmpty {
                        GeometryReader { geometry in
                            VStack {
                                Spacer()
                                SongCardView(songTitle: $songTitle)
                                    .padding(.top, 10)
                                    .padding(.bottom, 15)
                                    .cornerRadius(geometry.safeAreaInsets.bottom == 0 ? 35 : geometry.safeAreaInsets.bottom)
                            }
                        }
                        
                    }
                    
                }
                .padding(.top, 100)

            }
            .edgesIgnoringSafeArea(.all)


          

        
        //        .foregroundColor(.black)
    }
}

struct SongCardView: View {
    @Binding var songTitle: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Now Playing")
                .font(.headline)
            Text(songTitle)
                .font(.title2)
        }
        .frame(maxWidth: .infinity, maxHeight: 180)
        .background(Color.white)
        .cornerRadius(35)
        .shadow(radius: 5)
        .padding(.horizontal)
        //        .edgesIgnoringSafeArea(.bottom)
        
    }
}
#Preview {
    ContentView()
}
