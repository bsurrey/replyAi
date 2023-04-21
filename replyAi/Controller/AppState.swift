//
//  AppState.swift
//  replyAi
//
//  Created by Benjamin Surrey on 21.04.23.
//

import Combine
import SwiftUI

class AppState: ObservableObject {
    @Published var isWelcomeViewPresented: Bool = true
}
