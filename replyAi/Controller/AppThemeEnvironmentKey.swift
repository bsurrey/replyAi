//
//  AppThemeEnvironmentKey.swift
//  WshList
//
//  Created by Benjamin on 17.03.23.
//

import SwiftUI // Import SwiftUI framework

// Define a new custom environment key called AppThemeEnvironmentKey
struct AppThemeEnvironmentKey: EnvironmentKey {
    // Set the default value for this environment key to AppTheme.system
    static let defaultValue: AppTheme = .dark
}

// Extend the EnvironmentValues struct to include the new custom environment key
extension EnvironmentValues {
    // Create a computed property called appTheme of type AppTheme
    var appTheme: AppTheme {
        // Getter: Access the value of the custom environment key and return it
        get { self[AppThemeEnvironmentKey.self] }
        
        // Setter: Set the value of the custom environment key to the provided newValue
        set { self[AppThemeEnvironmentKey.self] = newValue }
    }
}
