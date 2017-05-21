//
//  ViewController.swift
//  TwitterImage
//
//  Created by ShengHua Wu on 17/05/2017.
//  Copyright © 2017 ShengHua Wu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    // MARK: Properties
    let webService = WebService(session: URLSession.bearerToken)
    
    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .blue
    
        webService.load(resource: TwitterImage.tweets) { (result) in
            switch result {
            case let .success(tweets):
                print(tweets)
            case let .failure(error):
                print(error)
            }
        }
    }
}

