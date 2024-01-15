//
//  AppDelegate.swift
//  TemizOperasyon
//
//  Created by Furkan Bekil on 18.04.2018.
//  Copyright © 2018 Furkan Bekil. All rights reserved.
//

import UIKit
import Firebase
import Bagel
import IQKeyboardManager

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        UIApplication.shared.statusBarStyle = .lightContent
        
        // Start Bagel
        Bagel.start()
        
        // Implement IQKeyboardManager
        IQKeyboardManager.shared().isEnabled = true
        IQKeyboardManager.shared().shouldResignOnTouchOutside = true
        
        if ((UserDefaults.standard.string(forKey: "userToken")) != nil) {

            DataManager.userToken = UserDefaults.standard.string(forKey: "userToken")!
            DataManager.userName = UserDefaults.standard.string(forKey: "userName")!
            DataManager.userID = UserDefaults.standard.integer(forKey: "userID")
            DataManager.userType = UserDefaults.standard.integer(forKey: "userType")
            
            if DataManager.userType == 8 {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                
                let initialViewController = storyboard.instantiateViewController(withIdentifier: "operationBag")

                self.window?.rootViewController = initialViewController
                self.window?.makeKeyAndVisible()
            } else {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                
                let initialViewController = storyboard.instantiateViewController(withIdentifier: "operation")

                self.window?.rootViewController = initialViewController
                self.window?.makeKeyAndVisible()
            }
 
            


        } else {

            let storyboard = UIStoryboard(name: "Main", bundle: nil)

            let initialViewController = storyboard.instantiateViewController(withIdentifier: "login")

            self.window?.rootViewController = initialViewController
            self.window?.makeKeyAndVisible()

        }
        
        FirebaseApp.configure()
        
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

