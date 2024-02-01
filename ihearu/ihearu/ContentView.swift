//
//  ContentView.swift
//  ihearu
//
//  Created by khushi mittal on 01/02/24.
//

import SwiftUI

struct ContentView: View {
    @State private var isAnimating = false
    var body: some View {
        
        NavigationView {
            
            Button(action: {
                isAnimating.toggle()
            }, label: {
                VStack(spacing: 16){
//                    Image(systemName: "headphones")
//                        .foregroundColor(.white)
                    Text(isAnimating ? "🐣" : "🥚")
                        .font(.system(size: 100))
                    Text("Touch Me")
                        .fontWeight(.bold)
                        .font(.headline)
                        .foregroundStyle(Color.white)
                }
                .frame(width: 200, height: 200)
                .padding()
                .background(.black)
                .clipShape(Circle())
                
                .overlay(
                    Circle()
                        .stroke(isAnimating ? Color.green : Color.blue, lineWidth: 2)
                    
                        .scaleEffect(isAnimating ? 2 : 1) // Pulsing effect
                        .opacity(isAnimating ? 0 : 1) // Fade out effect when animating
                        .animation(.easeOut(duration: 0.6).repeatForever(autoreverses: true), value: isAnimating)
                )
                
            })
            
        }
        .navigationBarTitle("ihearu")
//        .foregroundColor(.black)
        .padding()
    }
}

#Preview {
    ContentView()
}
