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
        imageView.backgroundColor = .black
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var spinner = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
    
    private(set) lazy var textLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textColor = .white
        return label
    }()
    
    var viewModel: ImageDetailViewModel!
    var presentError: ((Error) -> ())?
    
    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(imageView)
        view.addSubview(spinner)
        view.addSubview(textLabel)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.downloadImage { [weak self] (url) in
            guard let strongSelf = self else { return }
            
            let data = try! Data(contentsOf: url)
            strongSelf.imageView.image = UIImage(data: data)
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        let margin: CGFloat = 16.0
        
        imageView.frame = view.bounds
        
        spinner.sizeToFit()
        spinner.center = CGPoint(x: view.bounds.midX, y: view.bounds.midY)
        
        guard let text = textLabel.text else { return }
        
        let size = CGSize(width: view.bounds.width - margin * 2.0, height: view.bounds.height)
        let rect = text.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName : textLabel.font], context: nil)
        textLabel.frame = CGRect(x: margin, y: view.bounds.height - margin - rect.height, width: rect.width, height: rect.height)
    }
    
    // MARK: Public Methods
    func updateUI(with state: State<ImageTweet>) {
        switch state {
        case .loading:
            spinner.startAnimating()
        case let .error(error):
            spinner.stopAnimating()
            
            presentError?(error)
        case let .normal(tweet):
            spinner.stopAnimating()
            
            title = tweet.userName
            textLabel.text = tweet.text
        }
    }
}
