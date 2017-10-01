//
//  AppDelegate.swift
//  Hubble
//
//  Created by vimrus on 2017/10/1.
//  Copyright © 2017年 Hubble. All rights reserved.
//

import UIKit
import SwiftTheme

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        ThemeManager.setTheme(index: 0)

        self.window = UIWindow(frame:UIScreen.main.bounds)

        let tabBarController = UITabBarController()
        tabBarController.tabBar.theme_tintColor = globalTitleColorPicker

        let homeController = UINavigationController(rootViewController: HomeViewController())
        homeController.tabBarItem = UITabBarItem(
            title: "首页",
            image: UIImage(named: "home"),
            selectedImage: UIImage(named: "home_active")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal))

        let unreadController = UINavigationController(rootViewController: UnreadViewController())
        unreadController.tabBarItem = UITabBarItem(
            title: "阅读",
            image: UIImage(named: "unread"),
            selectedImage: UIImage(named: "unread_active")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal))

        let meController = UINavigationController(rootViewController: MeViewController())
        meController.tabBarItem = UITabBarItem(
            title: "我",
            image: UIImage(named: "me"),
            selectedImage: UIImage(named: "me_active")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal))

        tabBarController.viewControllers = [
            homeController, unreadController, meController
        ]

        self.window?.rootViewController = tabBarController
        self.window?.makeKeyAndVisible()

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
