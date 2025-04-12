//
//  StartScreen.swift
//  dishdeciderapp
//
//  Created by Kanghee Cho on 4/11/25.
//

import SwiftUI

struct StartScreen: View {
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                ZStack {
                    // Set the full-screen background to black.
                    Color.black
                        .edgesIgnoringSafeArea(.all)
                    
                    VStack {
                        Spacer()
                        
                        // App Title and Tagline
                        VStack(spacing: 8) {
                            Image(systemName: "fork.knife")
                                .resizable()
                                .frame(width: 80, height: 80)
                                .foregroundColor(.orange)
                                .padding(.bottom, 10)
                            
                            Text("Dish Decider")
                                .font(.system(size: 48, weight: .bold))
                                .foregroundColor(.white)
                                .shadow(radius: 10)
                                .multilineTextAlignment(.center)
                            
                            Text("Let your cravings decide")
                                .font(.title3)
                                .foregroundColor(.white)
                                .shadow(radius: 5)
                                .multilineTextAlignment(.center)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal, 20)
                        
                        Spacer()
                        
                        // Get Started Button
                        NavigationLink(destination: MainContentView()) {
                            Text("Get Started")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(
                                    RoundedRectangle(cornerRadius: 40, style: .continuous)
                                        .fill(Color.orange)
                                )
                                .padding(.horizontal, 40)
                        }
                        .padding(.bottom, 50)
                    }
                }
            }
            .navigationBarHidden(true)
        }
    }
}

// Preview for SwiftUI Canvas
struct StartScreen_Previews: PreviewProvider {
    static var previews: some View {
        StartScreen()
    }
}
