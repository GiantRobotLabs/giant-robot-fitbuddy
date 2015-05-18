//
//  WorkoutLogCell.swift
//  FitBuddy
//
//  Created by john.neyer on 5/17/15.
//  Copyright (c) 2015 jneyer.com. All rights reserved.
//

import Foundation
import UIKit

class WorkoutLogCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    
    func setCellValues (#name: String, date: String) {
        self.nameLabel.text = name
    }
}