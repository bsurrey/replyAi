//
//  AppDelegate.swift
//  replyAi
//
//  Created by Benjamin Surrey on 11.04.23.
//

import UIKit
import SwiftUI


class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        let sceneConfiguration = UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
        sceneConfiguration.delegateClass = CustomWindowSceneDelegate.self
        return sceneConfiguration
    }

    class CustomWindowSceneDelegate: UIResponder, UIWindowSceneDelegate {
        var window: UIWindow?
        var themeManager = ThemeManager()

        func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
            guard let windowScene = (scene as? UIWindowScene) else { return }

            let window = UIWindow(windowScene: windowScene)
            self.window = window

            // Set the initial window size
            windowScene.sizeRestrictions?.minimumSize = CGSize(width: 800, height: 600)
            windowScene.sizeRestrictions?.maximumSize = CGSize(width: 1600, height: 1200)

            window.makeKeyAndVisible()
        }
    }

}
