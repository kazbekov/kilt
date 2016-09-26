//
//  AppDelegate.swift
//  Kilt
//
//  Created by Nurdaulet Bolatov on 7/25/16.
//  Copyright © 2016 Nurdaulet Bolatov. All rights reserved.
//

import UIKit
import Sugar
import GoogleMaps
import Firebase
import FirebaseMessaging
import FirebaseInstanceID
import FBSDKCoreKit
import Fabric
import Crashlytics

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
      
        setUpNotificationSettings(application)
        GMSServices.provideAPIKey("AIzaSyANMkNsU3NBYjg-d4WGZafLeJcvmj1hD1M")
        setUpThirdParties(application, launchOptions: launchOptions)
        setUpTabBarAppearance()
        setUpNavigationBarAppearance()
        coordinateAppFlow()
        OneSignal(launchOptions: launchOptions, appId: "d626e413-2474-4ab4-8d54-f342350bc057")
        OneSignal.defaultClient().registerForPushNotifications()
      
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        FIRMessaging.messaging().disconnect()
        print("Disconnected from FCM")
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        FBSDKAppEvents.activateApp()
        connectToFcm()
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        let tokenChars = UnsafePointer<CChar>(deviceToken.bytes)
        var tokenString = ""
        
        for i in 0..<deviceToken.length {
            tokenString += String(format: "%02.2hhx", arguments: [tokenChars[i]])
        }
        
        //Tricky line
        FIRInstanceID.instanceID().setAPNSToken(deviceToken, type: FIRInstanceIDAPNSTokenType.Unknown)
        print("Device Token:", tokenString)
    }
    
    func application(application: UIApplication, didRegisterUserNotificationSettings notificationSettings: UIUserNotificationSettings) {
        print("\(#function)")
    }
    
    func application(app: UIApplication, openURL url: NSURL, options: [String : AnyObject]) -> Bool {
        if #available(iOS 9.0, *) {
            return FBSDKApplicationDelegate.sharedInstance().application(app,
                                                                         openURL: url,
                                                                         sourceApplication: options[UIApplicationOpenURLOptionsSourceApplicationKey] as! String,
                                                                         annotation: options [UIApplicationOpenURLOptionsAnnotationKey])
        }
        return true
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
    }
    
    //MARK: Push-notification Firebase
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject],
                     fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        
//        print("Message ID: \(userInfo["gcm.message_id"]!)")
//        print(userInfo)
    }

    // [START refresh_token]
    func tokenRefreshNotification(notification: NSNotification) {
        if let refreshedToken = FIRInstanceID.instanceID().token() {
            print("InstanceID token: \(refreshedToken)")
        }
        
        // Connect to FCM since connection may have failed when attempted before having a token.
        connectToFcm()
    }
    // [END refresh_token]
    
    // [START connect_to_fcm]
    func connectToFcm() {
        FIRMessaging.messaging().connectWithCompletion { (error) in
            if (error != nil) {
                print("Unable to connect with FCM. \(error)")
            } else {
                print("Connected to FCM.")
            }
        }
    }
    // [END connect_to_fcm]
    // End of pufh-notification
    
}

extension AppDelegate {
    
    private func coordinateAppFlow() {
        window = UIWindow(frame: UIScreen.mainScreen().bounds).then {
            $0.backgroundColor = .whiteColor()
        }
        if let _ = FIRAuth.auth()?.currentUser {
            loadMainPages()
        } else {
            loadLoginPages()
        }
    }
    
    func loadMainPages() {
        window?.rootViewController = MainTabBarController()
        window?.makeKeyAndVisible()
    }
    
    func loadLoginPages() {
        window?.rootViewController = UINavigationController(rootViewController: WelcomeViewController())
        window?.makeKeyAndVisible()
    }
    
    private func setUpThirdParties(application: UIApplication, launchOptions: [NSObject: AnyObject]?) {
        FIRApp.configure()
        GMSServices.provideAPIKey("AIzaSyDZOGyRuy1hgxhGM6KAaGRN0l0Po8m7wys")
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        Fabric.with([Crashlytics.self])
    }
    
    private func setUpTabBarAppearance() {
        UITabBarItem.appearance().then {
            $0.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.tundoraColor()], forState: .Normal)
            $0.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.appColor()], forState: .Selected)
        }
    }
    
    private func setUpNavigationBarAppearance() {
        UINavigationBar.appearance().then {
            $0.tintColor = .whiteColor()
            $0.translucent = false
            $0.barStyle = .Black
            $0.barTintColor = .appColor()
        }
    }
    
    private func setUpNotificationSettings(application: UIApplication){
        let notificationTypes : UIUserNotificationType = [UIUserNotificationType.Alert, UIUserNotificationType.Badge, UIUserNotificationType.Sound]
        let notificationSettings = UIUserNotificationSettings(forTypes: notificationTypes, categories: nil)
        application.registerForRemoteNotifications()
        application.registerUserNotificationSettings(notificationSettings)
        
        
        NSNotificationCenter.defaultCenter().addObserver(self,
                                                         selector: #selector(self.tokenRefreshNotification),
                                                         name: kFIRInstanceIDTokenRefreshNotification,
                                                         object: nil)
    }
    
}
