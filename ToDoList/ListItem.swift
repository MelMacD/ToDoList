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
    var photo: Image
    var notes: String
    //var dueDate: Date// this might need to be a generic type
    var dateEntered: String
    //var priority: Selector// this might ned a different type as well
    
    //MARK: Archiving Paths
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("listItems")
    
    //MARK: Types
    
    struct PropertyKey {
        static let title = "title"
        static let photo = "photo"
        static let notes = "notes"
        static let dateEntered = "dateEntered"
    }
    
    //MARK: Initialization
    
    init?(title: String, photo: Image, notes: String, dateEntered: String) {
        // Initialization should fail under certain conditions
        guard !title.isEmpty else {
            return nil
        }
        
        // Initialize with given values
        self.title = title
        self.photo = photo
        self.notes = notes
        self.dateEntered = dateEntered
    }
    
    //MARK: NSCoding
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(title, forKey: PropertyKey.title)
        photo.encode(with: aCoder)
        aCoder.encode(notes, forKey: PropertyKey.notes)
        aCoder.encode(dateEntered, forKey: PropertyKey.dateEntered)
    }
    
    required convenience init?(coder aDecoder: NSCoder){
        // Title is required
        guard let title = aDecoder.decodeObject(forKey: PropertyKey.title) as? String else {
            os_log("Unable to decode the name for a ListItem object", log: OSLog.default, type: .debug)
            return nil
        }
        // Date entered is required
        guard let dateEntered = aDecoder.decodeObject(forKey: PropertyKey.dateEntered) as? String else {
            os_log("Unable to decode the date entered for a ListItem object", log: OSLog.default, type: .debug)
            return nil
        }
        let photo = Image(coder: aDecoder)!

        let notes = aDecoder.decodeObject(forKey: PropertyKey.notes) as? String
        
        // Must call desginated initializer
        self.init(title: title, photo: photo, notes: notes!, dateEntered: dateEntered)
    }
}
