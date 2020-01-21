//
//  GalleryCell.swift
//  BastaDealen
//
//  Created by Emil Laudon on 2020-01-21.
//  Copyright © 2020 Emil Laudon. All rights reserved.
//

import Foundation
import UIKit

enum Pictures: String {
    
    case download
    case download1
    case download2
    case download3
    case download4
    case download5
    case download6
    case download7
    case download8
    case download9
    case download10
    case download11
    
    func getPicture() -> UIImage {
        if let image = UIImage(named: self.rawValue) {
            return image
        } else {
            return UIImage(named: "default")!
        }
    }
}

class GalleryCell: UICollectionViewCell {
    
    @IBOutlet weak var pictureCell: UIView!
    
    @IBOutlet weak var tint: UIImageView!
    
    @IBOutlet weak var picture: UIImageView!
    
}
