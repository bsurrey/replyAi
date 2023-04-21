//
//  AppleSignInManager.swift
//  replyAi
//
//  Created by Benjamin Surrey on 21.04.23.
//

import Foundation
import AuthenticationServices

class AppleSignInManager: NSObject {
    typealias SignInCompletion = (Result<String, Error>) -> Void

    private var completion: SignInCompletion?
    
    func performSignIn(completion: @escaping SignInCompletion) {
        self.completion = completion
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.email]
        
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
    }
}

extension AppleSignInManager: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            let identityToken = appleIDCredential.identityToken.flatMap { String(data: $0, encoding: .utf8) }
            if let identityToken = identityToken {
                completion?(.success(identityToken))
            } else {
                completion?(.failure(AppleSignInError.identityTokenNotFound))
            }
        } else {
            completion?(.failure(AppleSignInError.invalidCredential))
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        completion?(.failure(error))
    }
}

extension AppleSignInManager: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return UIApplication.shared.windows.first!
    }
}

enum AppleSignInError: LocalizedError {
    case identityTokenNotFound
    case invalidCredential

    var errorDescription: String? {
        switch self {
        case .identityTokenNotFound:
            return "Identity token not found"
        case .invalidCredential:
            return "Invalid credential"
        }
    }
}
