//
//  CoursesCollectionViewCell.swift
//  UDMClient
//
//  Created by OSXVN on 1/8/17.
//  Copyright © 2017 XUANVINHTD. All rights reserved.
//

import UIKit
import Cosmos

class CoursesCollectionViewCell: UICollectionViewCell, Reusable {
    // MARK: - Properties
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var nameTeacher: UILabel!
    @IBOutlet weak var oldPrice: UILabel!
    @IBOutlet weak var newPrice: UILabel!
    @IBOutlet weak var ratingController: CosmosView!
    @IBOutlet weak var seeAllLabel: UILabel!
    
    static var nib: UINib? {
        return UINib(nibName: String(CoursesCollectionViewCell.self), bundle: nil)
    }
    
    var course: Course = Course()
    var isSeeAll = false
    
    @IBOutlet weak var courseImage: UIImageView!
    
    // MARK: - Initialzation
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.masksToBounds = true
        //self.layer.cornerRadius = 10.0
        self.layer.shadowOffset = CGSizeZero
        self.layer.shadowRadius = 2.0
        self.layer.shadowOpacity = 1
        self.layer.shadowColor = UIColor.grayColor().CGColor
        self.layer.masksToBounds = false
        
        self.newPrice.textColor = UDMHelpers.textTheme()
        self.backgroundColor = UDMHelpers.backgroudTheme()
        self.backgroundColor = UIColor.whiteColor()
        
        //        blueView.layer.shadowColor = UIColor.blackColor().CGColor
        //        blueView.layer.shadowOffset = CGSize(width: 3, height: 3)
        //        blueView.layer.shadowOpacity = 0.7
        //        blueView.layer.shadowRadius = 4.0
        //http://stackoverflow.com/questions/4754392/uiview-with-rounded-corners-and-drop-shadow/34984063#34984063
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        initData()
    }
    
    func initData() {
        if isSeeAll {
            title.hidden = isSeeAll
            nameTeacher.hidden = isSeeAll
            oldPrice.hidden = isSeeAll
            newPrice.hidden = isSeeAll
            ratingController.hidden = isSeeAll
            courseImage.hidden = isSeeAll
            seeAllLabel.hidden = !isSeeAll
            
        } else {
            title.hidden = isSeeAll
            nameTeacher.hidden = isSeeAll
            oldPrice.hidden = isSeeAll
            newPrice.hidden = isSeeAll
            ratingController.hidden = isSeeAll
            courseImage.hidden = isSeeAll
            seeAllLabel.hidden = !isSeeAll
            
            let attributes = [
                
                NSStrikethroughStyleAttributeName : 1]
            
            let titleStr = NSAttributedString(string: "$" + ((course.oldPrice == "0") ? "45.000" : course.oldPrice), attributes: attributes) //1
            
            self.title.text = course.title
            self.nameTeacher.text = "(\(2359))"
            self.newPrice.text = "$" + course.newPrice
            self.oldPrice.attributedText = titleStr
            self.ratingController.userInteractionEnabled = false
            self.ratingController.rating = Double(course.review) ?? 3.5
            
            let url = self.course.thumbnail
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
                
                let img = UDMHelpers.getImageByURL(with: url)
                
                dispatch_async(dispatch_get_main_queue(), {
                    self.courseImage.image = img
                })
            }
        }
    }
}

