//
//  ImageDetailViewController.swift
//  TwitterImage
//
//  Created by ShengHua Wu on 22/05/2017.
//  Copyright © 2017 ShengHua Wu. All rights reserved.
//

import UIKit

final class ImageDetailViewController: UIViewController {
    // MARK: Properties
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .yellow
        return imageView
    }()
    
    private lazy var textLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.text = "MVVM is an augmented version of MVC architecture where we formally connect our view and controller, and move the business logic out of the controller and into the view model."
        return label
    }()
    
    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(imageView)
        view.addSubview(textLabel)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        let margin: CGFloat = 16.0
        
        imageView.frame = view.bounds
        
        guard let text = textLabel.text else { return }
        
        let size = CGSize(width: view.bounds.width - margin * 2.0, height: view.bounds.height)
        let rect = text.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName : textLabel.font], context: nil)
        textLabel.frame = CGRect(x: margin, y: view.bounds.height - margin - rect.height, width: rect.width, height: rect.height)
    }
}
