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
            date.text = recommeded?.uploadDate
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
        label.font = UIFont.systemFont(ofSize: 14)
        //label.contentMode = .left
        return label
    }()
    
    let date: UILabel = {
        let label = UILabel()
        label.text = "Date"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    func setupViews() {
        addSubview(thumbnailImageView)
        addSubview(titleLabel)
        addSubview(date)
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0(160)]-1-[v1]|", options: .directionMask, metrics: nil, views: ["v0": thumbnailImageView, "v1": titleLabel]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: .directionMask, metrics: nil, views: ["v0": thumbnailImageView])) //video thumbnail preview
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-3-[v0]", options: .directionMask, metrics: nil, views: ["v0": titleLabel]))
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v0]-3-|", options: .directionMask, metrics: nil, views: ["v0": date]))
        
        addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .left, relatedBy: .equal, toItem: thumbnailImageView, attribute: .right, multiplier: 1, constant: 8))
        addConstraint(NSLayoutConstraint(item: date, attribute: .left, relatedBy: .equal, toItem: thumbnailImageView, attribute: .right, multiplier: 1.0, constant: 1))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
