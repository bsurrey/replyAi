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
    @Environment(\.appTheme) private var appTheme
    @Environment(\.presentationMode) var presentationMode
    
    @AppStorage("prompt") var prompt: String = "Reply to the entered Text in german, be helpful, creative, clever, funny or reply in thr same style and slang."
    @AppStorage("sendDirectly") var sendDirectly: Bool = false
        
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Appearance")) {
                    Picker("Theme", selection: Binding<Int>(
                        get: { themeManager.appTheme },
                        set: { newValue in
                            themeManager.updateTheme(theme: AppTheme(rawValue: newValue) ?? .system)
                        })) {
                            ForEach(AppTheme.allCases) { theme in
                                Text(theme.description).tag(theme.rawValue)
                            }
                        }
                }
                
                Section(header: Text("Debug")) {
                    TextField("prompt", text: $prompt)
                    Toggle("Send directly", isOn: $sendDirectly)
                }.padding()
            }
            .navigationTitle("Settings")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
        .preferredColorScheme(appTheme == .system ? nil : appTheme.colorScheme)
    }
}

enum Theme: Int, CaseIterable {
    case systemDefault, light, dark
}
