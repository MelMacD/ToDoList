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
    
    // Sorts the priority based on due date, and then priority
    // This implementation groups the items due "Immediately" first, then the items with a due date set, and finally the items without due dates. The ones due Immediately or not at all are sorted by priority, while the ones with a due date are sorted by emergence of the date, and then priority as a tie breaker
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
