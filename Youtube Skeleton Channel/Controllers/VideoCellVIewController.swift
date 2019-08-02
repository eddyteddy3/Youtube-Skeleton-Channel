//
//  VideoCellVIewController.swift
//  Talha Films
//
//  Created by Moazzam Tahir on 24/05/2019.
//  Copyright © 2019 Moazzam Tahir. All rights reserved.
//

import UIKit
import Alamofire
import WebKit
import SkeletonView

class VideoCellVIewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var shouldAnimate = true
    
    var videoDetails: ThumbnailDetails?
    
    var recommendedDetails: [ThumbnailDetails]?
    
    var selectedCell: ThumbnailDetails?
    
    var channelImageStr: String?
    
    
    var channelId: String?
    
    private let apiKey = "[your_api_key_here]"
    
    let youtubeApiCall = "https://www.googleapis.com/youtube/v3/activities?"
    
    @IBOutlet var date: UILabel!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var webView: WKWebView!
    @IBOutlet var videoTitle: UILabel!
    @IBOutlet var viewCount: UILabel!
    @IBOutlet var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        channelImageStr = videoDetails?.channelImageName
        
        imageView.layer.borderWidth = 1
        imageView.layer.masksToBounds = false
        imageView.layer.borderColor = UIColor.black.cgColor
        imageView.layer.cornerRadius = imageView.frame.height/2
        imageView.clipsToBounds = true
        
        collectionView?.register(RecommendedVideo.self, forCellWithReuseIdentifier: "cell")
        
        fetchVideos()
    }
    func fetchVideos() {
        
        let channelId = videoDetails?.channelId!
        
        Alamofire.request(youtubeApiCall, method: .get, parameters: ["part":"snippet,contentDetails", "channelId":channelId!, "maxResults":"10", "key":apiKey]).responseJSON { (response) in
            
            if let json = response.result.value as? [String: AnyObject] {
                
                self.recommendedDetails = [ThumbnailDetails]()
                
                for items in json["items"] as! NSArray {
                    // print("Items: \(items)")
                    
                    let video = ThumbnailDetails()
                    
                    let title = (items as AnyObject)["snippet"] as? [String: AnyObject]
                    //print("Title: \(String(describing: title))")
                    
                    let publishedDate = title!["publishedAt"] as? String
                    if let index = publishedDate?.range(of: "T1") {
                        let subString = publishedDate![..<index.lowerBound]
                        video.uploadDate = "Published Date: \(String(subString))"
                        //print("Date: \(video.uploadDate)")
                    }
                    
                    let thumbnailUrl = title!["thumbnails"] as? [String: AnyObject]
                    //print("URL: \(String(describing: thumbnailUrl))")
                    
                    let contentDetails = (items as AnyObject)["contentDetails"] as? [String: AnyObject]
                    //print("Content Details: \(contentDetails)")
                    
                    var videoId = contentDetails!["upload"]?["videoId"] as? String
                    
                    if videoId == nil {
                        let resource = contentDetails!["playlistItem"]?["resourceId"] as? [String: AnyObject]
                        videoId = resource!["videoId"] as? String ?? "nil"
                    }
                    
                    video.videoTitle = title!["title"] as? String
                    video.videoImageName = thumbnailUrl!["medium"]?["url"] as? String
                    video.cellVideoId = videoId
                    video.channelId = self.videoDetails?.channelId
                    video.channelImageName = self.channelImageStr
                    
                    //appending the videos
                    self.recommendedDetails?.append(video)
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recommendedDetails?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! RecommendedVideo
        
        cell.recommeded = recommendedDetails![indexPath.item]
        
        if shouldAnimate {
            cell.showAnimatedGradientSkeleton()
        } else {
            cell.hideSkeleton()
        }
        
        return cell
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if let video = self.videoDetails {
            
            let htmlString = "<html><body style='margin:0px;padding:0px;'><iframe id='playerId' type='text/html' width=100%% height=100%% src='http://www.youtube.com/embed/" + videoDetails!.cellVideoId! + "?enablejsapi=1&rel=0' frameborder='0'></iframe></body></html>"
            webView.loadHTMLString(htmlString, baseURL: nil)
            
            self.imageView.loadImageUsingURLString(urlString: channelImageStr ?? "nil")
            self.videoTitle.text = video.videoTitle
            self.date.text = video.uploadDate
            self.viewCount.text = "Views: \(video.numberofViews ?? "0")"
            
            
        }
        
    }
    
    
}
