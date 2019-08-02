//
//  CellUIDetails.swift
//  Talha Films
//
//  Created by Moazzam Tahir on 24/05/2019.
//  Copyright © 2019 Moazzam Tahir. All rights reserved.
//

import Foundation
import UIKit

class DetailedCell: UICollectionViewCell {
    
    //this object is derived from videoCellData to show video cell details
    var video: ThumbnailDetails? {
        didSet {
            titleLabel.text = video?.videoTitle
            dateLabel.text = video?.uploadDate
            loadVideoThumbnailFromUL()
            loadChannelProfileImageFromURL()
        }
    }
    
    //loading image from URL for thumbnail
    func loadChannelProfileImageFromURL() { //loads channel profile image from URL.
        if let profileImageURL = video?.channelImageName {
            userProfileImage.loadImageUsingURLString(urlString: profileImageURL)
        }
    }
    
    //loading image from URL for channel image
    func loadVideoThumbnailFromUL() { //loads video thumbnail image from URL
        if let thumbnailImageURL = video?.videoImageName {
            thumbnailImageView.loadImageUsingURLString(urlString: thumbnailImageURL)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    //Declairing the thumbnail image view
    let thumbnailImageView: UIImageView = {
        let image = UIImageView()
        image.backgroundColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    //views seperator line
    let seperatorLine: UIView = {
        let line = UIView()
        line.backgroundColor = #colorLiteral(red: 0.3375922441, green: 0.7577283382, blue: 0.9999999404, alpha: 1)
        line.translatesAutoresizingMaskIntoConstraints = false
        return line
    }()
    
    //view for user profile image
    let userProfileImage: UIImageView = {
        let image = UIImageView()
        image.backgroundColor = #colorLiteral(red: 0.3375922441, green: 0.7577283382, blue: 0.9999999404, alpha: 1)
        image.translatesAutoresizingMaskIntoConstraints = false
        image.layer.masksToBounds = true
        image.layer.cornerRadius = 22
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    //view for title label
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Video Title"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 3
        label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.text = "Date"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 10)
        return label
    }()
    
    
    func setupViews(){
        addSubview(thumbnailImageView) //subview in a cell for image
        addSubview(seperatorLine) //subview for the seperator line
        addSubview(userProfileImage) //subview for the user profile
        addSubview(titleLabel) //subview for title label
        addSubview(dateLabel)
        
        //height constraints
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[v0]-10-|", options: .directionMask, metrics: nil, views: ["v0": thumbnailImageView])) //video thumbnail preview
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[v0(44)]", options: .directionMask, metrics: nil, views: ["v0": userProfileImage])) //user profile image view
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: .directionMask, metrics: nil, views: ["v0": seperatorLine])) //seperator line view
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-10-[v0]-8-[v1(44)]-5-[v2]-5-[v3(1)]|", options: .directionMask, metrics: nil, views: ["v0": thumbnailImageView, "v1": userProfileImage, "v2": dateLabel, "v3": seperatorLine])) //vertical constraints
        
        //for title label view
        //constraint to the top of thumbnail image
        addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .top, relatedBy: .equal, toItem: thumbnailImageView, attribute: .bottom, multiplier: 1, constant: 8))
        
        addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .left, relatedBy: .equal, toItem: userProfileImage, attribute: .right, multiplier: 1, constant: 8))
        
        addConstraint(NSLayoutConstraint(item: dateLabel, attribute: .left, relatedBy: .equal, toItem: userProfileImage, attribute: .right, multiplier: 1, constant: 8))
        //constraint to the right of thumbnail image
        addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .right, relatedBy: .equal, toItem: thumbnailImageView, attribute: .right, multiplier: 1, constant: 0))
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
