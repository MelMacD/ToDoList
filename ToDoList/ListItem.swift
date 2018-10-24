//
//  ListItem.swift
//  ToDoList
//
//  Created by Melanie MacDonald on 2018-10-24.
//  Copyright © 2018 Melanie MacDonald. All rights reserved.
//

import UIKit

class ListItem {
    
    //MARK: Properties
    
    var title: String
    var photo: UIImage? // change this to image object later
    var notes: String
    //var dueDate: Date// this might need to be a generic type
    //var dateEntered: Date
    //var priority: Selector// this might ned a different type as well
    
    //MARK: Initialization
    
    init?(title: String, photo: UIImage?, notes: String) {
        // Initialization should fail under certain conditions
        guard !title.isEmpty else {
            return nil
        }
        
        // Initialize with given values
        self.title = title
        self.photo = photo
        self.notes = notes
    }
}
