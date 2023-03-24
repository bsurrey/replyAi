//
//  replyAiApp.swift
//  replyAi
//
//  Created by Benjamin on 21.03.23.
//

import SwiftUI

@main
struct replyAiApp: App {
    let persistenceController = PersistenceController.shared
    
    @StateObject private var themeManager = ThemeManager()


    var body: some Scene {
        WindowGroup {
            ChatView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environment(\.appTheme, AppTheme(rawValue: themeManager.appTheme) ?? .system)
                .environmentObject(themeManager)
        }
    }
}

struct replyAiApp_Preview: PreviewProvider {
    static var previews: some View {
        ChatView()
            .environment(\.colorScheme, ColorScheme.light)
            .previewDisplayName("Light Mode")
        
        ChatView()
            .environment(\.colorScheme, ColorScheme.dark)
            .previewDisplayName("Dark Mode")
    }
}
