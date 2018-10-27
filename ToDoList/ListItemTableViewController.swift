//
//  ListItemTableViewController.swift
//  ToDoList
//
//  Created by Melanie MacDonald on 2018-10-27.
//  Copyright © 2018 Melanie MacDonald. All rights reserved.
//

import UIKit

class ListItemTableViewController: UITableViewController {

    //MARK: Properties
    
    var listItems = [ListItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Load the sample data
        loadSampleMeals()

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
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
        cell.pictureImageView.image = listItem.photo

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    //MARK: Actions
    @IBAction func unwindToItemList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? ListViewController, let listItem = sourceViewController.listItem {
            // Add a new item
            let newIndexPath = IndexPath(row: listItems.count, section: 0)
            listItems.append(listItem)
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        }
    }
    //MARK: Private Methods
    
    private func loadSampleMeals() {
        let photo = UIImage(named: "defaultPhoto")
        
        guard let listItem1 = ListItem(title: "Default item", photo: photo, notes: "Here are some notes") else {
            fatalError("Unable to instantiate list item1")
        }
        
        guard let listItem2 = ListItem(title: "Default item2", photo: photo, notes: "Here are some more notes") else {
            fatalError("Unable to instantiate list item2")
        }
        listItems += [listItem1, listItem2]
    }
}
