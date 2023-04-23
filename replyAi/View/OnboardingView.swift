//
//  OnboardingView.swift
//  replyAi
//
//  Created by Benjamin Surrey on 21.04.23.
//

import SwiftUI
import AuthenticationServices

struct OnboardingView: View {
    var onDismiss: () -> Void
    @State private var appleSignInManager = AppleSignInManager()
    
    func onSignedIn(identityToken: String) {
        // Send the identityToken to your Laravel backend to verify and log in the user
        let url = URL(string: "http://your-laravel-api-url/api/login/apple/callback")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONEncoder().encode(["identityToken": identityToken])
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data, let _ = try? JSONDecoder().decode(LoginResponse.self, from: data) {
                DispatchQueue.main.async {
                    // Save some flag to UserDefaults to remember that the user has logged in
                    UserDefaults.standard.set(true, forKey: "isLoggedIn")
                    
                    // Dismiss the WelcomeView
                    onDismiss()
                }
            }
        }.resume()
    }
    
    var body: some View {
        VStack {
            Spacer()
            
            Text("Welcome")
                .font(.system(size: 80))
                .fontWeight(.regular)
                .multilineTextAlignment(.center)
                .foregroundColor(.black)
            
            Spacer()
            
            SignInWithAppleButton(.signIn, onRequest: { request in
                request.requestedScopes = [.email]
            }, onCompletion: { result in
                switch result {
                case .success(let authorization):
                    if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
                        let identityToken = appleIDCredential.identityToken.flatMap { String(data: $0, encoding: .utf8) }
                        
                        if let identityToken = identityToken {
                            onSignedIn(identityToken: identityToken)
                        }
                    }
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                }
            })
            .frame(height: 45)
            .padding()
            
            Button(action: {
                print("Skip tapped")
                onDismiss()
            }) {
                Text("Skip")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .padding()
            }
            .padding(.bottom)
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            FluidGradient(blobs: [.green, .green, .blue, .red, .white],
                          highlights: [.cyan, .red, .blue, .mint, .white, .yellow],
                          speed: 0.50,
                          blur: 0.7)
            .background(.mint)
            .ignoresSafeArea()
        )
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
}

import SwiftUI

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            OnboardingView(onDismiss: {
                return
            })
            .environmentObject(ThemeManager())
            .environmentObject(MockAppState())
            .previewDisplayName("Welcome View")
        }
    }
}

class MockAppState: AppState {
    override init() {
        super.init()
        self.isWelcomeViewPresented = true
    }
}
