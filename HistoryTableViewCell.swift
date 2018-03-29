//
//  HistoryTableViewCell.swift
//  TaskSolutionCommivoyagera
//
//  Created by E.Vladimir A. on 07.11.2017.
//  Copyright © 2017 E.Vladimir A. All rights reserved.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cityCount: UILabel!
    @IBOutlet weak var dateOutlet: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    
}
