//
//  Image.swift
//  ToDoList
//
//  Created by Melanie MacDonald on 2018-10-24.
//  Copyright © 2018 Melanie MacDonald. All rights reserved.
//

import UIKit

class Image {
    
    //MARK: Properties
    
    var photo: UIImage
    var scaleAmount: Int
    var center: Int
    
    //MARK: Initialization
    
    init?(photo: UIImage, scaleAmount: Int, center: Int) {
        
        // Initialize with given values
        self.photo = photo
        self.scaleAmount = scaleAmount
        self.center = center
    }
}
