//
//  PostViewController.swift
//  reddit
//
//  Created by Michael Wilkowski on 9/29/16.
//  Copyright © 2016 JustWilks. All rights reserved.
//

import UIKit

class PostViewController: UIViewController {

    @IBOutlet weak var titleOutlet: UILabel!
    @IBOutlet weak var imageviewOutlet: UIImageView!
    
    @IBOutlet weak var youtubeTitleOutlet: UILabel!
    
    @IBOutlet weak var youtubeLinkOutlet: UILabel!
    
    @IBOutlet weak var subredditOutlet: UILabel!
    
    @IBOutlet weak var datePostedOutlet: UILabel!
    
    @IBOutlet weak var upvotesOutlet: UILabel!
    
    
    var post: Post?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let post = post else {return;}
        titleOutlet.text = post.title
        if let title = post.youtubeTitle {
            youtubeTitleOutlet.text = "YouTube Title:  \(title)"
        } else {
            youtubeTitleOutlet.text = "YouTube Title: None"

        }
        if let created = post.createdUtc {
            datePostedOutlet.text = "Date Posted:  \(created)"
        } else {
            datePostedOutlet.text = "Date Posted:  Unknown"
            
        }
        if let upvotes = post.upvotes {
            upvotesOutlet.text = "Upvotes:  \(upvotes)"
        } else {
            upvotesOutlet.text = "Upvotes:  Unknown"

        }
        if let subreddit = post.subreddit {
            subredditOutlet.text = "Subreddit:  \(subreddit)"
        } else {
            subredditOutlet.text = "Subreddit: "
        }
        youtubeLinkOutlet.text = "YouTube Link:  \(post.urlString)"
        
        let thumbnailString = post.thumbnailUrl
        if let image = NetworkController.sharedController.imageCache[thumbnailString] {
            self.imageviewOutlet.image = image
        } else {
            self.imageviewOutlet.cacheImage(urlString: thumbnailString)
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let dVC = segue.destination as! PlayerViewController
        guard let post = post else {return;}
        dVC.post = post
    }

}
