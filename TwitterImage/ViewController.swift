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
    let webService = WebService()
    
    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .blue
        
        webService.load(resource: bearerToken()) { (result) in
            switch result {
            case .success:
                print(UserDefaults.standard.bearerToken() ?? "Not saving")
            case let .failure(error):
                print(error)
            }
        }
    }
}

