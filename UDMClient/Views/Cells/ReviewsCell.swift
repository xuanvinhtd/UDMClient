//
//  ReviewsCell.swift
//  UDMClient
//
//  Created by OSXVN on 1/8/17.
//  Copyright © 2017 XUANVINHTD. All rights reserved.
//

import UIKit
import Cosmos

final class ReviewsCell: UITableViewCell, Reusable {
    // MARK: - Properties
    @IBOutlet weak var noReviews: UILabel!
    @IBOutlet weak var ratingControl: CosmosView!
    @IBOutlet weak var nameReviewer: UILabel!
    @IBOutlet weak var dateReview: UILabel!
    @IBOutlet weak var textViewContents: UITextView!
    @IBOutlet weak var titleLabel: UILabel!
    
    static var nib: UINib? {
        return UINib(nibName: String(ReviewsCell.self), bundle: nil)
    }
    
    // MARK: - Method init
    override func awakeFromNib() {
        super.awakeFromNib()
        textViewContents.sizeToFit()
        textViewContents.scrollEnabled = false
        ratingControl.userInteractionEnabled = false
    }
}

