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
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
