//
//  Router.swift
//  TwitterImage
//
//  Created by ShengHua Wu on 23/05/2017.
//  Copyright © 2017 ShengHua Wu. All rights reserved.
//

import UIKit

struct Router {
    func configure(_ window: UIWindow?) {
        let imageListVC = ImageListViewController()
        let navigationController = UINavigationController(rootViewController: imageListVC)
        
        configure(imageListVC, in: navigationController)
        
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
    
    func configure(_ imageListViewController: ImageListViewController, in navigationController: UINavigationController) {
        imageListViewController.didSelect = { (indexPath) in
            let imageDetailVC = ImageDetailViewController()
            navigationController.pushViewController(imageDetailVC, animated: true)
        }
    }
}
