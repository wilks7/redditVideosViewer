//
//  NetworkController.swift
//  reddit
//
//  Created by Michael Wilkowski on 9/26/16.
//  Copyright © 2016 JustWilks. All rights reserved.
//

import Foundation
import UIKit

class NetworkController {
    
    static let youtubeKey = "AIzaSyCO5jEgf36g3baj4hoYYjjSvGFZhtzTzG0"
    
    static let sharedController = NetworkController()
    
    var imageCache: [String:UIImage] = [:]
    
    //static let post = Post(postTitle: "Test", urlString: "testing", thumbnailUrl: "testing")
    
    //var sharedData: [Post] = []
    
    var hotData: [Post] = []
    
    var newData: [Post] = []
    
    var controData: [Post] = []
    
    var topData: [Post] = []
    
    var risingData: [Post] = []
    
    
    
    static let baseURLString = "https://www.reddit.com/r/"
    
    static func postDetails(_ post: Post, completion:@escaping (_ posts: [Post]?, _ error: NSError?) -> Void) {
        
    }
    
    static func listPosts(_ subreddit: String, completion:@escaping (_ posts: [Post]?, _ error: NSError?) -> Void) {
        
        let searchString = "\(baseURLString)\(subreddit).json"
                
        if let url = URL(string: searchString) {
            let dataTask = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) -> Void in
                
            //MARK: - Handling errors
            if let error = error {
                completion(nil, error as NSError?)
            }
            
            guard let data = data else {
                completion(nil, nil)
                return
            }
                
            do {
                //Turns data into JSON
                let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary
                if let dataDictionary = jsonObject?["data"] as? [String:AnyObject] {
                    if let children = dataDictionary["children"] as? [[String:AnyObject]] {
                        var arrayOfPosts = [Post]()
                        for dict in children {
                            if let data = dict["data"] as? [String:AnyObject] {
                                
                                if let url = data["url"] as? String {
                                    if url.contains("youtube"){
                                        let post = Post(dict: data)
                                        arrayOfPosts.append(post)
                                    }
                                }
                            }
                        }
                        completion(arrayOfPosts, nil)
                    }
                } else {
                    completion(nil, nil)
                }
            } catch(let error as NSError) {
                completion(nil, error)
                return
            }
                
            })
            
            dataTask.resume()
        }
    }
}
