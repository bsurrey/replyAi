//
//  ChatBubble.swift
//  replyAi
//
//  Created by Benjamin on 21.03.23.
//

import SwiftUI

struct ChatBubble: Shape {
    var isUser: Bool

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: [.topLeft, .topRight, isUser ? .bottomLeft : .bottomRight], cornerRadii: CGSize(width: 12, height: 16))
        return Path(path.cgPath)
    }
}

struct ChatBubble_Previews: PreviewProvider {
    static var previews: some View {
        ChatView(messages: [
            ("hello world", true),
            ("hello world", false),
            ("hello world", true),
            ("hello world", false),
        ])
        .environmentObject(ThemeManager())
    }
}
