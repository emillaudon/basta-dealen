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
import FirebaseAuth

class ViewControllerLocation: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var previousLocationsTableView: UITableView!
    
    @IBOutlet weak var locationInputField: UITextField!
    @IBOutlet weak var locationInputFieldView: UIView!
    
    @IBOutlet weak var progressViewBar: UIProgressView!
    
    @IBOutlet weak var uploadButton: UIButton!
    
    var db: Firestore!
    
    var userID: String?
    
    var previousLocations = [Location]()
    
    var imageSelected: UIImage?
    var location: String?
    
    var postRefID: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationInputFieldView.layer.cornerRadius = 10
        previousLocationsTableView.layer.cornerRadius = 10
        
        Auth.auth().signInAnonymously() { (authResult, error) in
          print("signed in")
            
            guard let user = authResult?.user else { return }
            self.userID = user.uid
            
            self.getPreviousLocations()
            
            print(self.userID ?? "no user")
        }
        
        
        if imageSelected != nil {
            print("inte nil")
        }
        // Do any additional setup after loading the view.
    }
    
    @IBAction func post(_ sender: UIButton) {
        
        if locationInputField.text == "" || locationInputField.text == " " {
            let alert = UIAlertController(title: "Har du valt en plats?", message: "Du måste välja en plats för att ladda upp din bild.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            self.present(alert, animated: true)
        } else {
            
            location = locationInputField.text
            
            uploadToDatabase()
            
            performSegue(withIdentifier: "toFirstPageSegue", sender: self)
        }
    }
    
    func getPreviousLocations() {
            db = Firestore.firestore()
        
        guard let userID = userID else {return}
        let locationRef = db.collection("users").document(userID).collection("previousLocations")

            locationRef.getDocuments() {
                (snapshot, error) in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                guard let documents = snapshot?.documents else {return}
                    for document in documents {

                        let location = Location(document: document)
                        
                        if !self.previousLocations.contains(location) && location.locationName != "" {
                            self.previousLocations.append(location)
                        }
                        
                        
                }
                
                self.previousLocations = self.previousLocations.sorted()
                self.previousLocationsTableView.reloadData()
 
        }
    }
    
                            
    
    
    func uploadPost(pictureRef: String) {
        
        db = Firestore.firestore()
        
        postRefID = UUID.init().uuidString
        
        uploadLocation()
    
        getPostCount() {
            (postCount) in
            
            self.db.collection("Posts").document(self.postRefID).setData([
                "location" : self.location as Any,
            "rating" : 0,
            "imageDir" : pictureRef as Any,
            "postRefID" : self.postRefID as Any,
            "postNumber" : postCount as Any])
        }
        
        
        
        
//        let postsRef = db.collection("Posts")
        
//        postsRef.addDocument(data: ["location" : location as Any,
//                                    "rating" : 0,
//                                    "imageDir" : uploadRefId as Any])
    }
    
    func uploadLocation() {
        db = Firestore.firestore()
        
        guard let userID = userID else {
            return
        }
        
        let locationsRef = db.collection("users").document(userID).collection("previousLocations")
        
        locationsRef.addDocument(data: ["location" : location as Any,
                                        "number" : previousLocations.count as Any])
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
    
    func getPostCount(completion:@escaping (Int) -> ()) {
        
        let postCountRef = db.collection("PostsCount")
        
        db = Firestore.firestore()
        
        postCountRef.getDocuments() {
            (snapshot, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            guard let documents = snapshot?.documents else {return}
            
            for document in documents {
                let snapShotValue = document.data() as! [String : Int]
                
                guard let postCount: Int = snapShotValue["posted"] else {return}
                
                self.db.collection("PostsCount").document("postsCount").setData(["posted" : postCount + 1 as Any])
                
                completion(postCount + 1)
            }
            
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
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return previousLocations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "locationCell", for: indexPath) as! LocationCell
        let locationName = previousLocations[indexPath.row].locationName
        
        cell.locationLabel.text = locationName
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        locationInputField.text = previousLocations[indexPath.row].locationName
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: (Any)?) {
        let destinationVC = segue.destination as! ViewController
        
        destinationVC.imageSelected = imageSelected
        destinationVC.location = locationInputField.text
        
    }
}
