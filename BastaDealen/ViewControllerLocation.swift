//
//  ViewControllerLocation.swift
//  BastaDealen
//
//  Created by Emil Laudon on 2020-01-21.
//  Copyright © 2020 Emil Laudon. All rights reserved.
//

import UIKit

class ViewControllerLocation: UIViewController {
    @IBOutlet weak var locationInputField: UITextField!
    @IBOutlet weak var locationInputFieldView: UIView!
    
    var listOfPosts: [Post]?
    
    var imageSelected: String?
    var location: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationInputFieldView.layer.cornerRadius = 10
        // Do any additional setup after loading the view.
    }
    
    @IBAction func post(_ sender: Any) {
        location = locationInputField.text
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: (Any)?) {
        let destinationVC = segue.destination as! ViewController
        
        destinationVC.imageSelected = imageSelected
        destinationVC.location = locationInputField.text
        if let listOfPostsToSend: [Post] = listOfPosts {
            destinationVC.listOfPosts = listOfPostsToSend
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

}
