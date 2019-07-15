//
//  VideoCellData.swift
//  Talha Films
//
//  Created by Moazzam Tahir on 24/05/2019.
//  Copyright © 2019 Moazzam Tahir. All rights reserved.
//

import Foundation

class ThumbnailDetails: NSObject { //this is generic cell model for every video detail cell in view
    
    var videoImageName: String?
    var videoTitle: String?
    var videoDescription: String?
    var numberofViews: String?
    var uploadDate: String?
    var cellVideoId: String?
    var channelId: String?
    var videoCount = 0
    
    var channel: ChannelDetails?
    
}

class PlaylistItems: NSObject { //this is generic cell for every playlist item in view 
    
    var playlistImage: String?
    var playlistTitle: String?
    var playlistId: String?
    var playlistItemCount: String?
    
}

class ChannelDetails: NSObject { //generic channel object for each channel
    
    var channelTitle: String?
    var channelImageName: String?
    var channelSubscribers: String?
    var channelId: String?
  //  var channelDescription: String?
    
}
