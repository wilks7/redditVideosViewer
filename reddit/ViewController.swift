//
//  ViewController.swift
//  reddit
//
//  Created by Michael Wilkowski on 9/26/16.
//  Copyright © 2016 JustWilks. All rights reserved.
//
import Foundation
import UIKit
import AVKit
import AVFoundation

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var labelOutlet: UILabel!
    
    static let sharedView = ViewController()
    
    let sections = ["hot","top","controversial","rising","new"]
        
    //392,204
    //431, 224
    
    func tapped(_ gesture: UITapGestureRecognizer){
        if let cell = gesture.view as? PostCollectionViewCell {
            //load next view pass movie
            //let post = Post(postTitle: cell.titleOutlet.text!, urlString: "", thumbnailUrl: "")
            guard let post = cell.post else {return;}
            print("\(cell.titleOutlet.text) tapped")
            self.performSegue(withIdentifier: "toPost", sender: post)
        }
    }
    
    func segueNotify(post: Post){

        self.performSegue(withIdentifier: "toPost", sender: post)
    }

    var data: [Post]?
    
    enum ViewMode {
        case hot
        case new
        case rising
        case controversial
        case top
    }
    var viewMode = ViewMode.hot
    
    //let defaultImageSize = CGRect(origin: 392, size: 204)
    let defaultImageSize = CGRect(x: 0, y: 0, width: 350, height: 250)
    
    let expandImageSize = CGRect(x: 0, y: 0, width: 375, height: 265)

    func testObj(){
        let youTubeString : String = "https://www.youtube.com/watch?v=8To-6VIJZRE"
        let videos = HCYoutubeParser.h264videos(withYoutubeURL: URL(string: youTubeString)) as NSDictionary
        let urlString : String = videos["medium"] as! String
        let asset = AVAsset(url: NSURL(string: urlString)! as URL)
        
        let avPlayerItem = AVPlayerItem(asset:asset)
        let avPlayer = AVPlayer(playerItem: avPlayerItem)
        let avPlayerLayer  = AVPlayerLayer(player: avPlayer)
        avPlayerLayer.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        self.view.layer.addSublayer(avPlayerLayer)
        avPlayer.play()
    }
    
    @IBOutlet weak var collectionviewOutlet: UICollectionView!
    
    func loadData(subreddit: String){
        
        NetworkController.listPosts("\(subreddit)/\(sections[0])") { (posts, error) in
            guard let posts = posts else {return;}
            NetworkController.sharedController.hotData = posts
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reload"), object: nil)
        }
        
        NetworkController.listPosts("\(subreddit)/\(sections[1])") { (posts, error) in
            guard let posts = posts else {return;}
            NetworkController.sharedController.topData = posts
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reload"), object: nil)
        }
        
        NetworkController.listPosts("\(subreddit)/\(sections[2])") { (posts, error) in
            guard let posts = posts else {return;}
            NetworkController.sharedController.controData = posts
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reload"), object: nil)
        }
        
        NetworkController.listPosts("\(subreddit)/\(sections[3])") { (posts, error) in
            guard let posts = posts else {return;}
            NetworkController.sharedController.risingData = posts
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reload"), object: nil)
        }
        
        NetworkController.listPosts("\(subreddit)/\(sections[4])") { (posts, error) in
            guard let posts = posts else {return;}
            NetworkController.sharedController.newData = posts
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reload"), object: nil)
        }
        
//        for i in 0...sections.count - 1 {
//            let subreddit = "videos/\(sections[i])"
//
//            NetworkController.listPosts(subreddit) { (posts, error) in
//                guard let posts = posts else {return;}
//
//                switch i {
//                case 0:
//                    NetworkController.sharedController.hotData = posts
//                case 1:
//                    NetworkController.sharedController.topData = posts
//                case 2:
//                    NetworkController.sharedController.controData = posts
//                case 3:
//                    NetworkController.sharedController.risingData = posts
//                case 4:
//                    NetworkController.sharedController.newData = posts
//                default:
//                    NetworkController.sharedController.hotData = posts
//                }
//            }
//        }
//        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reload"), object: nil)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let notificationName = Notification.Name(rawValue:"tapped")
        NotificationCenter.default.addObserver(forName: notificationName, object: nil, queue: nil, using: catchNotification)
        
        var tab = "videos"
        if let tabName = self.tabBarItem.title {
            tab = tabName
        }
        if tab == "TV" {
            loadData(subreddit: "television")
        } else if tab == "Front Page" {
            loadData(subreddit: "all")
        } else {
            loadData(subreddit: tab)
        }
    }
    
    func catchNotification(notification:Notification) -> Void {
        guard let userInfo = notification.userInfo,
            let post = userInfo["post"] as? Post else {return;}
        self.performSegue(withIdentifier: "toPost", sender: post)
    }
    
    
    // MARK: - UITableView
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomTableViewCell
        let section = sections[indexPath.section]
        
        cell.setup(section: section)
        
        return cell 
    }
    
//    // MARK: - UICollectionView
//    
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return 0
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        if let data = data {
//            return data.count
//        } else {
//            return 1
//        }
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "postCell", for: indexPath) as! PostCollectionViewCell
//        
//        if let data = data {
//            let post = data[indexPath.row]
//            cell.setupCell(post: post)
//            
//            if cell.gestureRecognizers?.count == nil {
//                let tap = UITapGestureRecognizer(target: self, action: #selector(ViewController.tapped(_:)))
//                tap.allowedPressTypes = [NSNumber(value: UIPressType.select.rawValue)]
//                cell.addGestureRecognizer(tap)
//            }
//            return cell
//        } else {
//            return cell
//        }        
//    }
    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let path = indexPath.row
//        let post = data![path]
//        self.performSegue(withIdentifier: "toPost", sender: post)
//    }
    
//    func collectionView(_ collectionView: UICollectionView, canFocusItemAt indexPath: IndexPath) -> Bool {
//        return false
//    }
    
    func tableView(_ tableView: UITableView, canFocusRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        if let previous = context.previouslyFocusedItem as? PostCollectionViewCell {
            UIView.animate(withDuration: 0.1, animations: { 
                previous.imageviewOutlet.frame = self.defaultImageSize
            })
        }
        if let next = context.nextFocusedItem as? PostCollectionViewCell {
            UIView.animate(withDuration: 0.1, animations: { 
                next.imageviewOutlet.frame = self.expandImageSize
            })
        }
    }
    
    func didUpdateFocusInContext(context: UIFocusUpdateContext, withAnimationCoordinator coordinator: UIFocusAnimationCoordinator){
        
        self.tabBarController?.tabBar.isHidden = false
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toPost" {
            guard let post = sender as? Post else {return;}
            let dVC = segue.destination as! PostViewController
            dVC.post = post
        }
    }
}

