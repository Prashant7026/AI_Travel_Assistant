
import SwiftUI
import CoreData

struct ChatScreen: View {
    
    @StateObject private var ViewModel = ChatScreenViewModel()
    var location: String?
    var NumberofTravellers: Int?
    var Duration: Int?
    @State private var openChatBot: Bool = false
    
    var body: some View {
        
        NavigationView {
            ZStack {
                Color.blue.opacity(0.1)
                    .edgesIgnoringSafeArea(.all)
                VStack {
                    ScrollViewReader { proxy in
                        VStack {
                            ScrollView {
                                LazyVStack(spacing: 16.0) {
                                    
                                    messageView(ChatMessage(owner: .Bot, Constants.shared.firstDefaultMessageofZara))
                                    
                                    ForEach(ViewModel.chatMessages) { message in
                                        messageView(message)
                                    }
                                    if(ViewModel.disableChat) {
                                        messageView(ChatMessage(owner: .Bot, Constants.shared.zaraFarewellMessage))
                                    }
                                    
                                    Color.clear
                                        .frame(height: 1.0)
                                        .id("bottom")
                                }
                            }
                            .onReceive(ViewModel.$chatMessages.throttle(for: 0.5, scheduler: RunLoop.main, latest: true)) { chatMessages  in
                                guard !chatMessages.isEmpty else { return }
                                withAnimation {
                                    proxy.scrollTo("bottom")
                                }
                            }
                        }
                        .padding(.top, 10.0)
                    }
                    
                    VStack(alignment: .leading) {
                        if ViewModel.isWaitingForResponse {
                            BotTyping()
                        }
                        if(!ViewModel.disableChat){
                            HStack {
                                TextField(Constants.shared.textFieldPlaceholder, text: Binding<String>(
                                    get: { ViewModel.currentQuestionIndex == 0 ? Constants.shared.empty : ViewModel.message },
                                    set: { newValue in ViewModel.message = newValue }
                                ), axis: .vertical)
                                .textFieldStyle(.roundedBorder)
                                .frame(maxHeight: 33.0)
                                
                                if ViewModel.isWaitingForResponse {
                                    ProgressView()
                                        .padding()
                                } else {
                                    Button(action: {
                                        sendMessage()
                                    }, label: {
                                        Image(systemName: "paperplane.fill")
                                    })
                                    .buttonStyle(.borderedProminent)
                                    .disabled(ViewModel.message.isEmpty)
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    
                }
                .blur(radius: openChatBot ? 3.5 : 0.0)
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    openChatBot.toggle()
                }
            }
            .alert(isPresented: $openChatBot) {
                Alert(title: Text(Constants.shared.welcome),
                      message: Text(Constants.shared.instructionMessage),
                      dismissButton: .default(Text(Constants.shared.ok)){
                    openChatBot = false
                    sendMessage()
                })
            }
        }
        .navigationTitle(Constants.shared.botName)
    }
    
    //MARK: - Functions
    
    // Creating bubble of chat
    func messageView(_ message: ChatMessage) -> some View {
        HStack {
            if message.owner == .User {
                Spacer(minLength: 60.0)
            }
            
            if !message.text.isEmpty {
                
                VStack {
                    HStack(alignment: .bottom) {
                        if(message.owner == .Bot){
                            Image("Botlogo")
                                .resizable()
                                .frame(width: 35, height: 35)
                                .clipShape(Circle())
                        }
                        
                        Text(message.text)
                            .foregroundColor(message.owner == .User ? .white : .black)
                            .padding(12)
                            .background(message.owner == .User ? .blue : .white)
                            .cornerRadius(16.0)
                            .overlay(alignment: message.owner == .User ? .topTrailing : .topLeading) {
                                Text(message.owner == .Bot ? Constants.shared.botName.capitalized : message.owner.rawValue.capitalized)
                                    .foregroundColor(.gray)
                                    .font(.caption)
                                    .offset(y: -16.0)
                            }
                            .overlay(alignment: message.owner == .User ? .bottomTrailing : .bottomLeading) {
                                Image(systemName: "arrowtriangle.down.fill")
                                    .rotationEffect(.degrees(message.owner == .Bot ? 45: -45))
                                    .offset(x: message.owner == .Bot ? -7 : 7, y: 5)
                                    .foregroundColor(message.owner == .Bot ? .white : .blue)
                            }
                        if(message.owner == .User) {
                            Image(systemName: "person.crop.circle")
                                .resizable()
                                .frame(width: 35, height: 35)
                        }
                    }
                    Spacer()
                }
            }
            
            if message.owner == .Bot {
                Spacer(minLength: 60.0)
            }
        }
        .padding(.horizontal)
    }
    
    func BotTyping() -> some View {
        Text(Constants.shared.zaraTypingMessage)
            .font(.system(size: 12.0))
            .frame(height: 2.0)
            .padding(.horizontal)
            .padding(.top)
    }
    
    func sendMessage() {
        Task {
            do {
                try await ViewModel.sendMessage()
                
                if ViewModel.currentQuestionIndex == ViewModel.questions.count {
                    ViewModel.message = Constants.shared.empty
                }
                
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}

#Preview {
    ChatScreen().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
