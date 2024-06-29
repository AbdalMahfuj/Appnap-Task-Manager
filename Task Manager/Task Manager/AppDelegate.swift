//
//  AppDelegate.swift
//  Task Manager
//
//  Created by Mahfuz on 27/6/24.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
      
                
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        
        
        var bgConfig = UIBackgroundConfiguration.listPlainCell()
        bgConfig.backgroundColor = UIColor.clear
        UITableViewHeaderFooterView.appearance().backgroundConfiguration = bgConfig
        
        
        UITableView.appearance().sectionHeaderTopPadding = 0
        
        let textColor = UIColor.white
        let barColor = UIColor.systemCyan
        
        let navigationBarAppearace = UINavigationBar.appearance()
        navigationBarAppearace.isTranslucent = false
        
        navigationBarAppearace.shadowImage = UIImage()
        navigationBarAppearace.setBackgroundImage(UIImage(), for: .default)

        
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithTransparentBackground()

        navBarAppearance.titleTextAttributes = [.foregroundColor: textColor]
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: textColor]
        navBarAppearance.backgroundColor = barColor
        
        navigationBarAppearace.standardAppearance = navBarAppearance
        navigationBarAppearace.compactAppearance = navBarAppearance
        navigationBarAppearace.scrollEdgeAppearance = navBarAppearance
        
        IQKeyboardManager.shared.enable = true
        
        let homeVC = TaskListViewController.initVC()
        let navVC = UINavigationController(rootViewController: homeVC)
        navVC.isNavigationBarHidden = false
        window?.rootViewController = navVC
        
        SyncManager.shared.appStarted()
        
        return true
    }

}

