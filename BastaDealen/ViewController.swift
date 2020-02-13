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
import FirebaseAuth

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var userID: String?
    
    var isAnon: Bool?
    
    var postsVotedFor = [String]()
    var postVotes = [Vote]()
    
    var db: Firestore!

    var listOfPosts: [Post] = []
    
    var imageSelected: UIImage?
    var location: String?
    var newPost: Post?
    
    var currentSorting: sortingOptions = .bestDeal
    
    @IBOutlet weak var postTableView: UITableView!
    
    @IBOutlet weak var sortingButton: UIButton!
    @IBOutlet var sortingButtons: [UIButton]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Auth.auth().signInAnonymously() { (authResult, error) in
          print("signed in")
            
            guard let user = authResult?.user else { return }
            self.isAnon = user.isAnonymous  // true
            self.userID = user.uid
            
            
            self.getPostsVotedOn()
            print(self.userID ?? "no user")
        }
        
        
        
        assemblePostArray()
    }
    
    @IBAction func sortingButtonTapped(_ sender: UIButton) {
        sortingButtons.forEach { (button) in
            UIView.animate(withDuration: 0.1, animations: {
                button.isHidden = !button.isHidden
                if button.isHidden {
                    self.sortingButton.backgroundColor = UIColor(red: 209/255, green: 90/255, blue: 124/255, alpha: 0)
                } else {
                    self.sortingButton
                        .backgroundColor = UIColor(red: 209/255, green: 90/255, blue: 124/255, alpha: 1)
                }
            })
            
        }
        
    }
    
    enum sortingOptions: String {
        case newestFirst = "Nyast Först"
        case bestDeal = "Bästa Dealen"
    }
    
    @IBAction func sortingOptionTapped(_ sender: UIButton) {
        guard let currentTitle = sender.currentTitle, let sortingOption = sortingOptions(rawValue: currentTitle) else {return}
        
        switch sortingOption {
            
        case .newestFirst:
            print("newest first")
            currentSorting = .newestFirst
            reloadTableView()
            
        case .bestDeal:
            currentSorting = .bestDeal
            reloadTableView()
        }
    }
    
    
    @IBAction func toUploadButtonPress(_ sender: Any) {
        performSegue(withIdentifier: "toUploadSegue", sender: self)
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
                
                //self.listOfPosts.removeAll()
                
                
                for document in documents {
                    if !self.checkIfPostExists(snapshot: document) {
                        
                        let snapshotValue = document.data() as [String : Any]
                        
                        let imageDir = snapshotValue["imageDir"] as! String
                        
                        let post = Post(snapshot: document)
                        
                        post.getImage(imageDir: imageDir) {
                            self.listOfPosts.append(post)
                            self.reloadTableView()
                        }
                    }
                }
            }
        }
    }
    
    func checkIfPostExists(snapshot: QueryDocumentSnapshot) -> Bool {
        let snapshotValue = snapshot.data() as [String : Any]
        
        for post in listOfPosts {
            if post.postID == snapshotValue["postRefID"] as! String {
                if post.ratingOfDeal != snapshotValue["rating"] as! Int {
                    post.ratingOfDeal = snapshotValue["rating"] as! Int
                    reloadTableView()
                }
                return true
            }
        }
        return false
    }
    
    
    func updateRatingValue(of post: Post, with newRating: Int, isAnUpVote: Bool, completion: () -> ()) {
        postVotes.append(Vote(postID: post.postID, isUpVote: isAnUpVote))
        
        db = Firestore.firestore()
        
        db.collection("Posts").document(post.postID).updateData(["rating" : newRating])
        
        saveVoteToUser(on: post, isUpVote: isAnUpVote)
        
        completion()
    }
    
    func changeVote(of post: Post, isAnUpVote: Bool) {
        for vote in postVotes {
            if vote.postID == post.postID {
                vote.isUpVote = isAnUpVote
            }
        }
    }
    
    func saveVoteToUser(on post: Post, isUpVote: Bool) {
        db = Firestore.firestore()
        
        if let userID = userID {
            db.collection("users").document(userID).collection("postsVotedFor").document(post.postID).setData(["postID" : post.postID,
                                                                                                               "isUpVote" : isUpVote ])
        }
    }
    
    func getPostsVotedOn() {
        db = Firestore.firestore()
        
        if let userID = userID {
            
            let votedPostsRef = db.collection("users").document(userID).collection("postsVotedFor")
            
            votedPostsRef.getDocuments() {
                (snapshot, error) in
                if let error = error {
                    print("error, could not get voted posts \(error.localizedDescription)")
                    return
                }
                guard let collection = snapshot?.documents else {return}
                
                //var downloadedPosts = [String]()
                var downloadedVotes = [Vote]()
                
                for document in collection {
                    //let documentData = document.data() as! [String : String]
                    
                    var vote = Vote(document: document)
                    
                    //guard let votedPostName = documentData["postID"] else {return}
                    
                    //downloadedPosts.append(votedPostName)
                    downloadedVotes.append(vote)
                    
                    //print(votedPostName)
                }
                self.postVotes = downloadedVotes
                //self.postsVotedFor = downloadedPosts
            }
        }
    }
    
    func checkIfPostIsVotedFor(_ post: Post, in cell: PostTableViewCell) {
        
        for vote in postVotes {
            if vote.postID == post.postID {
                if vote.isUpVote {
                    cell.voteUpButton.isEnabled = false
                    cell.voteDownButton.isEnabled = true
                    return
                } else {
                    cell.voteUpButton.isEnabled = true
                    cell.voteDownButton.isEnabled = false
                    return
                }
            }
        }
        cell.voteUpButton.isEnabled = true
        cell.voteDownButton.isEnabled = true
    }
    
    func postIsVotedByUser(_ post: Post) -> Bool {
        for vote in postVotes {
            if vote.postID == post.postID {
                return true
            }
        }
        return false
    }
        
        
        
//        if postsVotedFor.contains(post.postID) {
//            cell.voteUpButton.isEnabled = false
//            cell.voteDownButton.isEnabled = false
//        } else {
//            cell.voteUpButton.isEnabled = true
//            cell.voteDownButton.isEnabled = true
//        }
    
    func sortPostArray() {
        switch currentSorting {
            
        case .bestDeal:
            listOfPosts = listOfPosts.sorted(by: { $0.ratingOfDeal > $1.ratingOfDeal })
            
        case .newestFirst:
            listOfPosts = listOfPosts.sorted(by: {$0.postNumber > $1.postNumber })
            
        }
        
    }
    
    func reloadTableView() {
        UIView.transition(with: postTableView,
        duration: 0.35,
        options: .transitionCrossDissolve,
        animations: { self.postTableView.reloadData() })
    }
    
    @IBAction func increaseRatingValue(_ sender: UIButton) {
        guard let cell = sender.superview?.superview as? PostTableViewCell else {
            fatalError()
        }
        
        if let indexPath = postTableView.indexPath(for: cell) {
            print(Int(indexPath.row))
            
            let currentPost: Post = listOfPosts[indexPath.row]
            var increaseValue = 1
            
            if postIsVotedByUser(currentPost) {
                increaseValue = 2
                cell.voteUpButton.isEnabled = false
                cell.voteDownButton.isEnabled = true
                changeVote(of: currentPost, isAnUpVote: true)
            }
            
            let newValue = currentPost.ratingOfDeal + increaseValue
            
            currentPost.ratingOfDeal += increaseValue
            
            cell.ratingLabel.text = String(newValue)
            
            updateRatingValue(of: currentPost, with: newValue, isAnUpVote: true) {
                reloadTableView()
            }
        }
    }
    
    @IBAction func decreaseRatingValue(_ sender: UIButton) {
        guard let cell = sender.superview?.superview as? PostTableViewCell else {
            fatalError()
        }
        
        if let indexPath = postTableView.indexPath(for: cell) {
            print(Int(indexPath.row))
            
            let currentPost: Post = listOfPosts[indexPath.row]
            var decreaseValue = 1
            
            if postIsVotedByUser(currentPost) {
                decreaseValue = 2
                cell.voteDownButton.isEnabled = false
                cell.voteUpButton.isEnabled = true
                changeVote(of: currentPost, isAnUpVote: false)
            }
            
            let newValue = currentPost.ratingOfDeal - decreaseValue
            
            currentPost.ratingOfDeal -= decreaseValue
            
            cell.ratingLabel.text = String(newValue)
            
            updateRatingValue(of: currentPost, with: newValue, isAnUpVote: false) {
                reloadTableView()
            }
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return(listOfPosts.count)
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
            sortPostArray()
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as! PostTableViewCell
            let post = listOfPosts[indexPath.row]
        
            checkIfPostIsVotedFor(post, in: cell)
            
            cell.locationLabel.text = post.locationOfItem
            cell.postImage.image = post.image
            
            cell.ratingLabel.text = String(post.ratingOfDeal)
        
            tableView.rowHeight = 440
        
            tableView.contentInset.bottom = 70
        
            return cell
            
        }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        let destinationVC = segue.destination as! ViewControllerCamera
//
//    }
    
    
    
}
    




