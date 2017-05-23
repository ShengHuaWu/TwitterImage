//
//  UIAlertController+Helpers.swift
//  TwitterImage
//
//  Created by ShengHua Wu on 23/05/2017.
//  Copyright © 2017 ShengHua Wu. All rights reserved.
//

import UIKit

extension UIAlertController {
    static func makeAlert(with error: Error) -> UIAlertController {
        let alert = UIAlertController(title: nil, message: error.localizedDescription, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        return alert
    }
}
