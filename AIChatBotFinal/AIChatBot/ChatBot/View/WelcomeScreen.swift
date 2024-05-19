//
//  ContentView.swift
//  AIChatBot
//
//  Created by MacBook Pro on 26/03/24.
//

import SwiftUI

struct WelcomeScreen: View {
    var body: some View {
        NavigationView {
            VStack {
                Image("ZARA")
                ZStack(alignment: .top) {
                    Group{
                        Text("Hi I am ")+Text(Constants.shared.botName).bold()
                        Text("\n\(Constants.shared.welcomeScreenMessage)")
                    }
                    .multilineTextAlignment(.center)
                    .foregroundColor(.black)
                    .padding()
                }
                Spacer()
                ZStack(alignment: .bottom) {
                    NavigationLink(destination: ChatScreen()) {
                        Text(Constants.shared.startChatButtonText)
                            .frame(width: 200, height: 50)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .bold()
                            .clipShape(Capsule())
                    }
                }
            }
            .frame(maxWidth: 380.0, maxHeight: 500.0)
        }
    }
}

#Preview {
    WelcomeScreen().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
