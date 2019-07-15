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
                    
                    let title = (items as AnyObject)["snippet"] as? [String: AnyObject]
                    //print("Title: \(String(describing: title))")
                    
                    let thumbnailUrl = title!["thumbnails"] as? [String: AnyObject]
                    //print("URL: \(String(describing: thumbnailUrl))")
                    
                    //let maxresUrl = thumbnailUrl!["maxres"]?["url"]
                    //print("RES URL: \(String(describing: maxresUrl))")
                    
                    let video = ThumbnailDetails()
                    video.videoTitle = title!["title"] as? String
                    video.videoImageName = thumbnailUrl!["medium"]?["url"] as? String
                    
                    
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
            
            
            self.videoTitle.text = video.videoTitle
            self.date.text = video.uploadDate
            self.viewCount.text = "Views: \(video.numberofViews ?? "0")"
            
            
        }
        
    }
    

}
