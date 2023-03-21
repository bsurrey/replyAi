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

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
