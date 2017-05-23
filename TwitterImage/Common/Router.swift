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
        let viewModel = ImageListViewModel { [weak viewController = imageListViewController] (state) in
            guard let imageListVC = viewController else { return }
            
            imageListVC.updateUI(with: state)
        }
        imageListViewController.viewModel = viewModel
        
        imageListViewController.didSelect = { (tweet) in
            let imageDetailVC = ImageDetailViewController()
            self.configure(imageDetailVC, with: tweet)
            
            navigationController.pushViewController(imageDetailVC, animated: true)
        }
        
        imageListViewController.presentError = { [weak viewController = imageListViewController] (error) in
            guard let imageListVC = viewController else { return }
            
            let alert = UIAlertController.makeAlert(with: error)
            imageListVC.present(alert, animated: true, completion: nil)
        }
    }
    
    func configure(_ imageDetailViewController: ImageDetailViewController, with tweet: ImageTweet) {
        let viewModel = ImageDetailViewModel(tweet: tweet) { [weak viewController = imageDetailViewController] (state) in
            guard let imageDetailVC = viewController else { return }
            
            imageDetailVC.updateUI(with: state)
        }
        imageDetailViewController.viewModel = viewModel
        
        imageDetailViewController.presentError = { [weak viewController = imageDetailViewController] (error) in
            guard let imageDetailVC = viewController else { return }

            let alert = UIAlertController.makeAlert(with: error)
            imageDetailVC.present(alert, animated: true, completion: nil)
        }
    }
}
