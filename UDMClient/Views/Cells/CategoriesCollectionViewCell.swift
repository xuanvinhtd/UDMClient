//
//  CategoriesCollectionViewCell.swift
//  UDMClient
//
//  Created by OSXVN on 1/8/17.
//  Copyright © 2017 XUANVINHTD. All rights reserved.
//

import UIKit

class CategoriesCollectionViewCell: UICollectionViewCell , Reusable {
    // MARK: - Properties
    @IBOutlet weak var myImage: UIImageView!
    var nameCategory: UILabel!
    var rect: CGRect!
    
    static var nib: UINib? {
        return UINib(nibName: String(CategoriesCollectionViewCell.self), bundle: nil)
    }
    
    var categorie: Category = Category()
    
    // MARK: - Initialzation
    override func awakeFromNib() {
        super.awakeFromNib()
        let bounds = CGRectMake(0, 0, self.bounds.width, self.bounds.height)
        
        let markView = UIView(frame: bounds)
        markView.backgroundColor = UIColor.blackColor()
        markView.alpha = 0.5
        
        self.myImage.addSubview(markView)
        nameCategory = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height))
        nameCategory.textColor = UIColor.whiteColor()
        self.myImage.addSubview(nameCategory)
    }
    
    func initData(with c: Category) {
        nameCategory.frame = rect
        nameCategory.text = c.title
        nameCategory.textColor = UIColor.whiteColor()
        nameCategory.textAlignment = .Center
        nameCategory.backgroundColor = UIColor.clearColor()
        self.myImage.addSubview(nameCategory)
        
        let url = c.thumbnail
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            let img = UDMHelpers.getImageByURL(with: url)
            dispatch_async(dispatch_get_main_queue(), {
                self.myImage.image = img
            })
        }
    }
}

