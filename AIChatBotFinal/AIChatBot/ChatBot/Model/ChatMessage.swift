//
//  ChatMessage.swift
//  AIChatBot
//
//  Created by MacBook Pro on 25/03/24.
//

import SwiftUI

struct ChatMessage: Identifiable {
    var id = UUID().uuidString
    
    var owner: MessageOwner
    var text: String
    
    init(owner: MessageOwner = .User, _ text: String) {
        self.owner = owner
        self.text = text
    }
}

enum MessageOwner: String {
    case User, Bot
}
