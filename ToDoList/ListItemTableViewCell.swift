//
//  ListItemTableViewCell.swift
//  ToDoList
//
//  Created by Melanie MacDonald on 2018-10-24.
//  Copyright © 2018 Melanie MacDonald. All rights reserved.
//

import UIKit

class ListItemTableViewCell: UITableViewCell {

    //Properties
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var pictureImageView: UIImageView!
    @IBOutlet weak var dueDateLabel: UILabel!
    @IBOutlet weak var priorityImageView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
