//
//  AppDelegate.swift
//  Wallet
//
//  Created by 김한별 on 2023/03/13.
//

import UIKit
import Firebase

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        
        // Override point for customization after application launch.
        FirebaseApp.configure()
        
        // Instantiate the window object
            window = UIWindow(frame: UIScreen.main.bounds)
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if UserDefaults.standard.bool(forKey: "autoLogin") == true {
                // 자동 로그인 스위치가 켜져 있으면,
                let mainViewController = storyboard.instantiateViewController(withIdentifier: "TabBarController") as! TabBarViewController
                window?.rootViewController = mainViewController
            } else {
                let mainViewController = storyboard.instantiateViewController(withIdentifier: "LoginController") as! LogInViewController
                window?.rootViewController = mainViewController
            }
            
            // Set the key window
            window?.makeKeyAndVisible()
        
        print(window)
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { _, _ in
                    
                }
                
                application.registerForRemoteNotifications()
        
        
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

