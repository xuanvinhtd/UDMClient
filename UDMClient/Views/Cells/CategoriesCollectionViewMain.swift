//
//  CategoriesCollectionViewMain.swift
//  UDMClient
//
//  Created by OSXVN on 1/8/17.
//  Copyright © 2017 XUANVINHTD. All rights reserved.
//

import UIKit

class CategoriesCollectionViewMain: UICollectionViewCell, Reusable  {
    // MARK: - Properties
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameCategory: UILabel!
    
    static var nib: UINib? {
        return UINib(nibName: String(CategoriesCollectionViewMain.self), bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func initData(with c: Category) {
        self.nameCategory.textAlignment = .Center
        self.nameCategory.backgroundColor = UIColor.clearColor()
        self.imageView.addSubview(nameCategory)
        let url = c.thumbnail
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            let img = UDMHelpers.getImageByURL(with: url)
            dispatch_async(dispatch_get_main_queue(), {
                self.imageView.image = img
            })
        }
    }
}

