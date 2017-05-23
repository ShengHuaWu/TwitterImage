//
//  ImageCell.swift
//  TwitterImage
//
//  Created by ShengHua Wu on 22/05/2017.
//  Copyright © 2017 ShengHua Wu. All rights reserved.
//

import UIKit

class ImageCell: UICollectionViewCell {
    // MARK: Properties
    private(set) lazy var nameLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private(set) lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .black
        return imageView
    }()
    
    // MRRK: Designated Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(nameLabel)
        contentView.addSubview(imageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Layouts
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let margin: CGFloat = 8.0
        let interval: CGFloat = 8.0
        let width = contentView.bounds.width - margin * 2.0
        let height = contentView.bounds.height - margin * 2.0 - interval
        
        nameLabel.frame = CGRect(x: margin, y: margin, width: width, height: height * 0.2)
        imageView.frame = CGRect(x: nameLabel.frame.minX, y: nameLabel.frame.maxY + interval, width: nameLabel.frame.width, height: height * 0.8)
    }
    
    // MARK: Reuse
    override func prepareForReuse() {
        super.prepareForReuse()
        
        imageView.image = nil
    }
}
