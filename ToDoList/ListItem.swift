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
    var dateEntered: String
    var dateDue: Any
    var priority: Int
    
    //MARK: Archiving Paths
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("listItems")
    
    //MARK: Types
    
    struct PropertyKey {
        static let title = "title"
        static let photo = "photo"
        static let notes = "notes"
        static let dateEntered = "dateEntered"
        static let dateDue = "dateDue"
        static let priority = "priority"
    }
    
    //MARK: Initialization
    
    init?(title: String, photo: Image, notes: String, dateEntered: String, dateDue: Any, priority: Int) {
        // Initialization should fail under certain conditions
        guard !title.isEmpty else {
            return nil
        }
        
        // Initialize with given values
        self.title = title
        self.photo = photo
        self.notes = notes
        self.dateEntered = dateEntered
        self.dateDue = dateDue
        self.priority = priority
    }
    
    //MARK: NSCoding
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(title, forKey: PropertyKey.title)
        photo.encode(with: aCoder)
        aCoder.encode(notes, forKey: PropertyKey.notes)
        aCoder.encode(dateEntered, forKey: PropertyKey.dateEntered)
        aCoder.encode(dateDue, forKey: PropertyKey.dateDue)
        aCoder.encode(priority, forKey: PropertyKey.priority)
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
        
        // if this can't return nil, then should be 0; so String, Date, or Int
        let dateDue = aDecoder.decodeObject(forKey: PropertyKey.dateDue) as Any
        
        let priority = aDecoder.decodeInteger(forKey: PropertyKey.priority)
        
        // Must call desginated initializer
        self.init(title: title, photo: photo, notes: notes!, dateEntered: dateEntered, dateDue: dateDue, priority: priority)
    }

}
