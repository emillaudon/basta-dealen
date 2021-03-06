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
import CoreLocation

class Post {
    var image: UIImage?
    let locationOfItem: String
    var ratingOfDeal: Int
    let postID: String
    let postNumber: Int
    let latitude: Double
    let longitude: Double
    
    
    init(imageSrc: String, location: String) {
        
        if let imageToApply: UIImage = UIImage(named: imageSrc) {
            self.image = imageToApply
        } else {
            self.image = nil
        }
        
        self.locationOfItem = location
        self.ratingOfDeal = 0
        self.postID = "."
        self.postNumber = 1
        self.longitude = 1.09
        self.latitude = 1.09
        
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
        self.postNumber = 1
        self.longitude = 1.09
        self.latitude = 1.09
    }
    
    init(snapshot: QueryDocumentSnapshot) {
        let snapshotValue = snapshot.data() as [String : Any]
        
        self.locationOfItem = snapshotValue["location"] as! String
        self.ratingOfDeal = snapshotValue["rating"] as! Int
        
        //self.postID = snapshotValue["postID"] as! String
        self.postID = snapshotValue["postRefID"] as! String
        self.postNumber = snapshotValue["postNumber"] as! Int
        
        self.latitude = snapshotValue["latitude"] as! Double
        self.longitude = snapshotValue["longitude"] as! Double
        
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
    
    func calculateDistance(from currentLocation: CLLocationCoordinate2D) -> Double {
        let locationOfPost = CLLocation(latitude: self.latitude, longitude: self.longitude)
        
        let currentLocation = CLLocation(latitude: currentLocation.latitude, longitude: currentLocation.longitude)
        
        let distance = locationOfPost.distance(from: currentLocation)
        
        return distance
    }
}

class Vote {
    var postID: String
    var isUpVote: Bool
    
    init(postID: String, isUpVote: Bool) {
        self.postID = postID
        self.isUpVote = isUpVote
    }
    
    init(document: QueryDocumentSnapshot) {
        let documentData = document.data()
        
        self.postID = documentData["postID"] as! String
        self.isUpVote = documentData["isUpVote"] as! Bool
    }
}



class PostTableViewCell: UITableViewCell {
    @IBOutlet weak var locationLabel: UILabel!
    
    @IBOutlet weak var postImage: UIImageView!
    
    @IBOutlet weak var testText: UILabel!
    
    @IBOutlet weak var ratingLabel: UILabel!
    
    @IBOutlet weak var voteUpButton: UIButton!
    
    @IBOutlet weak var voteDownButton: UIButton!
}

