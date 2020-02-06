//
//  ViewController.swift
//  BastaDealen
//
//  Created by Emil Laudon on 2020-01-20.
//  Copyright © 2020 Emil Laudon. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var db: Firestore!

    var listOfPosts: [Post] = []
    
    var imageSelected: UIImage?
    var location: String?
    var sentListOfPosts: [Post]?
    var newPost: Post?
    
    @IBOutlet weak var postTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        assemblePostArray()

    }
    
    func assemblePostArray() {
        db = Firestore.firestore()
        
        
        let postRef = db.collection("Posts")
        
        postRef.getDocuments() {
            (snapshot, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            postRef.addSnapshotListener() {
                (snapshot, error) in
                guard let documents = snapshot?.documents else {return}
                
                self.listOfPosts.removeAll()
                
                
                for document in documents {
                    let snapshotValue = document.data() as [String : Any]
                    let imageDir = snapshotValue["imageDir"] as! String
                    
                    let post = Post(snapshot: document)
                    
                    post.getImage(imageDir: imageDir) {
                        self.listOfPosts.append(post)
                        self.postTableView.reloadData()
                    }
                }
            }
        }
    }
    
    
    func updateRatingValue(of post: Post, with newRating: Int) {
        
        db = Firestore.firestore()
        
        db.collection("Posts").document(post.postID).updateData(["rating" : newRating])
    }
        
//        func addListener() {
//            db = Firestore.firestore()
//
//            let postRef = db.collection("Posts")
//
//            postRef.addSnapshotListener() {
//                (snapshot, error) in
//
//                self.listOfPosts.removeAll()
//
//                guard let documents = snapshot?.documents else {return}
//
//                for document in documents {
//
//                let snapshotValue = document.data() as [String : Any]
//                let imageDir = snapshotValue["imageDir"] as! String
//
//                let post = Post(snapshot: document)
//
//                post.getImage(imageDir: imageDir) {
//                    self.listOfPosts.append(post)
//                    self.postTableView.reloadData()
//                    }
//                }
//                self.postTableView.reloadData()
//            }
//
//        }
    
    
//    func getImage(imageDir: String) -> UIImage? {
//        let storageRef = Storage.storage().reference(withPath: imageDir)
//        var downloadedImage: UIImage?
//        storageRef.getData(maxSize: 4 * 1024 * 1024) {
//            (data, error) in
//            if let error = error {
//                print("error: \(error.localizedDescription)")
//                return
//            }
//            if let data = data {
//                 downloadedImage = UIImage(data: data)
//            }
//        }
//        return downloadedImage
//
//    }
    
    @IBAction func increaseRatingValue(_ sender: UIButton) {
        guard let cell = sender.superview?.superview as? PostTableViewCell else {
            fatalError()
        }
        
        if let indexPath = postTableView.indexPath(for: cell) {
            print(Int(indexPath.row))
            
            let currentPost: Post = listOfPosts[indexPath.row]
            
            let newValue = currentPost.ratingOfDeal + 1
            
            currentPost.ratingOfDeal += 1
            
            updateRatingValue(of: currentPost, with: newValue)
            
            postTableView.reloadData()
        }
    }
    
    @IBAction func decreaseRatingValue(_ sender: UIButton) {
        guard let cell = sender.superview?.superview as? PostTableViewCell else {
            fatalError()
        }
        
        if let indexPath = postTableView.indexPath(for: cell) {
            print(Int(indexPath.row))
            
            let currentPost: Post = listOfPosts[indexPath.row]
            
            let newValue = currentPost.ratingOfDeal - 1
            
            currentPost.ratingOfDeal -= 1
            
            updateRatingValue(of: currentPost, with: newValue)
            
            postTableView.reloadData()
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return(listOfPosts.count)
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as! PostTableViewCell
            listOfPosts = listOfPosts.sorted(by: { $0.ratingOfDeal > $1.ratingOfDeal })
            let post = listOfPosts[indexPath.row]
            
            cell.locationLabel.text = post.locationOfItem
            cell.postImage.image = post.image
            
            cell.ratingLabel.text = String(post.ratingOfDeal)
        
            tableView.rowHeight = 440
        
            tableView.contentInset.bottom = 70
        
            return cell
            
        }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ViewControllerCamera
        
        destinationVC.listOfPosts = listOfPosts
    }
    
    
    
}
    




