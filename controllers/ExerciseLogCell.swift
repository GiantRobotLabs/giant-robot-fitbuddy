//
//  LogbookCellController.swift
//  FitBuddy
//
//  Created by john.neyer on 5/17/15.
//  Copyright (c) 2015 jneyer.com. All rights reserved.
//

import Foundation
import UIKit
import FitBuddyCommon


class ExerciseLogCell: UITableViewCell {

    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var workoutLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var valueTypeLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    
    func setCellValues (#name: String, workout: String, value: String?, valueType: String, exerciseType: ExerciseType) {
     
        nameLabel.text = name
        workoutLabel.text = workout
        valueLabel.text = (value == nil ? "0" : value)
        valueTypeLabel.text = valueType
        
        setImageFromType(exerciseType)
    }
    
    func setImageFromType (exerciseType: ExerciseType) {
        
        switch exerciseType {
        case .RESISTANCE:
            iconImageView.image = UIImage(named: FBConstants.kRESISTANCELOGICON)
        case .CARDIO:
            iconImageView.image = UIImage(named: FBConstants.kCARDIOLOGICON)
        default:
            iconImageView.image = nil
        }
    }
}

enum ExerciseType {
    case CARDIO
    case RESISTANCE
}