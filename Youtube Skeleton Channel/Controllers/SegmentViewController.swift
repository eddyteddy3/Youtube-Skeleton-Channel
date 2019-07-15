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
    
    var cellVideoId: String?
    var playlistId: String?
    var channelId: String?
    
    @IBOutlet var segmentControl: UISegmentedControl!
    @IBOutlet var collectionView: UICollectionView!
    
    private let apiKey = "[your_api_key_here]"
    let videoApiCall = "https://www.googleapis.com/youtube/v3/activities?"
    let playlistApiCall = "https://www.googleapis.com/youtube/v3/playlists?"
    let videoCellApiCall = "https://www.googleapis.com/youtube/v3/videos?"
    let playlistItemsApiCall = "https://www.googleapis.com/youtube/v3/playlistItems"
    
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
        Alamofire.request(playlistApiCall, method: .get, parameters: ["part":"contentDetails,snippet,status", "channelId":channelId!, "maxResults":"40", "key":apiKey]).responseJSON { (response) in
            
            // print("Request: \(String(describing: response.request))")   // original url request
            //print("Response: \(String(describing: response.response))") // http url response
            //print("Result: \(response.result)")
            
            if let json = response.result.value as? [String: AnyObject] {
                
                self.playlists = [PlaylistItems]()
                
                for items in json["items"] as! NSArray {
                    print("Items: \(items)")
                    
                    //let playlistId = (items as AnyObject)["id"] as? String
                    //print("PlayList Id: \(String(describing: playlistId))")
                    
                    //let contentDetail = (items as AnyObject)["contentDetails"] as? [String: AnyObject]
                    //let playlistVideoCount = contentDetail!["itemCount"]
                    //print("playlistCount: \(playlistVideoCount)")
                    
                    let title = (items as AnyObject)["snippet"] as? [String: AnyObject]
                    //print("Title: \(String(describing: title))")
                    
                    //let contentDetails = (items as AnyObject)["contentDetails"] as? [String: AnyObject]
                    let playlistId = (items as AnyObject)["id"] as? String
                    //print("VideoID: \(playlistId)")
                    //print("Video ID: \(String(describing: videoId))") //here we are retrieving Video ID
                    //print("Description: \(description)")
                    
                    let thumbnailUrl = title!["thumbnails"] as? [String: AnyObject]
                    //print("URL: \(String(describing: thumbnailUrl))")
                    
                    //let maxresUrl = thumbnailUrl!["maxres"]?["url"]
                    //print("RES URL: \(String(describing: maxresUrl))")
                    
                    let playlist = PlaylistItems()
                    playlist.playlistTitle = "Playlist Name: \(title!["title"] as? String ?? "NIL")"
                    //self.cellVideoId = videoId
                    //playlist.playlistItemCount = "Playlist Videos: \(playlistVideoCount as? String ?? "NIL")"
                    playlist.playlistId = playlistId
                    playlist.playlistImage = thumbnailUrl!["high"]?["url"] as? String
                    
                    
                    //appending the videos
                    self.playlists?.append(playlist)
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0){
                    self.shouldAnimate = false
                    self.collectionView.reloadData()
                }
            }
            
        }
    }
    
    func fetchVideos() {
        Alamofire.request(videoApiCall, method: .get, parameters: ["part":"snippet,contentDetails", "channelId":channelId!, "maxResults":"20", "key":apiKey]).responseJSON { (response) in
            
            // print("Request: \(String(describing: response.request))")   // original url request
            //print("Response: \(String(describing: response.response))") // http url response
            //print("Result: \(response.result)")
            
            if let json = response.result.value as? [String: AnyObject] {
                
                self.videos = [ThumbnailDetails]()
                
                for items in json["items"] as! NSArray {
                    //print("Items: \(items)")
                    
                    let title = (items as AnyObject)["snippet"] as? [String: AnyObject]
                    //print("Title: \(String(describing: title))")
                    
                    let channelId = title!["channelId"]
                    //print("ChannelId: \(channelId)")
                    
                    let contentDetails = (items as AnyObject)["contentDetails"] as? [String: AnyObject]
                    //let videoId = contentDetails!["upload"]?["videoId"] as? String
                    //print("Video ID: \(String(describing: videoId))") //here we are retrieving Video ID
                    
                    //let description = title!["description"] as? String
                    //print("Description: \(description)")
                    var videoId = contentDetails!["upload"]?["videoId"] as? String
                    
                    if videoId == nil {
                        let resource = contentDetails!["playlistItem"]?["resourceId"] as? [String: AnyObject]
                        videoId = resource!["videoId"] as? String ?? "nil"
                    }
                    
                    let thumbnailUrl = title!["thumbnails"] as? [String: AnyObject]
                    //print("URL: \(String(describing: thumbnailUrl))")
                    
                    //let maxresUrl = thumbnailUrl!["maxres"]?["url"]
                    //print("RES URL: \(String(describing: maxresUrl))")
                    
                    let video = ThumbnailDetails()
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
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0){
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
            Alamofire.request(videoCellApiCall, method: .get, parameters: ["part":"snippet,statistics", "id":selectedVideoCell!.cellVideoId!, "key":apiKey]).responseJSON { (response) in
                
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
