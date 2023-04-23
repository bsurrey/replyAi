//
//  SettingsView.swift
//  replyAi
//
//  Created by Benjamin on 22.03.23.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @State private var bgColor = Color.red
    @State private var useIcloud = false
    @State public var showOnboarding = !UserDefaultsManager.shared.hasCompletedOnboarding()

    
    @Environment(\.colorScheme) private var systemColorScheme
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    Picker(selection: $themeManager.appTheme, content: {
                        ForEach(AppTheme.allCases) { theme in
                            Text(theme.description).tag(theme.rawValue)
                        }
                    }, label: {
                        Label("Theme", systemImage: "paintbrush.fill")
                    })
                                        
                    ColorPicker(selection: $bgColor, supportsOpacity: false, label: {
                        Label("Accent Color", systemImage: "slider.horizontal.below.square.filled.and.square")
                    })
                    
                    
                    Label("Icon", systemImage: "app.fill")
                }
                
                Section(footer: Text("This will save all Messages in iCloud"), content: {
                    Toggle(isOn: $showOnboarding, label: {
                        Label("Onboarding", systemImage: "faceid")
                    })
                    Toggle(isOn: $useIcloud, label: {
                        Label("Use FaceID", systemImage: "faceid")
                    })
                    Toggle(isOn: $useIcloud, label: {
                        Label("Notifications", systemImage: "app.badge.fill")
                    })
                    Toggle(isOn: $useIcloud, label: {
                        Label("Use iCloud", systemImage: "icloud.fill")
                    })
                })
                
                Section {
                    NavigationLink(destination: SettingsView(), label: {
                        Label("OpenAI API Key", systemImage: "key.fill")
                    })
                }
                
                Section {
                    NavigationLink(destination: SettingsView(), label: {
                        Label("Go Pro", systemImage: "seal.fill")
                    })
                    Button(action: {return}, label: {
                        Label("Restore Purchases", systemImage: "purchased.circle.fill")
                    })
                }
                
                Section {
                    NavigationLink(destination: SettingsView(), label: {
                        Label("Report a Problem", systemImage: "exclamationmark.bubble.circle.fill")
                    })
                    NavigationLink(destination: SettingsView(), label: {
                        Label("Support", systemImage: "questionmark.circle.fill")
                    })
                }
                
                Section {
                    Link(destination: URL(string: "https://www.example.com/TOS.html")!, label: {
                        Label("Share with friends", systemImage: "person.2.fill")
                    })
                    Link(destination: URL(string: "https://www.example.com/TOS.html")!, label: {
                        Label("About", systemImage: "info.circle.fill")
                    })
                    Link(destination: URL(string: "https://www.example.com/TOS.html")!, label: {
                        Label("Data & Privacy", systemImage: "shield.fill")
                    })
                }
                
                Text("Version 1.0.0")
                Text("Made with ❤️ in karlsruhe 🇩🇪")
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
