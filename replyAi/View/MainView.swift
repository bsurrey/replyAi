//
//  MainView.swift
//  replyAi
//
//  Created by Benjamin Surrey on 11.04.23.
//

import SwiftUI

struct MainView: View {
    @State public var showOnboarding = !UserDefaultsManager.shared.hasCompletedOnboarding()
    
    @State public var currentSelection = 1
    
    var body: some View {
        TabView(selection: $currentSelection) {
            ChatsView()
                .tabItem {
                    Label("Chats", systemImage: "bubble.right")
                        .labelStyle(.titleAndIcon)
                }.tag(1)
            
            ChatsView()
                .tabItem {
                    Label("Images", systemImage: "photo.stack.fill")
                        .labelStyle(.titleAndIcon)
                }.tag(1)
            
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                        .labelStyle(.titleAndIcon)
                }
                .tag(2)
        }
        .fullScreenCover(isPresented: $showOnboarding) {
            OnboardingView(onDismiss: {
                UserDefaultsManager.shared.setOnboardingCompleted(true)
                showOnboarding = false
            })
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(showOnboarding: false)
            .environmentObject(ThemeManager())
    }
}
