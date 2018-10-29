//
//  SortedListItems.swift
//  ToDoList
//
//  Created by Melanie MacDonald on 2018-10-28.
//  Copyright © 2018 Melanie MacDonald. All rights reserved.
//

import UIKit

class SortedListItems {
    
    //MARK: Properties
    var listItems = [ListItem]()
    
    init?(listItems: [ListItem]) {
        // Initialize with given values
        self.listItems = listItems
    }
    
    func sortList() -> [ListItem] {
        let sortedList = listItems.sorted {
            if (!($0.dateDue is Int && $1.dateDue is Int) && !($0.dateDue is String && $1.dateDue is String)) {
                if ($0.dateDue is String) {
                    return true
                }
                else if ($1.dateDue is String) {
                    return false
                }
                else if ($0.dateDue is Int) {
                    return false
                }
                else if ($1.dateDue is Int) {
                    return true
                }
                else if (($0.dateDue as! Date) != ($1.dateDue as! Date)) {
                    return $0.priority > $1.priority
                }
                else {
                    return ($0.dateDue as! Date) > ($1.dateDue as! Date)
                }
            }
            else {
                return $0.priority > $1.priority
            }
        }
        return sortedList
    }
}
