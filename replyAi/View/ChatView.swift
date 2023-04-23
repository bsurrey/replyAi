//
//  ChatView.swift
//  replyAi
//
//  Created by Benjamin on 21.03.23.
//

import SwiftUI
import Combine

struct ChatView: View {
    @State private var message: String = ""
    @State var messages: [(String, Bool)] = []
    @State private var isSending: Bool = false
    @State private var showSettingsView = false
    @State private var showErrorAlert = false
    @State private var errorMessage = ""
    @State private var remainingChars: Int = 500
    @State private var showClearAlert = false
    @State private var pasteboardText: String?
    @State private var showSettings = false
    
    @StateObject var chat: Chat = Chat()
    
    @Environment(\.colorScheme) private var systemColorScheme
    @Environment(\.appTheme) private var appTheme
    @EnvironmentObject var themeManager: ThemeManager
    
    // @AppStorage("prompt") var prompt: String?
    @State var prompt: String = "Reply to the entered Text in german, be helpful, creative, clever, funny or reply in thr same style and slang."
    @AppStorage("sendDirectly") var sendDirectly: Bool?
    
    var body: some View {
        ZStack {
            NavigationStack {
                VStack {
                    ScrollView {
                        ScrollViewReader { proxy in
                            VStack(alignment: .leading, spacing: 8) {
                                ForEach(chat.messages, id: \.self) { message in
                                    let isUser = message.fromUser
                                    
                                    HStack {
                                        if isUser {
                                            Spacer()
                                        }
                                        if index == messages.count - 1 && !isUser && isSending {
                                            ProgressView()
                                                .frame(width: 30, height: 30)
                                                .background(ChatBubble(isUser: isUser).fill(Color.gray))
                                                .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                                                .id(index)
                                            
                                        } else {
                                            HStack {
                                                Text(msg)
                                                    .padding(10)
                                                    .background(ChatBubble(isUser: isUser).fill(isUser ? Color.blue : Color.gray))
                                                    .foregroundColor(isUser ? Color.white : Color.black)
                                                    .transition(.asymmetric(insertion: .move(edge: isUser ? .trailing : .leading), removal: .move(edge: isUser ? .leading : .trailing)))
                                                    .id(index)
                                                    .contextMenu {
                                                        if !isUser {
                                                            Button(action: {
                                                                // Handle share action
                                                                shareMessage(index: index)
                                                            }) {
                                                                Label("Share", systemImage: "square.and.arrow.up")
                                                            }
                                                        }
                                                    }
                                                if !isUser {
                                                    Button(action: {
                                                        // Handle share action
                                                        shareMessage(index: index)
                                                    }) {
                                                        Image(systemName: "square.and.arrow.up")
                                                            .foregroundColor(.gray)
                                                    }
                                                }
                                            }
                                        }
                                        if !isUser {
                                            Spacer()
                                        }
                                    }
                                    .onAppear {
                                        withAnimation(.spring(response: 0.5, dampingFraction: 0.5, blendDuration: 0)) {
                                            proxy.scrollTo(index, anchor: .bottom)
                                        }
                                    }
                                }
                            }
                        }
                    }.padding(.horizontal)
                    
                    HStack {
                        HStack {
                            VStack {
                                TextField("Type your message...", text: limitedTextBinding($message, maxLength: 500), onCommit: sendMessageDirect)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .disabled(isSending)
                                    .frame(height: 50)
                                    .lineLimit(4)
                                    .submitLabel(.send)
                                    .onChange(of: pasteboardText) { value in
                                        // Handle shared text
                                        guard let sharedText = value else {
                                            return
                                        }
                                        message += sharedText
                                        pasteboardText = nil
                                    }
                            }
                            HStack {
                                Button(action: {
                                    message = ""
                                    remainingChars = 500
                                }) {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundColor(.gray)
                                }.disabled(isSending)
                                
                                Text("\(remainingChars)")
                                    .font(.footnote)
                                    .foregroundColor(.gray)
                                
                                if isSending {
                                    ProgressView()
                                        .padding(.trailing)
                                }
                            }
                        }
                        .padding(.horizontal)
                    }.background(Color(.systemGray6))
                }
                
                
            }
            // .toolbar(.hidden, for: .tabBar)

        }
            .preferredColorScheme(themeManager.currentColorScheme) // Use the currentColorScheme property
            .alert(isPresented: $showClearAlert) {
                Alert(title: Text("Clear Chat Log"), message: Text("Are you sure you want to clear the chat log?"), primaryButton: .destructive(Text("Clear")) {
                    messages.removeAll()
                }, secondaryButton: .cancel())
            }
            .navigationBarItems(trailing: Button(action: {
                showClearAlert.toggle()
            }) {
                Image(systemName: "xmark")
                    .imageScale(.large)
                    .frame(width: 44, height: 44, alignment: .trailing)
            })
    }
    
    private func shareMessage(index: Int) {
        let message = messages[index].0
        let activityController = UIActivityViewController(activityItems: [message], applicationActivities: nil)
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootViewController = windowScene.windows.first?.rootViewController {
            rootViewController.present(activityController, animated: true, completion: nil)
        }
    }
    
    // Custom Binding to limit text field characters
    private func limitedTextBinding(_ text: Binding<String>, maxLength: Int) -> Binding<String> {
        Binding<String>(
            get: { text.wrappedValue },
            set: { newValue in
                if newValue.count <= maxLength {
                    text.wrappedValue = newValue
                    remainingChars = maxLength - newValue.count
                }
            }
        )
    }
    
    func sendMessage() {
        guard !message.isEmpty else { return }
        isSending = true
        let url = URL(string: "https://replyai.test/api/chat")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = "message=\(message)".data(using: .utf8)
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let data = data, let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any], let responseMessage = jsonResponse["message"] as? String {
                    messages.append(("\(message)", true))
                    messages.append(("\(responseMessage)", false))
                    message = ""
                } else {
                    messages.append(("Error: Could not send message.", false))
                }
                isSending = false
            }
        }.resume()
    }
    
    
    func sendMessageDirect() {
        guard !message.isEmpty else { return }
        isSending = true
        
        let apiKey = "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"
        let url = URL(string: "https://api.openai.com/v1/engines/text-davinci-003/completions")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let prompt = prompt + "\n\nHuman: " + message + "\n\nResponse:"
        let payload: [String: Any] = [
            "prompt": prompt,
            "temperature": 0.8,
            "max_tokens": 150,
            "top_p": 1,
            "frequency_penalty": 0,
            "presence_penalty": 0.6,
            "stop": ["Human:", "Response:"]
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: payload)
        
        URLSession.shared.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            DispatchQueue.main.async {
                if let data = data, let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any], let choices = jsonResponse["choices"] as? [[String: Any]], let responseMessage = choices.first?["text"] as? String {
                    messages.append(("\(message)", true))
                    messages.append(("\(responseMessage)", false))
                    message = ""
                } else {
                    messages.append(("Error: Could not send message.", false))
                }
                
                isSending = false
            }
        }.resume()
    }
    
}

// Add a custom TextFieldDelegate class to limit characters
class TextFieldDelegate: NSObject, UITextFieldDelegate {
    private let shouldChangeCharacters: (_ string: String, _ textField: UITextField) -> Bool
    
    init(shouldChangeCharacters: @escaping (_ string: String, _ textField: UITextField) -> Bool) {
        self.shouldChangeCharacters = shouldChangeCharacters
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        shouldChangeCharacters(string, textField)
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView(messages: [
            ("Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua.", true),
            ("Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua.", false),
            ("Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua.", true),
            ("Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua.", false),
            ("Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua.", true),
            ("Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua.", false),
            ("Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua.", true),
            ("Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua.", false),
        ])
        .environmentObject(ThemeManager())
    }
}

struct TextFieldHeightPreferenceKey: PreferenceKey {
    typealias Value = CGFloat
    
    static var defaultValue: CGFloat = 80
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}
