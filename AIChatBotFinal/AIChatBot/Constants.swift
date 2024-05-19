//
//  File.swift
//  AIChatBot
//
//  Created by MacBook Pro on 29/03/24.
//

import Foundation

class Constants {
    static let shared = Constants()
    
    let apiUrl = "https://api.openai.com/v1/chat/completions"
    let apiKey = ""
    let botName = "Zara"
    let welcomeScreenMessage = "I will be your travel assistant, I will ask you some details to plan your travel.\nShall we start?"
    let startChatButtonText = "Chat with Zara"
    let instructionMessage = "Please enter your information accurately to ensure the best assistance. Thank you!"
    let textFieldPlaceholder = "Message Zara..."
    let firstDefaultMessageofZara = "Hi, I'm here to help you create your travel itinerary."
    let zaraTypingMessage = "Zara is typing..."
    let welcome = "Welcome!"
    let ok = "OK"
    let empty = ""
    let allQuestionsAskedfromZara = [
        "Please provide me correct Location in which you want to visit.",
        "How many travelers are there?",
        "What is the duration of your trip in days?",
        "What are your interests or preferences? Give input separated with commas ','?",
        "Do you want to modify your details? Y/N"
    ]
    let promptMessage = "Please Create my personalized travel itineraries based on my input. If any of my input is incorrect then only notify me which of my input is incorrect."
    let apiResponseFail = "Sorry, I couldn't process your request at the moment."
    let userResponseToEditDetailsPrompt = "y"
    let zaraFarewellMessage = "Thanks for contacting with Zara. Happy Journey!😊"
}
