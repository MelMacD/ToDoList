//
//  ListItemTableViewController.swift
//  ToDoList
//
//  Created by Melanie MacDonald on 2018-10-27.
//  Copyright © 2018 Melanie MacDonald. All rights reserved.
//

import UIKit
import os.log

class ListItemTableViewController: UITableViewController {

    //MARK: Properties
    
    var listItems = [ListItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Display an Edit button in the navigation bar for this view controller.
        navigationItem.leftBarButtonItem = editButtonItem
        
        if let savedItems = loadItems() {
            if savedItems.count != 0 {
                listItems += savedItems
            } else {
                loadSampleItems()
            }
        }
        else {
            os_log("I guess this doesn't happen", log: OSLog.default, type: .debug)
            // Load sample data
            loadSampleItems()
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listItems.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        // Table view cells are reused and should be dequeued using a cell identifier
        let cellIdentifier = "ListItemTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ListItemTableViewCell else {
            fatalError("The dequeued cell is not an instance of ListItemTableViewCell.")
        }
        
        // Fetches the appropriate meal for the data source layout
        let listItem = listItems[indexPath.row]
        
        cell.titleLabel.text = listItem.title
        cell.pictureImageView.image = listItem.photo.photo
        /*cell.imageScrollView.zoomScale = listItem.photo.scaleAmount
        cell.imageScrollView.contentOffset.x = listItem.photo.centerX
        cell.imageScrollView.contentOffset.y = listItem.photo.centerY*/ // commented out as does not scale for the tabbed sized image
        cell.priorityImageView.image = getImageForPriority(selection: listItem.priority)
        cell.dueDateLabel.text = displayDateDue(dateDue: listItem.dateDue)
        
        return cell
    }
    

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            listItems.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            saveItems()
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? "") {
        case "AddItem":
            os_log("Adding a new meal", log: OSLog.default, type: .debug)
        case "ShowDetail":
            guard let listItemDetailViewController = segue.destination as? ListViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let selectedItemCell = sender as? ListItemTableViewCell else {
                fatalError("Unexpected sender: \(String(describing: sender))")
            }
            
            guard let indexPath = tableView.indexPath(for: selectedItemCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            let selectedItem = listItems[indexPath.row]
            listItemDetailViewController.listItem = selectedItem
        default:
            fatalError("Unexpected Segue Identifer; \(String(describing: segue.identifier))")
        }
    }
 

    //MARK: Actions
    @IBAction func unwindToItemList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? ListViewController, let
            listItem = sourceViewController.listItem {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                // Update an existing item
                listItems[selectedIndexPath.row] = listItem
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            }
            else {
                // Add a new item
                let newIndexPath = IndexPath(row: listItems.count, section: 0)
                listItems.append(listItem)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
            // Save the items
            saveItems()
        }
    }
    //MARK: Private Methods
    
    private func loadSampleItems() {
        let photo = Image(photo: UIImage(named: "defaultPhoto")!, scaleAmount: 1.0, centerX: CGFloat(0.0), centerY: CGFloat(0.0))
        
        guard let listItem1 = ListItem(title: "Default item", photo: photo!, notes: "Here are some notes", dateEntered: "1 January, 1970", dateDue: "Immediately", priority: 0) else {
            fatalError("Unable to instantiate list item1")
        }
        
        guard let listItem2 = ListItem(title: "Default item2", photo: photo!, notes: "Here are some more notes", dateEntered: "1 January, 1970", dateDue: "Immediately", priority: 0) else {
            fatalError("Unable to instantiate list item2")
        }
        listItems += [listItem1, listItem2]
    }
    
    private func saveItems() {
        listItems = SortedListItems(listItems: listItems)!.sortList()
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(listItems, toFile: ListItem.ArchiveURL.path)
        
        if isSuccessfulSave {
            os_log("Items successfully save", log: OSLog.default, type: .debug)
            self.tableView.reloadData()
        } else {
            os_log("Failed to save items", log: OSLog.default, type: .error)
        }
    }
    
    private func loadItems() -> [ListItem]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: ListItem.ArchiveURL.path) as? [ListItem]
    }
    
    // Display the respective image to the UI as relates to the priority
    private func getImageForPriority(selection: Int) -> UIImage {
        if selection == 0 {
            return UIImage(named: "lowPriority")!
        }
        else if selection == 1 {
            return UIImage(named: "mediumPriority")!
        }
        else {
            return UIImage(named: "highPriority")!
        }
    }
    
    // Displays the due date according to the type that was saved in storage
    private func displayDateDue(dateDue: Any) -> String {
        // An int suggests that the due date was empty, so return an empty string
        if dateDue is Int {
            return ""
        }
        // A date suggests a legitimate date was chosen, so it should be displayed
        else if dateDue is Date {
            return convertDateToString(date: dateDue as! Date)
        }
        // A string suggests the task is to be done as soon as possible, so return that string
        else if dateDue is String {
            return dateDue as! String
        }
        // Otherwise indicate that there has been an error
        else {
            os_log("The due date could not be parsed", log: OSLog.default, type: .error)
            return "Error"
        }
    }
    
    // Converts a Date object into a readable String
    func convertDateToString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .short
        
        dateFormatter.locale = Locale(identifier: "en_US")
        return dateFormatter.string(from: date)
    }
}
