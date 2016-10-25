//
//  AppDelegate.swift
//  Octocat
//
//  Created by 杨弘宇 on 2016/10/23.
//  Copyright © 2016年 杨弘宇. All rights reserved.
//

import UIKit
import OctocatKit

extension Notification.Name {
    
    static let loginPending = Notification.Name(rawValue: "loginPendingNotfication")
    static let loginFinished = Notification.Name(rawValue: "loginFinishedNotfication")
    static let loginFailed = Notification.Name(rawValue: "loginFailedNotfication")
    
}


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    weak var rootViewController: UITabBarController?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        rootViewController = window?.rootViewController as? UITabBarController
        
        let ockSessionManager = OCKSessionManager.default
        ockSessionManager.clientID = gitHubClientID
        ockSessionManager.clientSecret = gitHubClientSecret
        ockSessionManager.registeredCallbackURL = "octocat://oauth_redirect"
        ockSessionManager.containerURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.cyandev.octocatsharing")
        
        ockSessionManager.asyncFromDisk()
        OCKCacheHelper.shared.asyncFromDisk()
        
        OCKURLSessionOperation.register(observer: NetworkActivityIndicatorManager.default)
        
        DispatchQueue.main.asyncAfter(deadline: .now()) { 
            self.presentLoginViewControllerIfNeeded()
        }
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        OCKSessionManager.default.asyncToDisk()
        OCKCacheHelper.shared.asyncToDisk()
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
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        if url.absoluteString.hasPrefix("octocat://octocat.com/oauth_redirect") {
            if let query = url.query {
                let code = query.substring(from: query.index(query.startIndex, offsetBy: 5))
                NotificationCenter.default.post(name: .loginPending, object: nil)
                OCKSessionManager.default.login(withCode: code) {
                    if $0 {
                        NotificationCenter.default.post(name: .loginFinished, object: nil)
                    } else {
                        NotificationCenter.default.post(name: .loginFailed, object: nil)
                    }
                }
                return true
            }
        }
        
        return false
    }

    // MARK: -
    
    @objc func didReceiveNeedReserveAuthorizationNotification(_ notification: Notification) {
        OCKSessionManager.default.logout()
        presentLoginViewControllerIfNeeded()
    }
    
    func presentLoginViewControllerIfNeeded() {
        if OCKSessionManager.default.accessToken == nil {
            rootViewController?.performSegue(withIdentifier: .login, sender: nil)
        }
    }

}

