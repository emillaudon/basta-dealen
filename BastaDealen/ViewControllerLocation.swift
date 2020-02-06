//
//  ViewControllerLocation.swift
//  BastaDealen
//
//  Created by Emil Laudon on 2020-01-21.
//  Copyright © 2020 Emil Laudon. All rights reserved.
//

import UIKit
import Photos
import Firebase
import FirebaseStorage

class ViewControllerLocation: UIViewController {
    @IBOutlet weak var locationInputField: UITextField!
    @IBOutlet weak var locationInputFieldView: UIView!
    
    @IBOutlet weak var progressViewBar: UIProgressView!
    
    @IBOutlet weak var uploadButton: UIButton!
    
    var db: Firestore!
    
    var listOfPosts: [Post]?
    
    var imageSelected: UIImage?
    var location: String?
    
    var postRefID: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationInputFieldView.layer.cornerRadius = 10
        if imageSelected != nil {
            print("inte nil")
        }
        // Do any additional setup after loading the view.
    }
    
    @IBAction func post(_ sender: UIButton) {
        location = locationInputField.text
        
        uploadToDatabase()
        
        performSegue(withIdentifier: "toFirstPageSegue", sender: self)
    }
    
    func uploadPost(pictureRef: String) {
        
        db = Firestore.firestore()
        
        postRefID = UUID.init().uuidString
        
        db.collection("Posts").document(postRefID).setData([
            "location" : location as Any,
        "rating" : 0,
        "imageDir" : pictureRef as Any,
        "postRefID" : postRefID as Any])
        
//        let postsRef = db.collection("Posts")
        
//        postsRef.addDocument(data: ["location" : location as Any,
//                                    "rating" : 0,
//                                    "imageDir" : uploadRefId as Any])
    }
    
    
    
    
    func uploadToDatabase() {
        let randomID = UUID.init().uuidString
        let uploadRefId = "uploads/\(randomID).jpg"
        let uploadRef = Storage.storage().reference().child("uploads/\(randomID).jpg")
        guard let imageData = imageSelected?.jpegData(compressionQuality: 0.75) else {return}
        let uploadMetadata = StorageMetadata.init()
        uploadMetadata.contentType = "image/jpeg"
        //let taskReference =
        uploadRef.putData(imageData, metadata: uploadMetadata) {
            (downloadMetaData, error) in
            if let error = error {
                print("Error uploading! \(error.localizedDescription)")
                return
            }
                print("laddar")
            self.uploadPost(pictureRef: uploadRefId)
        }
    }
        
        
//        taskReference.observe(.progress) {
//            (snapshot) in
//
//            guard let pctThere = snapshot.progress?.fractionCompleted else {return}
//            print("you are \(pctThere) complete")
//            self.progressViewBar.isHidden = false
//            self.progressViewBar.progress = Float(pctThere)
            
//            if self.progressViewBar.progress == 1 {
//                self.uploadPost(pictureRef: uploadRefId)
////            }
//
//
//        }
//    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: (Any)?) {
        let destinationVC = segue.destination as! ViewController
        
        destinationVC.imageSelected = imageSelected
        destinationVC.location = locationInputField.text
        
        if let listOfPostsToSend: [Post] = listOfPosts {
            destinationVC.listOfPosts = listOfPostsToSend
        }
    }
}
