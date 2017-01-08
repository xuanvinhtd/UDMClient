//
//  CourseCell.swift
//  UDMClient
//
//  Created by OSXVN on 1/8/17.
//  Copyright © 2017 XUANVINHTD. All rights reserved.
//

import UIKit
import Cosmos

final class CourseCell: UITableViewCell, Reusable {
    // MARK: - Properties
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var teacherName: UILabel!
    @IBOutlet weak var courseImage: UIImageView!
    @IBOutlet weak var moneyTextField: UILabel!
    @IBOutlet weak var moneyNew: UILabel!
    @IBOutlet weak var ratingControl: CosmosView!
    
    static var nib: UINib? {
        return UINib(nibName: String(CourseCell.self), bundle: nil)
    }
    
    // MARK: - Initialzation
    override func awakeFromNib() {
        super.awakeFromNib()
        moneyTextField.textColor = UDMHelpers.textTheme()
        ratingControl.userInteractionEnabled = false
    }
}
