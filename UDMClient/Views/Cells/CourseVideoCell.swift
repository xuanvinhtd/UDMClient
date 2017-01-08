//
//  CourseVideoCell.swift
//  UDMClient
//
//  Created by OSXVN on 1/5/17.
//  Copyright © 2017 XUANVINHTD. All rights reserved.
//

import UIKit
import Cosmos

final class CourseVideoCell: UITableViewCell, Reusable {
    // MARK: - Properties
    @IBOutlet weak var courseVideo: UIImageView!
    @IBOutlet weak var courseName: UILabel!
    @IBOutlet weak var labelPesonName: UILabel!
    @IBOutlet weak var costSourse: UILabel!
    @IBOutlet weak var buttonBuy: UIButton!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var ratingControl: CosmosView!
    
    static var nib: UINib? {
        return UINib(nibName: String(CourseVideoCell.self), bundle: nil)
    }
    // MARK: - Method
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
