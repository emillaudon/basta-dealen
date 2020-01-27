//
//  ViewController.swift
//  BastaDealen
//
//  Created by Emil Laudon on 2020-01-20.
//  Copyright © 2020 Emil Laudon. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let testPost = Post(imageSrc: "storePicOne", location: "Willy:s Hemma Fridhemsplan")
    
    let testPost2 = Post(imageSrc: "che-guevara", location: "Stora Coop Häggvik")
    
    let testPost3 = Post(imageSrc: "fat-cat", location: "Stora Coop Häggvik")
    
    let testPost4 = Post(imageSrc: "maxresdefault", location: "Stora Coop Häggvik")
    
    let testPost5 = Post(imageSrc: "fidel", location: "Stora Coop Häggvik")

    var listOfPosts: [Post] = []
    
    var imageSelected: UIImage?
    var location: String?
    var sentListOfPosts: [Post]?
    
    @IBOutlet weak var postTableView: UITableView!
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        print(listOfPosts.count)
        
        if let postPicture = imageSelected, let postLocation = location {
            let newPost = Post(image: postPicture, location: postLocation)
            listOfPosts.append(newPost)
            print("post made")
        } else {
        
        listOfPosts = [testPost, testPost2, testPost3, testPost4, testPost5]
        
        }
        
        
        
        
        print(listOfPosts.count)

    }
    
    
    @IBAction func increaseRatingValue(_ sender: UIButton) {
        guard let cell = sender.superview?.superview as? PostTableViewCell else {
            fatalError()
        }
        
        if let indexPath = postTableView.indexPath(for: cell) {
            print(Int(indexPath.row))
            
            let currentPost: Post = listOfPosts[indexPath.row]
            
            currentPost.ratingOfDeal += 1
            
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
            
            currentPost.ratingOfDeal -= 1
            
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
    




