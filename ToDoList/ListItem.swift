//
//  ListItem.swift
//  ToDoList
//
//  Created by Melanie MacDonald on 2018-10-24.
//  Copyright © 2018 Melanie MacDonald. All rights reserved.
//

import UIKit
import os.log

class ListItem: NSObject, NSCoding {
    
    //MARK: Properties
    
    var title: String
    var photo: UIImage? // change this to image object later
    var notes: String
    //var dueDate: Date// this might need to be a generic type
    //var dateEntered: Date
    //var priority: Selector// this might ned a different type as well
    
    //MARK: Archiving Paths
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("listItems")
    
    //MARK: Types
    
    struct PropertyKey {
        static let title = "title"
        static let photo = "photo"
        static let notes = "notes"
    }
    
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
    
    //MARK: NSCoding
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(title, forKey: PropertyKey.title)
        aCoder.encode(photo, forKey: PropertyKey.photo)
        aCoder.encode(notes, forKey: PropertyKey.notes)
    }
    
    required convenience init?(coder aDecoder: NSCoder){
        // Title is required
        guard let title = aDecoder.decodeObject(forKey: PropertyKey.title) as? String else {
            os_log("Unable to decode the name for a ListItem object", log: OSLog.default, type: .debug)
            return nil
        }
        
        // Because photo and notes are optional, use conditional cast
        let photo = aDecoder.decodeObject(forKey: PropertyKey.photo) as? UIImage
        let notes = aDecoder.decodeObject(forKey: PropertyKey.notes) as? String
        
        // Must call desginated initializer
        self.init(title: title, photo: photo, notes: notes!)
    }
}
