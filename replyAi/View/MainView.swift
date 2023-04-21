//
//  MainView.swift
//  replyAi
//
//  Created by Benjamin Surrey on 11.04.23.
//

import SwiftUI

struct MainView: View {
    @State private var showOnboarding = !UserDefaultsManager.shared.hasCompletedOnboarding()
    
    var body: some View {
        TabView(selection: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Selection@*/.constant(1)/*@END_MENU_TOKEN@*/) {
            ChatView()
                .tabItem {
                    Label("Chat", systemImage: "brain.head.profile")
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
        MainView()
            .environmentObject(ThemeManager())
    }
}
