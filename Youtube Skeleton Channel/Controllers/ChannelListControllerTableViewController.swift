//
//  ChannelListControllerTableViewController.swift
//  Talha Films
//
//  Created by Moazzam Tahir on 24/05/2019.
//  Copyright © 2019 Moazzam Tahir. All rights reserved.
//

import UIKit
import Foundation
import Alamofire
import SkeletonView

class ChannelListControllerTableViewController: UITableViewController {
    
    var shouldAnimate = true
    
    var channels: [ChannelDetails] = []
    var selectedChannel: ChannelDetails? //to copy selected cell object to this var
    
    private let apiKey = "[your_api_key_here]"
    
    let channelApiCall = "https://www.googleapis.com/youtube/v3/channels?"
    
    let channelIdArray = ["the array of channels or a single channel"]

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Channels"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .never
        
        tableView.tableFooterView = UIView(frame: .zero)
        
        //registered this with channelUI to show view
        tableView.register(channelUITableViewCell.self, forCellReuseIdentifier: "detailed")
        
        fetchChannels()
    }

    
    func fetchChannels(){
        
        for id in channelIdArray {
            Alamofire.request(channelApiCall, method: .get, parameters: ["part":"snippet,statistics", "id":id, "key":apiKey]).responseJSON { (response) in
                
                if let json = response.result.value as? [String: AnyObject] {
                    
                    for items in json["items"] as! NSArray {
                        //print("CHANNEL Items: \(items)")
                        
                        let channel = ChannelDetails()
                        
                        let title = (items as AnyObject)["snippet"] as? [String: AnyObject]
                        channel.channelTitle = title!["title"] as? String
                        //print("Channel Title in table view: \(String(describing: channel.channelTitle))")
                        
                        let thumbnailUrl = title!["thumbnails"] as? [String: AnyObject]
                        let highResUrl = thumbnailUrl!["high"]?["url"] as? String
                        //print("Channel Image URL: \(String(describing: highResUrl))")
                        channel.channelImageName = highResUrl
                        
                        let stats = (items as AnyObject)["statistics"] as? [String: AnyObject]
                        let subCount = stats!["subscriberCount"] as? String
                        channel.channelSubscribers = subCount
                        //print("Subscriber Count: \(String(describing: subCount))")
                        
                        channel.channelId = id
                        
                        self.channels.append(channel)
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0){
                        self.shouldAnimate = false
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return channels.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "detailed", for: indexPath) as! channelUITableViewCell
    
        cell.channelDetail = channels[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedChannel = channels[indexPath.row]
        
        self.performSegue(withIdentifier: "goToChannel", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let segueDestination = segue.destination as? SegmentViewController
        
        segueDestination?.channelId = selectedChannel?.channelId
    }

    
}
