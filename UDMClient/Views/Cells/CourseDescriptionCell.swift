//
//  CourseDescriptionCell.swift
//  UDMClient
//
//  Created by OSXVN on 1/5/17.
//  Copyright © 2017 XUANVINHTD. All rights reserved.
//

import UIKit

final class CourseDescriptionCell: UITableViewCell, Reusable {
    // MARK: - Properties
    @IBOutlet weak var titleDescription: UILabel!
    @IBOutlet weak var textViewContent: UITextView!
    @IBOutlet weak var buttonSeeAll: UIButton!
    
    static var nib: UINib? {
        return UINib(nibName: String(CourseDescriptionCell.self), bundle: nil)
    }
    
    // MARK: - Method init
    override func awakeFromNib() {
        super.awakeFromNib()
        textViewContent.sizeToFit()
        textViewContent.scrollEnabled = false
    }
    
    func initData(withContent txt: String) {
        textViewContent.text = txt
    }
}

