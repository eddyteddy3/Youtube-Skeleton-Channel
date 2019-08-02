//
//  ViewController.swift
//  Youtube Skeleton Channel
//
//  Created by Moazzam Tahir on 15/07/2019.
//  Copyright © 2019 Moazzam Tahir. All rights reserved.
//

import UIKit
import Foundation
import Alamofire
import SkeletonView

class HomeCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let refreshControl = UIRefreshControl()
    let activityIndicator = UIActivityIndicatorView()
    
    var shouldShowSearchResults = false
    let searchBar = UISearchController(searchResultsController: nil)
    var searchedVideo = [ThumbnailDetails]()
    
    var shouldAnimate = true //to animate the cell
    var fetchingMore = false
    
    //array of video thumbnail cells in view.
    var videos: [ThumbnailDetails]?
    
    //to copy selected cell object to this variable
    var selectedCell: ThumbnailDetails?
    
    var channelIdArray = "your list of channels in array or can be a single channel"
    
    private let apiKey = "[your_api_key_here]"
    
    let youtubeApiUrl = "https://www.googleapis.com/youtube/v3/activities?"
    let videoApiUrl = "https://www.googleapis.com/youtube/v3/videos?"
    let channelApiUrl = "https://www.googleapis.com/youtube/v3/channels?"
    //let channelId = "UCNZ-ZdWIRFM88Fxvlpug73A"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Home"
        navigationController?.navigationBar.prefersLargeTitles = true //to display large title
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        //registered cell with CellUIDetails to show the views
        collectionView.register(DetailedCell.self, forCellWithReuseIdentifier: "cell")
        
        //method to refreshing upon pulling down the view.
        pullToRefresh()
        
        showSearchBar()
        
        fetchVideos()
    }
    
    func showSearchBar(){
        searchBar.searchResultsUpdater = self
        searchBar.obscuresBackgroundDuringPresentation = true
        navigationItem.hidesSearchBarWhenScrolling = false
        searchBar.searchBar.placeholder = "Search Videos"
        navigationItem.searchController = searchBar
        searchBar.searchBar.sizeToFit()
        definesPresentationContext = true
    }
    
    func isFiltering() -> Bool {
        return searchBar.isActive && !searchBarIsEmpty()
    }
    
    func searchBarIsEmpty() -> Bool {
        return searchBar.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        searchedVideo = videos!.filter({( video : ThumbnailDetails) -> Bool in
            return video.videoTitle?.lowercased().contains(searchText.lowercased()) ?? false
        })
        
        self.collectionView.reloadData()
    }
    
    func pullToRefresh() {
        if #available(iOS 10.0, *) {
            collectionView.refreshControl = refreshControl
        } else {
            collectionView.addSubview(refreshControl)
        }
        
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        
        refreshControl.addTarget(self, action: #selector(refreshTheFeed(_:)), for: .valueChanged)
    }
    
    @objc func refreshTheFeed(_ sender: Any) {
        videos?.shuffle()
        collectionView.reloadData()
        self.refreshControl.endRefreshing()
        self.activityIndicator.stopAnimating()
        
        print("It got shuffled")
    }
    
    func fetchVideos() {
        self.videos = [ThumbnailDetails]()
        self.channelIdArray.shuffle()
        
        for id in channelIdArray {
            Alamofire.request(youtubeApiUrl, method: .get, parameters: ["part":"snippet,contentDetails", "channelId":id, "maxResults":"10", "key":apiKey]).responseJSON { (response) in
                
                if let json = response.result.value as? [String: AnyObject] {
                    for items in json["items"] as! NSArray {
                        //print("Items: \(items)")
                        
                        let video = ThumbnailDetails()
                        
                        Alamofire.request(self.channelApiUrl, method: .get, parameters: ["part":"snippet", "id":id, "key":self.apiKey]).responseJSON { (response) in
                            
                            if let json = response.result.value as? [String: AnyObject] {
                                for items in json["items"] as! NSArray {
                                    //print("CHANNEL Items: \(items)")
                                    
                                    let title = (items as AnyObject)["snippet"] as? [String: AnyObject]
                                    
                                    let thumbnailUrl = title!["thumbnails"] as? [String: AnyObject]
                                    let highResUrl = thumbnailUrl!["high"]?["url"] as? String
                                    //print("Channel Image URL: \(String(describing: highResUrl))")
                                    video.channelImageName = highResUrl
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
                        
                        let contentDetails = (items as AnyObject)["contentDetails"] as? [String: AnyObject]
                        //print("Content Details: \(contentDetails)")
                        
                        var videoId = contentDetails!["upload"]?["videoId"] as? String
                        
                        if videoId == nil {
                            let resource = contentDetails!["playlistItem"]?["resourceId"] as? [String: AnyObject]
                            videoId = resource!["videoId"] as? String ?? "nil"
                        }
                        
                        let thumbnailUrl = title!["thumbnails"] as? [String: AnyObject]
                        //print("URL: \(String(describing: thumbnailUrl))")
                        
                        video.videoTitle = title!["title"] as? String
                        video.cellVideoId = videoId
                        video.channelId = id
                        video.videoImageName = thumbnailUrl!["maxres"]?["url"] as? String
                        
                        //appending the videos
                        self.videos?.append(video)
                        DispatchQueue.main.async {
                            self.videos?.shuffle()
                            self.collectionView.reloadData()
                        }
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 5.0){
                        self.shouldAnimate = false
                        self.collectionView.reloadData()
                    }
                }
            }
        }
        self.videos?.shuffle()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = (view.frame.width - 16 - 16) * 9 / 16
        return CGSize(width: UIScreen.main.bounds.width, height: height + 16 + 68)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if isFiltering() {
            return searchedVideo.count
        }
        
        return videos?.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! DetailedCell
        
        let video: ThumbnailDetails
        
        if isFiltering() {
            video = searchedVideo[indexPath.item]
        } else {
            video = videos![indexPath.item]
        }
        
        //cell.video = videos![indexPath.item]
        cell.titleLabel.text = video.videoTitle
        cell.dateLabel.text = video.uploadDate
        //cell.loadChannelProfileImageFromURL() = video.videoImageName
        
        if shouldAnimate {
            cell.showAnimatedGradientSkeleton()
        } else {
            cell.hideSkeleton()
        }
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedCell = videos![indexPath.item]
        
        Alamofire.request(videoApiUrl, method: .get, parameters: ["part":"snippet,statistics", "id":selectedCell!.cellVideoId!, "key":apiKey]).responseJSON { (response) in
            
            //print("Request: \(String(describing: response.request))")   // original url request
            //print("Response: \(String(describing: response.response))") // http url response
            //print("Result: \(response.result)")
            
            if let json = response.result.value as? [String: AnyObject] {
                
                for items in json["items"] as! NSArray {
                    //print("Items of Video ID: \(items)")
                    
                    let statistics = (items as AnyObject)["statistics"] as? [String: AnyObject]
                    let viewCount = statistics!["viewCount"] as? String
                    //print("View Counts: \(viewCount)")
                    self.selectedCell!.numberofViews = viewCount
                    
                }
            }
        }
        self.performSegue(withIdentifier: "goToDetails", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let segueDestination = segue.destination as? VideoCellVIewController
        
        segueDestination?.videoDetails = self.selectedCell
        //segueDestination?.channelId = self.channelId
    }
    
    
}

