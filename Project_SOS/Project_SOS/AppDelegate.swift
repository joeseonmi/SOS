//
//  AppDelegate.swift
//  Project_SOS
//
//  Created by joe on 2017. 9. 5..
//  Copyright © 2017년 joe. All rights reserved.
//

import UIKit
import Firebase
import GoogleMobileAds

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        
        // Initialize the Google Mobile Ads SDK.
        GADMobileAds.configure(withApplicationID: "ca-app-pub-9821073709980211~4294519494")
    
        addUserDataToDatabase()
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
    
    // 해당 유저가 DB.child(User)에 기록되었는지 확인하고 추가합니다.
    func addUserDataToDatabase() {
        Database.database().reference().child(Constants.user).queryOrdered(byChild: Constants.user_userId).queryEqual(toValue: Auth.auth().currentUser?.uid).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if snapshot.childrenCount == 0 {
                Database.database().reference().child(Constants.user).childByAutoId().setValue([Constants.user_userId:Auth.auth().currentUser?.uid])
                UserDefaults.standard.set(Auth.auth().currentUser?.uid, forKey: Constants.userdefault_userUid)
            } else if snapshot.exists() == false {
                Auth.auth().signInAnonymously(completion: { (user, error) in
                    guard let newUser = user else { return }
                    Database.database().reference().child(Constants.user).childByAutoId().setValue([Constants.user_userId:Auth.auth().currentUser?.uid])
                    if let error = error {
                        print("error====================",error.localizedDescription)
                        return
                    }
                })
                
                UserDefaults.standard.set(Auth.auth().currentUser?.uid, forKey: Constants.userdefault_userUid)
            }
            
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    
}

