//
//  UserDefaultsManager.swift
//  replyAi
//
//  Created by Benjamin Surrey on 21.04.23.
//

import Foundation

class UserDefaultsManager {
    private let onboardingKey = "hasCompletedOnboarding"
    
    static let shared = UserDefaultsManager()
    
    func setOnboardingCompleted(_ completed: Bool) {
        UserDefaults.standard.set(completed, forKey: onboardingKey)
    }
    
    func hasCompletedOnboarding() -> Bool {
        return UserDefaults.standard.bool(forKey: onboardingKey)
    }
}
