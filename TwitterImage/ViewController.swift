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
        
        let url = URL(string: "https://api.twitter.com/oauth2/token")!
        let parameters: [String : Any] = ["grant_type" : "client_credentials"]
        let method = HttpMethod.post(parameters)
        let resource = Resource(url: url, httpMethod: method, parseJSON: convert)
        
        webService.load(resource: resource) { (result) in
            print(result)
        }
    }
    
    func convert(json: Any) -> [String : Any]? {
        return json as? [String : Any]
    }
}

