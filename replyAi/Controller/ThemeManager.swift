//
//  ThemeManager.swift
//  WshList
//
//  Created by Benjamin on 17.03.23.
//

import SwiftUI // Import SwiftUI framework

// Define an enumeration called AppTheme that conforms to Identifiable and CaseIterable protocols
enum AppTheme: Int, Identifiable, CaseIterable {
    case system // Case for using the system's default theme
    case light // Case for using the light theme
    case dark // Case for using the dark theme
    
    // Computed property to return the rawValue of the enum case as its Identifiable id
    var id: Int { rawValue }
    
    // Computed property to return a human-readable description of the theme
    var description: String {
        switch self {
        case .system:
            return "System Default"
        case .light:
            return "Light Mode"
        case .dark:
            return "Dark Mode"
        }
    }
    
    // Computed property to return the corresponding ColorScheme for the theme
    var colorScheme: ColorScheme {
        switch self {
        case .system:
            // Get the current user interface style from the device's screen
            let userInterfaceStyle = UIScreen.main.traitCollection.userInterfaceStyle
            // Return the appropriate color scheme based on the user interface style
            switch userInterfaceStyle {
            case .light:
                return .light
            case .dark:
                return .dark
            default:
                return .light
            }
        case .light:
            return .light // Return the light color scheme
        case .dark:
            return .dark // Return the dark color scheme
        }
    }
}

// Define a class called ThemeManager that conforms to the ObservableObject protocol
class ThemeManager: ObservableObject {
    // Computed property to return the current ColorScheme based on the appTheme
    var currentColorScheme: ColorScheme {
        AppTheme(rawValue: appTheme)?.colorScheme ?? .dark
    }
    
    // Define a property called appTheme that's stored in the App Storage with a key "appTheme"
    @AppStorage("appTheme") var appTheme: Int = AppTheme.system.rawValue {
        didSet {
            // When the appTheme value changes, notify observers of the change
            objectWillChange.send()
        }
    }
    
    // Define a function to update the appTheme property based on a provided AppTheme value
    func updateTheme(theme: AppTheme) {
        appTheme = theme.rawValue // Set the appTheme to the raw value of the provided theme
    }
}
