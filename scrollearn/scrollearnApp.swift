//
//  scrollearnApp.swift
//  scrollearn
//
//  Created by Leinad Suarez on 2/24/26.
//

import SwiftUI

// AppDelegate to control orientation
class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return .portrait
    }
}

@main
struct ScrollearnApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            HomeView()
        }
    }
}
