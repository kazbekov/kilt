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
import FirebaseAuth
import FBSDKCoreKit
import Fabric
import Crashlytics
import FirebaseMessaging

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        FIRApp.configure()
        GMSServices.provideAPIKey("AIzaSyANMkNsU3NBYjg-d4WGZafLeJcvmj1hD1M")
        setUpThirdParties(application, launchOptions: launchOptions)
        setUpTabBarAppearance()
        setUpNavigationBarAppearance()
        coordinateAppFlow()
        
        let settings: UIUserNotificationSettings =
            UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil)
        application.registerUserNotificationSettings(settings)
        application.registerForRemoteNotifications()
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        FBSDKAppEvents.activateApp()
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
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
    
    //MARK: PushNotification Firebase
    func tokenRefreshNotification(notification: NSNotification) {
        if let refreshedToken = FIRInstanceID.instanceID().token() {
            print("InstanceID token: \(refreshedToken)")
        }
        
        // Connect to FCM since connection may have failed when attempted before having a token.
        connectToFcm()
    }
    
    func connectToFcm() {
        FIRMessaging.messaging().connectWithCompletion { (error) in
            if (error != nil) {
                print("Unable to connect with FCM. \(error)")
            } else {
                print("Connected to FCM.")
            }
        }
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject],
                     fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        
        // Print message ID.
        print("Message ID: \(userInfo["gcm.message_id"]!)")
        
        // Print full message.
        print("%@", userInfo)
    }

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
    
}
