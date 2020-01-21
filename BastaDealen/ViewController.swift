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
    
    
    
    
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return(listOfPosts.count)
        }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as! PostTableViewCell
            
            let post = listOfPosts[indexPath.row]
            
            cell.locationLabel.text = post.locationOfItem
            cell.postImage.image = post.image
        
            tableView.rowHeight = 440
            
            return cell
            
        }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        
        listOfPosts = [testPost, testPost2, testPost3, testPost4, testPost5]
         

    }
    
}
    
    
    

    
    

    
   // func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
   //     let cell = UITableViewCell(style: UITableViewCell.CellStyle.postCell, reuseIdentifier: <#T##String?#>)
   // }




