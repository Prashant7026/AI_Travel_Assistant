//
//  AIChatBotApp.swift
//  AIChatBot
//
//  Created by MacBook Pro on 24/03/24.
//

import SwiftUI

@main
struct AIChatBotApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            WelcomeScreen()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
