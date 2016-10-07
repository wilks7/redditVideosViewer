//
//  PlayerViewController.swift
//  reddit
//
//  Created by Michael Wilkowski on 9/29/16.
//  Copyright © 2016 JustWilks. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import AVKit

class PlayerViewController: AVPlayerViewController {
    let overlayView = UIView(frame: CGRect(x: 50, y: 50, width: 200, height: 200))
    
    var post: Post?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        overlayView.addSubview(UIImageView(image: UIImage(named: "tv-watermark")))
//        contentOverlayView?.addSubview(overlayView)
        
        //let youTubeString : String = "https://www.youtube.com/watch?v=8To-6VIJZRE"
        guard let post = post else {return;}
        let youTubeString = post.urlString
        let videos = HCYoutubeParser.h264videos(withYoutubeURL: URL(string: youTubeString)) as NSDictionary
        let urlString : String = videos["medium"] as! String
        player = AVPlayer(url: NSURL(string: urlString)! as URL)
        player?.play()
    }
}
