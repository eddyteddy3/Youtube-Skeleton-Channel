//
//  SegmentViewController.swift
//  Talha Films
//
//  Created by Moazzam Tahir on 25/05/2019.
//  Copyright © 2019 Moazzam Tahir. All rights reserved.
//

import UIKit
import Alamofire
import SkeletonView

class SegmentViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var shouldAnimate = true
    
    var videos: [ThumbnailDetails]?
    var playlists: [PlaylistItems]?
    
    var selectedVideoCell: ThumbnailDetails?
    var selectedPlayListCell: PlaylistItems?
    var playlistVideos: [ThumbnailDetails]?
    
    var playlistChannelImageName: String?
    
    var cellVideoId: String?
    var playlistId: String?
    var channelId: String?
    
    @IBOutlet var segmentControl: UISegmentedControl!
    @IBOutlet var collectionView: UICollectionView!
    
    private let apiKey = "[your_api_key_here]"
    
    let videoApiUrl = "https://www.googleapis.com/youtube/v3/activities?"
    let playlistApiUrl = "https://www.googleapis.com/youtube/v3/playlists?"
    let videoCellApiUrl = "https://www.googleapis.com/youtube/v3/videos?"
    let playlistItemsApiUrl = "https://www.googleapis.com/youtube/v3/playlistItems"
    let channelApiUrl = "https://www.googleapis.com/youtube/v3/channels?"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(ChannelVideosDetails.self, forCellWithReuseIdentifier: "cellDetails")
        
        fetchVideos()
        
        switch (segmentControl.selectedSegmentIndex) {
        case 1:
            fetchVideos()
        case 0:
            fetchPlaylists()
        default:
            break
        }
        
    }
    
    func fetchPlaylists(){
        Alamofire.request(playlistApiUrl, method: .get, parameters: ["part":"contentDetails,snippet,status", "channelId":channelId!, "maxResults":"40", "key":apiKey]).responseJSON { (response) in
            
            if let json = response.result.value as? [String: AnyObject] {
                
                self.playlists = [PlaylistItems]()
                
                for items in json["items"] as! NSArray {
                    //print("Items: \(items)")
                    
                    let title = (items as AnyObject)["snippet"] as? [String: AnyObject]
                    let playlistId = (items as AnyObject)["id"] as? String
                    
                    let thumbnailUrl = title!["thumbnails"] as? [String: AnyObject]
                    
                    let playlist = PlaylistItems()
                    playlist.playlistTitle = "Playlist Name: \(title!["title"] as? String ?? "nil")"
                    //self.cellVideoId = videoId
                    //playlist.playlistItemCount = "Playlist Videos: \(playlistVideoCount as? String ?? "NIL")"
                    playlist.playlistId = playlistId
                    playlist.playlistChannelId = self.channelId!
                    playlist.playlistImage = thumbnailUrl!["high"]?["url"] as? String
                    
                    
                    //appending the videos
                    self.playlists?.append(playlist)
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0){
                    self.shouldAnimate = false
                    self.collectionView.reloadData()
                }
            }
            
        }
    }
    
    func fetchVideos() {
        Alamofire.request(videoApiUrl, method: .get, parameters: ["part":"snippet,contentDetails", "channelId":channelId!, "maxResults":"20", "key":apiKey]).responseJSON { (response) in
            
            if let json = response.result.value as? [String: AnyObject] {
                
                self.videos = [ThumbnailDetails]()
                
                for items in json["items"] as! NSArray {
                    //print("Items: \(items)")
                    
                    let video = ThumbnailDetails()
                    
                    Alamofire.request(self.channelApiUrl, method: .get, parameters: ["part":"snippet", "id":self.channelId!, "key":self.apiKey]).responseJSON { (response) in
                        
                        if let json = response.result.value as? [String: AnyObject] {
                            for items in json["items"] as! NSArray {
                                print("CHANNEL Items: \(items)")
                                
                                let title = (items as AnyObject)["snippet"] as? [String: AnyObject]
                                //channel.channelTitle = title!["title"] as? String
                                //print("Channel Title in table view: \(String(describing: channel.channelTitle))")
                                
                                let thumbnailUrl = title!["thumbnails"] as? [String: AnyObject]
                                let highResUrl = thumbnailUrl!["high"]?["url"] as? String
                                //print("Channel Image URL: \(String(describing: highResUrl))")
                                video.channelImageName = highResUrl
                                self.playlistChannelImageName = highResUrl
                                //self.imageStr = highResUrl
                                //print("\(highResUrl)")
                            }
                        }
                    }
                    
                    let title = (items as AnyObject)["snippet"] as? [String: AnyObject]
                    //print("Title: \(String(describing: title))")
                    
                    let publishedDate = title!["publishedAt"] as? String
                    if let index = publishedDate?.range(of: "T1") {
                        let subString = publishedDate![..<index.lowerBound]
                        video.uploadDate = "Published Date: \(String(subString))"
                        //print("Date: \(subString)")
                    }
                    
                    let channelId = title!["channelId"]
                    //print("ChannelId: \(channelId)")
                    
                    let contentDetails = (items as AnyObject)["contentDetails"] as? [String: AnyObject]
                    
                    var videoId = contentDetails!["upload"]?["videoId"] as? String
                    
                    if videoId == nil {
                        let resource = contentDetails!["playlistItem"]?["resourceId"] as? [String: AnyObject]
                        videoId = resource!["videoId"] as? String ?? "nil"
                    }
                    
                    let thumbnailUrl = title!["thumbnails"] as? [String: AnyObject]
                    
                    video.videoTitle = title!["title"] as? String
                    self.cellVideoId = videoId
                    video.cellVideoId = videoId
                    //video.videoDescription = description
                    video.channelId = channelId as? String
                    video.videoImageName = thumbnailUrl!["high"]?["url"] as? String
                    //appending the videos
                    self.videos?.append(video)
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0){
                    self.shouldAnimate = false
                    self.collectionView.reloadData()
                }
            }
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch (segmentControl.selectedSegmentIndex) {
        case 1:
            return playlists?.count ?? 0
        case 0:
            return videos?.count ?? 0
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        switch (segmentControl.selectedSegmentIndex) {
        case 0:
            self.selectedVideoCell = videos![indexPath.item]
            Alamofire.request(videoCellApiUrl, method: .get, parameters: ["part":"snippet,statistics", "id":selectedVideoCell!.cellVideoId!, "key":apiKey]).responseJSON { (response) in
                
                if let json = response.result.value as? [String: AnyObject] {
                    for items in json["items"] as! NSArray {
                        //print("Items of Video ID: \(items)")
                        let statistics = (items as AnyObject)["statistics"] as? [String: AnyObject]
                        let viewCount = statistics!["viewCount"] as? String
                        //print("View Counts: \(viewCount)")
                        self.selectedVideoCell!.numberofViews = viewCount
                    }
                }
                
            }
            self.performSegue(withIdentifier: "goToVideo", sender: self)
            
        case 1:
            self.selectedPlayListCell = playlists![indexPath.item]
            playlistId = selectedPlayListCell?.playlistId
            
            if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "StoryboardID") as? PlaylistVideosCollectionViewController {
                viewController.playlistId = selectedPlayListCell?.playlistId
                viewController.playlistChannelId = selectedPlayListCell?.playlistChannelId
                viewController.playlistChannelImageName = self.playlistChannelImageName
                navigationController?.pushViewController(viewController, animated: true)
            }
        default:
            break
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let segueDestination = segue.destination as? VideoCellVIewController
        
        segueDestination?.videoDetails = self.selectedVideoCell
        //segueDestination?.channelId = self.channelId
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellDetails", for: indexPath) as! ChannelVideosDetails
        
        switch (segmentControl.selectedSegmentIndex) {
        case 1:
            cell.playlistVideo = playlists![indexPath.item]
        case 0:
            cell.video = videos![indexPath.item]
        default:
            break
        }
        
        if shouldAnimate {
            cell.showAnimatedGradientSkeleton()
        } else {
            cell.hideSkeleton()
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = (view.frame.width - 16 - 16) * 9 / 16
        return CGSize(width: UIScreen.main.bounds.width, height: height + 16 + 68)
    }
    
    
    @IBAction func segmentControl(_ sender: Any) {
        collectionView.reloadData()
        
        collectionView.reloadItems(at: collectionView.indexPathsForVisibleItems)
        
        print(segmentControl.selectedSegmentIndex)
    }
}
