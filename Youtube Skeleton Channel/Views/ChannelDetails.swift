//
//  ChannelDetails.swift
//  Talha Films
//
//  Created by Moazzam Tahir on 26/05/2019.
//  Copyright © 2019 Moazzam Tahir. All rights reserved.
//

import Foundation
import UIKit

class ChannelVideosDetails: UICollectionViewCell {
    
    var playlistVideo: PlaylistItems? {
        didSet {
            titleLabel.text = playlistVideo?.playlistTitle
            loadPlaylistThumbnailFromUL()
        }
    }
    
    func loadPlaylistThumbnailFromUL() { //loads video thumbnail image from URL
        if let thumbnailImageURL = playlistVideo?.playlistImage {
            thumbnailImageView.loadImageUsingURLString(urlString: thumbnailImageURL)
        }
    }
    
    var video: ThumbnailDetails? {
        didSet {
            titleLabel.text = video?.videoTitle
            loadVideoThumbnailFromUL()
        }
    }
    
    func loadChannelProfileImageFromURL() { //loads channel profile image from URL.
        if let profileImageURL = video?.channel?.channelImageName {
            userProfileImage.loadImageUsingURLString(urlString: profileImageURL)
        }
    }
    
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
        image.backgroundColor = #colorLiteral(red: 0, green: 0.5780889988, blue: 0.8655508161, alpha: 1)
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    //views seperator line
    let seperatorLine: UIView = {
        let line = UIView()
        line.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        line.translatesAutoresizingMaskIntoConstraints = false
        return line
    }()
    
    //view for user profile image
    let userProfileImage: UIImageView = {
        let image = UIImageView()
        image.backgroundColor = #colorLiteral(red: 0, green: 0.5780889988, blue: 0.8655508161, alpha: 1)
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
        label.numberOfLines = 0
        return label
    }()
    
    //view for title label
    let numberOfVideos: UILabel = {
        let label = UILabel()
        label.text = "Number of videos"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    func setupViews(){
        addSubview(thumbnailImageView) //subview in a cell for image
        addSubview(seperatorLine) //subview for the seperator line
        //addSubview(userProfileImage) //subview for the user profile
        addSubview(titleLabel) //subview for title label
        //addSubview(numberOfVideos)
        
        //height constraints
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: .directionMask, metrics: nil, views: ["v0": thumbnailImageView])) //video thumbnail preview
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]-8-[v1]|", options: .directionMask, metrics: nil, views: ["v0": thumbnailImageView, "v1": titleLabel]))
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: .directionMask, metrics: nil, views: ["v0": titleLabel]))
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v0(1)]|", options: .directionMask, metrics: nil, views: ["v0": seperatorLine]))
        
        addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .top, relatedBy: .equal, toItem: thumbnailImageView, attribute: .bottom, multiplier: 1, constant: 8))
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
