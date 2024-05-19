import SwiftUI

@MainActor
class ChatScreenViewModel: ObservableObject {
    
    let url = URL(string: Constants.shared.apiUrl)!
    let apiKey = Constants.shared.apiKey
    
    @Published var userDetails = UserDetails()
    @Published var message = Constants.shared.empty
    @Published var chatMessages = [ChatMessage]()
    @Published var isWaitingForResponse = false
    @Published var disableChat = false
    
    let questions = Constants.shared.allQuestionsAskedfromZara
    
    var currentQuestionIndex = 0
    
    func sendMessage() async throws {
    
        let userMessage = ChatMessage(message)
        chatMessages.append(userMessage)
        
        switch currentQuestionIndex {
        case 1:
            userDetails.location = message
        case 2:
            if let numberOfTravelers = Int(message) {
                userDetails.NumberofTravellers = numberOfTravelers
            }
        case 3:
            if let duration = Int(message) {
                userDetails.Duration = duration
            }
        case 4:
            userDetails.Interest = message
        case 5:
            if message.lowercased().starts(with: Constants.shared.userResponseToEditDetailsPrompt){
                currentQuestionIndex = 0
            }
        default:
            break
        }
        
        if currentQuestionIndex < questions.count {
            let questionMessage = ChatMessage(owner: .Bot, questions[currentQuestionIndex])
            chatMessages.append(questionMessage)
        }
        
        message = Constants.shared.empty
        
        if currentQuestionIndex == questions.count {
            
            let prompt = "Location is \(userDetails.location!), Number of travelers is \(userDetails.NumberofTravellers!), Duration is \(userDetails.Duration!)days, Interests in \(userDetails.Interest!). \(Constants.shared.promptMessage)"
            
            // Getting data from api
            generateResponse(prompt: prompt) { response, error in
                DispatchQueue.main.async {
                    if let response = response {
                        
                        self.chatMessages.append(ChatMessage(owner: .Bot, response))
                       
                    } else {
                        self.chatMessages.append(ChatMessage(owner: .Bot, Constants.shared.apiResponseFail))
                    }
                }
            }
            
            currentQuestionIndex = -1
        }
        
        currentQuestionIndex += 1
    }
    
    // API Call
    func generateResponse(prompt: String, completionHandler: @escaping (String?, Error?) -> Void) {
        var request = URLRequest(url: url)
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"

        let parameters: [String: Any] = [
            "model": "gpt-3.5-turbo",
            "messages": [
                ["role": "user", "content": prompt]
            ]
        ]
        request.httpBody = try? JSONSerialization.data(
            withJSONObject: parameters,
            options: []
        )
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                completionHandler(nil, error)
                return
            }

            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]

                if let choices = json?["choices"] as? [[String: Any]],
                   let message = choices.first?["message"] as? [String: Any],
                   let content = message["content"] as? String {
                    completionHandler(content, nil)
                } else {
                    completionHandler(nil, error)
                }
            } catch {
                completionHandler(nil, error)
            }
            DispatchQueue.main.async {
                self.isWaitingForResponse = false
                self.disableChat = true
            }
        }
        task.resume()
        DispatchQueue.main.async {
            self.isWaitingForResponse = true
        }
    }
}
