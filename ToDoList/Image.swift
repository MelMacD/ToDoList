//
//  Image.swift
//  ToDoList
//
//  Created by Melanie MacDonald on 2018-10-24.
//  Copyright © 2018 Melanie MacDonald. All rights reserved.
//

import UIKit

class Image: NSObject {
    
    //MARK: Properties
    
    var photo: UIImage
    var scaleAmount: CGFloat
    var centerX: CGFloat
    var centerY: CGFloat
    
    //MARK: Archiving Paths
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("listItems")
    
    //MARK: Types
    struct PropertyKey {
        static let photo = "photoNew"
        static let scaleAmount = "scale"
        static let centerX = "centerX"
        static let centerY = "centerY"
    }
    //MARK: Initialization
    
    init?(photo: UIImage, scaleAmount: CGFloat, centerX: CGFloat, centerY: CGFloat) {

        // Initialize with given values
        self.photo = photo
        self.scaleAmount = scaleAmount
        self.centerX = centerX
        self.centerY = centerY
    }
    
    //MARK: NSCoding
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(photo, forKey: PropertyKey.photo)
        aCoder.encode(scaleAmount, forKey: PropertyKey.scaleAmount)
        aCoder.encode(centerX, forKey: PropertyKey.centerX)
        aCoder.encode(centerY, forKey: PropertyKey.centerY)
    }
    
    required convenience init?(coder aDecoder: NSCoder){
        let photo = aDecoder.decodeObject(forKey: PropertyKey.photo) as? UIImage
        let scaleAmount = aDecoder.decodeObject(forKey: PropertyKey.scaleAmount) as? CGFloat
        let centerX = aDecoder.decodeObject(forKey: PropertyKey.centerX) as? CGFloat
        let centerY = aDecoder.decodeObject(forKey: PropertyKey.centerY) as? CGFloat
        
        
        // Must call designated initializer
        self.init(photo: photo!, scaleAmount: scaleAmount!, centerX: centerX!, centerY: centerY!)
    }
    
}
