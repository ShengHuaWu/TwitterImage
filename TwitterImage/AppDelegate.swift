//
//  AppDelegate.swift
//  TwitterImage
//
//  Created by ShengHua Wu on 17/05/2017.
//  Copyright © 2017 ShengHua Wu. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = .white
        
        let imagesVC = ImagesViewController()
        let navigationController = UINavigationController(rootViewController: imagesVC)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        return true
    }
}

