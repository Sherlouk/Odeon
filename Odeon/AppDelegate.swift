//
//  AppDelegate.swift
//  Odeon
//
//  Created by Sherlock, James on 16/12/2018.
//  Copyright © 2018 Sherlouk. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        if let window = window {
            let loadingViewController = TempLoadingViewController.create()
            loadingViewController.onCompletion = { preload in
                self.switchToMainView(window: window, preload: preload)
            }
            
            window.rootViewController = loadingViewController
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

    // MARK: - Transition to Main View
    
    func switchToMainView(window: UIWindow, preload: OdeonPreloadFetcher.Preload) {
        // Create Tab Bar Controller
        let tabBarController = UITabBarController()
        
        // Create View Controllers
        let homeViewController: HomeViewController = {
            let viewController = HomeViewController.create()
            viewController.preload = preload
            
            return viewController
        }()
        
        let membersViewController = MembersViewController.create()
        
        let settingsViewController: SettingsViewController = {
            let viewController = SettingsViewController.create()
            viewController.preload = preload
            
            return viewController
        }()
        
        // Customise Tab Bar Controller
        tabBarController.tabBar.barTintColor = .black
        tabBarController.tabBar.tintColor = UIColor(named: "Profile/StarActive")
        tabBarController.tabBar.unselectedItemTintColor = UIColor(named: "Profile/SecondaryText")
        
        // Set View Controllers
        let viewControllers = [
            TransparentNavigationViewController(rootViewController: homeViewController),
            membersViewController,
            settingsViewController
        ]
        
        tabBarController.setViewControllers(viewControllers, animated: false)
        
        // Transition window's rootViewController, animated if enabled
        let setWindow: () -> Void = {
            window.rootViewController = tabBarController
        }
        
        if trueUnlessReduceMotionEnabled {
            UIView.transition(
                with: window,
                duration: 0.5,
                options: .transitionCrossDissolve,
                animations: setWindow,
                completion: nil
            )
        } else {
            setWindow()
        }
    }

}

