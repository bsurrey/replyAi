//
//  SettingsView.swift
//  replyAi
//
//  Created by Benjamin on 22.03.23.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var themeManager: ThemeManager
    
    @Environment(\.colorScheme) private var systemColorScheme
    @Environment(\.presentationMode) var presentationMode
        
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Appearance")) {
                    Picker("Theme", selection: $themeManager.appTheme) {
                        ForEach(AppTheme.allCases) { theme in
                            Text(theme.description).tag(theme.rawValue)
                        }
                    }
                }
            }
            .navigationTitle("Settings")
        }
        .preferredColorScheme(themeManager.currentColorScheme) // Use the currentColorScheme property
    }
}


enum Theme: Int, CaseIterable {
    case systemDefault, light, dark
}


struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(ThemeManager())
    }
}
