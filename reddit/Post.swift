//
//  Post.swift
//  reddit
//
//  Created by Michael Wilkowski on 9/26/16.
//  Copyright © 2016 JustWilks. All rights reserved.
//

import Foundation
import UIKit

class Post {
    
    var title: String
    var urlString: String

    var thumbnailUrl: String = ""
    var youtubeTitle: String?
    var upvotes: Int?
    var createdUtc: Int?
    var subreddit: String?
    //var youtubeThumbnail: String?
    
    init(postTitle: String, urlString: String, thumbnailUrl: String) {
        self.title = postTitle
        self.thumbnailUrl = thumbnailUrl
        self.urlString = urlString
    }
    
    init(dict: [String:AnyObject]) {
        if let title = dict["title"] as? String {
            self.title = title
        } else {
            self.title = "no title"
        }
        if let url = dict["url"] as? String {
            self.urlString = url
        } else {
            self.urlString = "no url"
        }
        if let upvotes = dict["ups"] as? Int {
            self.upvotes = upvotes
        }
        if let createdUtc = dict["created_utc"] as? Int {
            self.createdUtc = createdUtc
        }
        if let subreddit = dict["subreddit"] as? String {
            self.subreddit = subreddit
        }
        if let mediaDict = dict["media"] as? [String:AnyObject] {
            if let oembed = mediaDict["oembed"] as? [String:AnyObject]{
                youtubeTitle = oembed["title"] as! String
                thumbnailUrl = oembed["thumbnail_url"] as! String
            }
        }
    }
}
