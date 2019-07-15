//
//  RecommendedVideos.swift
//  Talha Films
//
//  Created by Moazzam Tahir on 26/05/2019.
//  Copyright © 2019 Moazzam Tahir. All rights reserved.
//

import Foundation
import UIKit

class RecommendedVideo: UICollectionViewCell {
    
    var recommeded: ThumbnailDetails? {
        didSet {
            titleLabel.text = recommeded?.videoTitle
            //dateLabel.text = recommeded?.uploadDate
            loadVideoThumbnailFromUL()
        }
    }
    
    func loadVideoThumbnailFromUL() { //loads video thumbnail image from URL
        if let thumbnailImageURL = recommeded?.videoImageName {
            thumbnailImageView.loadImageUsingURLString(urlString: thumbnailImageURL)
        }
    }
    
    let thumbnailImageView: UIImageView = {
        let image = UIImageView()
        //image.backgroundColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        image.clipsToBounds = true
        //image.layer.masksToBounds = true
        image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    //view for title label
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Video Title"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.clipsToBounds = true
        label.numberOfLines = 5
        //label.contentMode = .left
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    func setupViews() {
        addSubview(thumbnailImageView)
        addSubview(titleLabel)
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0(160)]", options: .directionMask, metrics: nil, views: ["v0": thumbnailImageView]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: .directionMask, metrics: nil, views: ["v0": thumbnailImageView])) //video thumbnail preview
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-1-[v0]", options: .directionMask, metrics: nil, views: ["v0": titleLabel]))
        
        addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .left, relatedBy: .equal, toItem: thumbnailImageView, attribute: .right, multiplier: 1, constant: 8))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
