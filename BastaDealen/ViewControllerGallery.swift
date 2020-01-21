//
//  ViewControllerGallery.swift
//  BastaDealen
//
//  Created by Emil Laudon on 2020-01-21.
//  Copyright © 2020 Emil Laudon. All rights reserved.
//

import UIKit

class ViewControllerGallery: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate  {
    
    let screenWidth = UIScreen.main.bounds.width
    
    var imageToSend: String?
    
    @IBOutlet weak var newPostImage: UIImageView!
    @IBOutlet weak var galleryView: UICollectionView!
    
    
    
    
    let listOfPictures: [Pictures] = [.download, .download1, .download2, .download3, .download4, .download5, .download6, .download7, .download8, .download9, .download10, .download11]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setUpCollectionViewCells()
    }
    
    
    func setUpCollectionViewCells() {
        let layout = UICollectionViewFlowLayout()
        
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        
        let padding: CGFloat = 10
        
        let itemWidth = screenWidth/3 - padding
        let itemHeight = screenWidth/3 - padding
        
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        layout.minimumLineSpacing = 4
        layout.minimumInteritemSpacing = 4
        
        galleryView.collectionViewLayout = layout
        
        print("collvi")
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(listOfPictures.count)
        return listOfPictures.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? GalleryCell else {
            fatalError()
        }
        
        let picture = listOfPictures[indexPath.row]
        
        cell.picture.image = picture.getPicture()
        cell.picture.frame = CGRect(x: 0, y: 0, width: screenWidth/3, height: screenWidth/3)
        cell.tint.frame = CGRect(x: 0, y: 0, width: screenWidth/3, height: screenWidth/3)
        print(listOfPictures[indexPath.row])
        print(picture.rawValue)
        
        return cell
    }
    
    
    //Selecting picture functions
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        updateCell(having: indexPath, selected: false)
    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        updateCell(having: indexPath, selected: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        updateCell(having: indexPath, selected: false)
    }
    
    func updateCell(having indexPath: IndexPath, selected: Bool) {
        //TODO: Make pictures appear as selected when clicked

        let selectedColor = UIColor(red: 41/255.0, green: 211/255.0, blue: 241/255.0, alpha: 1.0)
        let defaultColor = UIColor(red: 27/255.0, green: 32/255.0, blue: 36/255.0, alpha: 1.0)
        
        let imageName = listOfPictures[indexPath.row]
        
        if selected {
            newPostImage.image = UIImage(named: imageName.rawValue)
            imageToSend = imageName.rawValue
        }
        
        if let cell = galleryView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? GalleryCell {
            print("ran")
            
            cell.tint.tintColor = UIColor(red: 27/255.0, green: 32/255.0, blue: 36/255.0, alpha: 1.0)
            
            
            cell.picture.image = UIImage(named: "default")
            if selected {
                print(listOfPictures[indexPath.row])
                cell.picture.alpha = 0.4
                cell.picture.image = UIImage(named: "default")
            }
            
            if let imageToTint = UIImage(named: imageName.rawValue) {
                let tintedImage = imageToTint.withRenderingMode(.alwaysTemplate)
                cell.picture.image = tintedImage
            }
            
            cell.picture.tintColor = selected ? selectedColor : defaultColor
            cell.picture.image = UIImage(named: "default")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: (Any)?) {
        let destinationVC = segue.destination as! ViewControllerLocation
        
        destinationVC.imageSelected = imageToSend
    }
}
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


