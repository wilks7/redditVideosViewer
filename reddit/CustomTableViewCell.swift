//
//  CustomTableViewCell.swift
//  reddit
//
//  Created by macVM on 10/1/16.
//  Copyright © 2016 JustWilks. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate {

    
    @IBOutlet weak var collectionviewOutlet: UICollectionView!
    
    // DataSource
    
    var subreddit = ""
    
    func setup(section: String){
        
        self.subreddit = section

        NotificationCenter.default.addObserver(self, selector: #selector(CustomTableViewCell.reloadTableData), name: NSNotification.Name(rawValue: "reload"), object: nil)
    }
    
    func reloadTableData(){
        DispatchQueue.main.async(execute: {
            self.collectionviewOutlet.reloadData()
        })
    }
    
    
    func tapped(_ gesture: UITapGestureRecognizer){
        if let cell = gesture.view as? PostCollectionViewCell {
            //load next view pass movie
            guard let post = cell.post else {return;}
            print("\(post.title) tapped")
            //self.performSegue(withIdentifier: "toPost", sender: post)
            //NotificationCenter.default.post(name: NSNotification.Name(rawValue: "tapped"), object: post)
            let nc = NotificationCenter.default
            let notificationName = Notification.Name(rawValue:"tapped")
            nc.post(name:notificationName,
                    object: nil,
                    userInfo:["post":post])
        }
    }

    // MARK: - UICollectionView
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch self.subreddit {
        case "hot":
            if NetworkController.sharedController.hotData.count > 0 {
                return NetworkController.sharedController.hotData.count
            } else {
                return 1
            }
        case "top":
            if NetworkController.sharedController.topData.count > 0 {
                return NetworkController.sharedController.topData.count
            } else {
                return 1
            }
        case "controversial":
            if NetworkController.sharedController.controData.count > 0 {
                return NetworkController.sharedController.controData.count
            } else {
                return 1
            }
        case "rising":
            if NetworkController.sharedController.risingData.count > 0 {
                return NetworkController.sharedController.risingData.count
            } else {
                return 1
            }
        case "new":
            if NetworkController.sharedController.newData.count > 0 {
                return NetworkController.sharedController.newData.count
            } else {
                return 1
            }
        default:
            return 5
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "postCell", for: indexPath) as! PostCollectionViewCell
        
        if cell.gestureRecognizers?.count == nil {
            let tap = UITapGestureRecognizer(target: self, action: #selector(ViewController.tapped(_:)))
            tap.allowedPressTypes = [NSNumber(value: UIPressType.select.rawValue)]
            cell.addGestureRecognizer(tap)
        }
        
        
        switch subreddit {
        case "hot":
            if NetworkController.sharedController.hotData.count > 0 {
                let post = NetworkController.sharedController.hotData[indexPath.row]
                cell.setupCell(post: post)
                return cell
            } else {
                return cell
            }
        case "top":
            if NetworkController.sharedController.topData.count > 0 {
                let post = NetworkController.sharedController.topData[indexPath.row]
                cell.setupCell(post: post)
                return cell
            } else {
                return cell
            }
        case "controversial":
            if NetworkController.sharedController.controData.count > 0 {
                let post = NetworkController.sharedController.controData[indexPath.row]
                cell.setupCell(post: post)
                return cell
            } else {
                return cell
            }
        case "rising":
            if NetworkController.sharedController.risingData.count > 0 {
                let post = NetworkController.sharedController.risingData[indexPath.row]
                cell.setupCell(post: post)
                return cell
            } else {
                return cell
            }
        case "new":
            if NetworkController.sharedController.newData.count > 0 {
                let post = NetworkController.sharedController.newData[indexPath.row]
                cell.setupCell(post: post)
                return cell
            } else {
                return cell
            }
        default:
            return cell
        }        
    }
}
