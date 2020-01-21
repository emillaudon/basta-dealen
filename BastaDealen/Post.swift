//
//  Post.swift
//  BastaDealen
//
//  Created by Emil Laudon on 2020-01-20.
//  Copyright © 2020 Emil Laudon. All rights reserved.
//

import Foundation
import UIKit

class Post {
    let image: UIImage?
    let locationOfItem: String
    
    init(imageSrc: String, location: String) {
        
        if let imageToApply: UIImage = UIImage(named: imageSrc) {
            self.image = imageToApply
        } else {
            self.image = nil
        }

        self.locationOfItem = location
    }
}

class PostTableViewCell: UITableViewCell {
    @IBOutlet weak var locationLabel: UILabel!

    @IBOutlet weak var postImage: UIImageView!
    
    @IBOutlet weak var testText: UILabel!
    
    
}