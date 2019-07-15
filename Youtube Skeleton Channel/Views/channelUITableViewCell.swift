//
//  channelUITableViewCell.swift
//  Talha Films
//
//  Created by Moazzam Tahir on 25/05/2019.
//  Copyright © 2019 Moazzam Tahir. All rights reserved.
//

import UIKit
import Foundation

class channelUITableViewCell: UITableViewCell {
    
    //this object is derived from videoCellData from channel to show channel cell details
    var channelDetail: ChannelDetails? {
        didSet {
            channelTitle.text = channelDetail?.channelTitle
            channelSubscribers.text = "Subscribers: \(channelDetail?.channelSubscribers ?? "NetworkError")"
            loadChannelProfileImageFromURL()
        }
    }
    
    func loadChannelProfileImageFromURL() { //loads channel profile image from URL.
        if let profileImageURL = channelDetail?.channelImageName {
            channelImageView.loadImageUsingURLString(urlString: profileImageURL)
        }
    }
    
    //for channel title label
    let channelTitle: UILabel = {
        let title = UILabel()
        title.text = "Channel Title"
        title.font = UIFont.systemFont(ofSize: 25)
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
    }()
    
    //for channel subs
    let channelSubscribers: UILabel = {
        let title = UILabel()
        title.text = "Channel Sub asd alkdjlaksjkdla"
        title.font = UIFont.systemFont(ofSize: 15)
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
    }()
    
    //for channel image view 
    let channelImageView: UIImageView = {
        let image = UIImageView()
        image.backgroundColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        image.layer.cornerRadius = image.bounds.height / 2
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    
    func setupViews(){
        addSubview(channelImageView)
        addSubview(channelTitle)
        addSubview(channelSubscribers)
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[v0(80)]", options: .directionMask, metrics: nil, views: ["v0": channelImageView]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-10-[v0]-10-|", options: .directionMask, metrics: nil, views: ["v0": channelImageView]))
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-15-[v0]", options: .directionMask, metrics: nil, views: ["v0": channelTitle]))
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v0]-15-|", options: .directionMask, metrics: nil, views: ["v0": channelSubscribers]))
        
        addConstraint(NSLayoutConstraint(item: channelTitle, attribute: .left, relatedBy: .equal, toItem: channelImageView, attribute: .right, multiplier: 1, constant: 8))
        
        addConstraint(NSLayoutConstraint(item: channelSubscribers, attribute: .left, relatedBy: .equal, toItem: channelImageView, attribute: .right, multiplier: 1, constant: 8))
        
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
