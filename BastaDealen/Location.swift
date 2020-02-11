//
//  Location.swift
//  BastaDealen
//
//  Created by Emil Laudon on 2020-02-08.
//  Copyright © 2020 Emil Laudon. All rights reserved.
//

import Foundation
import Firebase

class Location: Comparable {

    
    let locationName: String
    let locationNumber: Int
    
    init(document: QueryDocumentSnapshot) {
        let snapshotValue = document.data() as [String : Any]
        
        self.locationName = snapshotValue["location"] as! String
        self.locationNumber = snapshotValue["number"] as! Int
        
    }
    
    static func < (lhs: Location, rhs: Location) -> Bool {
        return lhs.locationNumber > rhs.locationNumber
    }
    
    static func == (lhs: Location, rhs: Location) -> Bool {
        return lhs.locationNumber == rhs.locationNumber
    }
}

class LocationCell: UITableViewCell {
    
    @IBOutlet weak var locationLabel: UILabel!
    
    
    
}
