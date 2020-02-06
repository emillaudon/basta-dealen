//
//  Post.swift
//  BastaDealen
//
//  Created by Emil Laudon on 2020-01-20.
//  Copyright © 2020 Emil Laudon. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseStorage

class Post {
    var image: UIImage?
    let locationOfItem: String
    var ratingOfDeal: Int
    let postID: String

    
    init(imageSrc: String, location: String) {
        
        if let imageToApply: UIImage = UIImage(named: imageSrc) {
            self.image = imageToApply
        } else {
            self.image = nil
        }

        self.locationOfItem = location
        self.ratingOfDeal = 0
        self.postID = "."
        
    }
    init(image: UIImage?, location: String){
        if let imageToApply: UIImage = image {
            self.image = imageToApply
        } else {
            self.image = nil
        }
        
        self.locationOfItem = location
        self.ratingOfDeal = 0
        self.postID = "."
    }
    
    init(snapshot: QueryDocumentSnapshot) {
        let snapshotValue = snapshot.data() as [String : Any]

        self.locationOfItem = snapshotValue["location"] as! String
        self.ratingOfDeal = snapshotValue["rating"] as! Int
        
        //self.postID = snapshotValue["postID"] as! String
        self.postID = snapshotValue["postRefID"] as! String

    }
    
//    init(snapshot: QueryDocumentSnapshot, image: UIImage, completion:@escaping () -> ()) {
//        let snapshotValue = snapshot.data() as [String : Any]
//        let imageDir = snapshotValue["imageDir"] as! String
//
//        self.locationOfItem = snapshotValue["location"] as! String
//        self.ratingOfDeal = snapshotValue["rating"] as! Int
//    }
    
    func getImage(imageDir: String, completion:@escaping () -> ()) {
        let storageRef = Storage.storage().reference(withPath: imageDir)
        let taskReference = storageRef.getData(maxSize: 4 * 1024 * 1024) {
            (data, error) in
            if error != nil {
                print("error: \(error?.localizedDescription)")
                return
            } else {
                if let data = data {
                    self.image = UIImage(data: data)
                    completion()
                }
            }
        }
    }
}



class PostTableViewCell: UITableViewCell {
    @IBOutlet weak var locationLabel: UILabel!

    @IBOutlet weak var postImage: UIImageView!
    
    @IBOutlet weak var testText: UILabel!
    
    @IBOutlet weak var ratingLabel: UILabel!
    
}

