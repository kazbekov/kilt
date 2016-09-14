//
//  Discount.swift
//  Kilt
//
//  Created by Nurdaulet Bolatov on 7/27/16.
//  Copyright © 2016 Nurdaulet Bolatov. All rights reserved.
//

//
//  Discount2.swift
//  Kilt
//
//  Created by Nurdaulet Bolatov on 7/27/16.
//  Copyright © 2016 Nurdaulet Bolatov. All rights reserved.
//

import UIKit
import FirebaseDatabase
import MapKit

struct Location {
    var latitude: Double?
    var longitude: Double?
}

final class Discount {
    
    static var ref = FIRDatabase.database().reference().child("bonuses")
    var ref: FIRDatabaseReference?
    
    var title: String?
    var subtitle: String?
    var percent: String?
    var address: String?
    var logo: String?
    var location: Location?
    var images: [String: String]?
    
    init (title: String?, subtitle: String?, percent: String?, address: String?, logo: String, location: Location? = nil, images: [String: String]? = nil
        ){
        self.title  = title
        self.address = address
        self.percent = percent
        self.subtitle = subtitle
        self.logo = logo
        self.ref = nil
        self.images = images
        self.location = location
        ref = FIRDatabase.database().reference().child("bonuses").childByAutoId()
    }
    
    init(snapshot: FIRDataSnapshot, childChanged: () -> Void){
        updateFromSnapshot(snapshot)
        snapshot.ref.observeEventType(.Value, withBlock: { snapshot in
            self.updateFromSnapshot(snapshot)
            childChanged()
        })
        ref = snapshot.ref
    }
    
    func save(completion: (error: NSError?) -> Void) {
        saveTitle(completion)
        saveSubtitle(completion)
        savePercent(completion)
        saveAddress(completion)
        saveLogo(completion)
        saveLocation(completion)
        saveImages(completion)
    }
    
    func updateFromSnapshot(snapshot: FIRDataSnapshot){
        ref = snapshot.ref
        title = snapshot.value?.objectForKey("title") as? String
        subtitle = snapshot.value?.objectForKey("subtitle") as? String
        percent = snapshot.value?.objectForKey("percent") as? String
        address = snapshot.value?.objectForKey("address") as? String
        logo = snapshot.value?.objectForKey("logo") as? String
        if let locationDict = snapshot.value?.objectForKey("location") as? [String : Double] {
            location = Location(latitude: locationDict["latitude"], longitude: locationDict["longitude"])
        }
        if let imagesDict = snapshot.value?.objectForKey("images") as? [String: String] {
            images = imagesDict
        }
        //images = snapshot.value?.objectForKey("images") as? [String: String]
    }
    
    func saveTitle(completion: (error: NSError?) -> Void) {
        ref?.child("title").setValue(title) { error, ref in
            completion(error: error)
        }
    }
    
    func saveSubtitle(completion: (error: NSError?) -> Void){
        ref?.child("subtitle").setValue(subtitle) { error, ref in completion(error: error)
            
        }
    }
    
    func savePercent(completion: (error: NSError?) -> Void){
        ref?.child("percent").setValue(percent) { error, ref in completion(error: error)
            
        }
    }
    
    func saveLogo(completion: (error: NSError?) -> Void){
        ref?.child("logo").setValue(logo) {
            error, ref in completion(error: error)
        }
    }
    
    func saveAddress(completion: (error: NSError?) -> Void){
        ref?.child("address").setValue(address) {
            error, ref in completion(error: error)
        }
    }
    func saveLocation(completion: (error: NSError?) -> Void){
        ref?.child("location").setValue([
            "longitude": location?.longitude ?? NSNull(),
            "latitude": location?.latitude ?? NSNull()
        ]) {
            error, ref in completion(error: error)
        }
    }
    func saveImages(completion: (error: NSError?) -> Void){
        ref?.child("images").setValue(images)
        {
            error, ref in completion(error: error)
        }
    }
    
    static func fetchDiscounts(completion: (snapshot: FIRDataSnapshot) -> Void) {
        ref.observeEventType(.ChildAdded) { snapshot in
            completion(snapshot: snapshot)
        }
    }
}