//
//  WelcomeView.swift
//  replyAi
//
//  Created by Benjamin Surrey on 11.04.23.
//

import SwiftUI
import AuthenticationServices

struct WelcomeView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        HStack {
            
            Button(action: {
                print("Skip button tapped")
                appState.isWelcomeViewPresented = false
            }) {
                Text("Skip")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(.horizontal, 40)
                    .padding(.vertical, 12)
                    .background(Color.blue)
                    .cornerRadius(8)
            }
            .padding(.bottom)
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}


struct LoginResponse: Codable {
    let token: String
    let user: User
}

struct User: Codable {
    let id: Int
    let name: String
    let email: String
}

