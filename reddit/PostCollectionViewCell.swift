//
//  PostCollectionViewCell.swift
//  reddit
//
//  Created by Michael Wilkowski on 9/26/16.
//  Copyright © 2016 JustWilks. All rights reserved.
//

import Foundation
import UIKit

class PostCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageviewOutlet: UIImageView!
    
    @IBOutlet weak var titleOutlet: UILabel!
    
    var post: Post?
    
    func setupCell(post: Post){
        self.post = post
        imageviewOutlet.cacheImage(urlString: post.thumbnailUrl)
        titleOutlet.text = post.title
    }
    
    
    func collectionView(_ collectionView: UICollectionView, canFocusItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toPost" {
            guard let post = sender as? Post else {return;}
            let dVC = segue.destination as! PostViewController
            dVC.post = post
        }
    }
}
extension UIImageView {
    func cacheImage(urlString: String){
        if let imgURL = URL(string: urlString){
            let request = URLRequest(url: imgURL)
            
            let task = URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
                if error == nil {
                    if let image = UIImage(data: data!){
                        NetworkController.sharedController.imageCache[urlString] = image
                        DispatchQueue.main.async(execute: {
                            self.image = image
                        })
                    } else {
                        DispatchQueue.main.async(execute: {
                            //self.backgroundColor = .gray
                            print("couldnt find image bad url")
                        })
                    }
                }
                else {
                    print("Error: \(error!.localizedDescription)")
                }
            }); task.resume()
        }
    }
}
