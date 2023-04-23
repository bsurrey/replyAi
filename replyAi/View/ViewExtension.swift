//
//  ViewExtension.swift
//  replyAi
//
//  Created by Benjamin on 22.03.23.
//

import SwiftUI

extension View {
    func applyEnvironment(appTheme: AppTheme) -> some View {
        self
            .environmentObject(ThemeManager())
    }
}
