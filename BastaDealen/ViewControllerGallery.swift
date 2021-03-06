//
//  ViewControllerGallery.swift
//  BastaDealen
//
//  Created by Emil Laudon on 2020-01-21.
//  Copyright © 2020 Emil Laudon. All rights reserved.
//

import UIKit
import Photos
import Firebase
import FirebaseStorage

extension UIImageView {
    func setImageColor(color: UIColor) {
        let templateImage = self.image?.withRenderingMode(.alwaysTemplate)
        self.image = templateImage
        self.tintColor = color
    }
}


class ViewControllerGallery: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate  {
    
    let screenWidth = UIScreen.main.bounds.width
    
    var imageToSend: UIImage?
    
    var listOfPosts:[Post]?
    
    var imageArray = [UIImage]()
    
    
    var selectedImageNr : Int?
    
    @IBOutlet weak var newPostImage: UIImageView!
    @IBOutlet weak var galleryView: UICollectionView!
    
    let listOfPictures: [Pictures] = [.download1, .download2, .download3, .download4, .download5, .download6, .download7, .download8, .download9, .download10, .download11]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if imageToSend != nil {
            imageArray.append(imageToSend!)
            print("inte nil")
        }
        grabPhotosFromPhone()
        setUpCollectionViewCells()
        newPostImage.image = imageToSend
    }
    
    

    
    @IBAction func toLocationButton(_ sender: Any) {
        if newPostImage.image == nil {
            let alert = UIAlertController(title: "Har du valt en bild?", message: "Du måste välja en bild.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            self.present(alert, animated: true)
        }
        
        performSegue(withIdentifier: "toLocationSegue", sender: self)
    }
    
    
    func setUpCollectionViewCells() {
        let layout = UICollectionViewFlowLayout()
        
        layout.sectionInset = UIEdgeInsets(top: 3, left: 0, bottom: 20, right: 0)
        
        let padding: CGFloat = 3
        
        let itemWidth = screenWidth/3 - padding
        let itemHeight = screenWidth/3 - padding
        
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        layout.minimumLineSpacing = 4
        layout.minimumInteritemSpacing = 4
        
        galleryView.collectionViewLayout = layout
    }
    
    func grabPhotosFromPhone() {
        imageArray = []
        
        DispatchQueue.global(qos: .background).async {
            print("ok")
        }
        let imgManager = PHImageManager.default()
        
        let requestOptions = PHImageRequestOptions()
        requestOptions.isSynchronous = true
        requestOptions.deliveryMode = .highQualityFormat
        
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        let fetchResults: PHFetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        
        print(fetchResults)
        print(fetchResults.count)
        
        if fetchResults.count > 0 {
            var fetchResultCount = fetchResults.count
            
            if fetchResults.count > 100 {
                fetchResultCount = 100
            }
            
            
            for index in 0..<fetchResultCount{
                imgManager.requestImage(for: fetchResults.object(at: index) as PHAsset, targetSize: CGSize(width:500, height: 500),contentMode: .aspectFill, options: requestOptions, resultHandler: { (image, error) in
                    if let imageToAppend = image {
                        self.imageArray.append(imageToAppend)
                    }
                    
                })
            }
        } else {
            print("no photos")
        }
        print("imageArray count: \(self.imageArray.count)")
        
        DispatchQueue.main.async {
            self.galleryView.reloadData()
        }
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(listOfPictures.count)
        return listOfPictures.count + imageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? GalleryCell else {
            fatalError()
        }
        
        if imageArray.count == 0 {
            grabPhotosFromPhone()
        }
        
        cell.tint.isHidden = true
        
        if selectedImageNr == indexPath.row {
            cell.tint.isHidden = false
        }
        
        cell.picture.frame = CGRect(x: 0, y: 0, width: screenWidth/3, height: screenWidth/3)
        cell.tint.frame = CGRect(x: 0, y: 0, width: screenWidth/3, height: screenWidth/3)
        
        
        if imageArray.count > 0 && indexPath.row >= listOfPictures.count {
            
            let picture = imageArray[indexPath.row - listOfPictures.count]
            
            cell.picture.image = picture
            
            if selectedImageNr == indexPath.row {
                
                newPostImage.image = picture
                
                imageToSend = picture
            }
            
        } else {
            
            let picture = listOfPictures[indexPath.row]
            
            cell.picture.image = picture.getPicture()
            
            if selectedImageNr == indexPath.row {
                let imageName = listOfPictures[indexPath.row]
                newPostImage.image = UIImage(named: imageName.rawValue)
                imageToSend = UIImage(named: "imageName.rawValue")
            }
        }
        return cell
    }
    
    
    //Selecting picture functions
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        updateCell(having: indexPath, selected: false)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        selectedImageNr = indexPath.row
        galleryView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        selectedImageNr = nil
        galleryView.reloadData()
    }
    
    func updateCell(having indexPath: IndexPath, selected: Bool) {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: (Any)?) {
        if segue.identifier != "backSegue" {
            let destinationVC = segue.destination as! ViewControllerLocation
            
            if imageToSend == nil {
                imageToSend = newPostImage.image
            }
            
            destinationVC.imageSelected = imageToSend
        }
    }
    
}


