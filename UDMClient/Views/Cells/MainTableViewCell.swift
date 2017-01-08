//
//  MainTableViewCell.swift
//  UDMClient
//
//  Created by OSXVN on 1/8/17.
//  Copyright © 2017 XUANVINHTD. All rights reserved.
//

import UIKit

final class MainTableViewCell: UITableViewCell, Reusable {
    // MARK: - Properties
    var heightCollectionView = 260
    
    lazy var collecttionView: UICollectionView = {
        //FIX
        let frameUICollection = CGRect(x: 0, y: 0, width: Int(UDMHelpers.getScreenRect().width), height: 260 + 30)
        let sizeItemCollection = CGSize(width: Int(UDMHelpers.getScreenRect().width / 3), height: 260 - 10)
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .Horizontal
        layout.sectionInset = UIEdgeInsetsMake(5, 10, 10, 10)
        layout.itemSize = sizeItemCollection
        
        let collecttion = UICollectionView(frame: frameUICollection, collectionViewLayout: layout)
        collecttion.showsHorizontalScrollIndicator = false
        collecttion.backgroundColor = UIColor.flatWhiteColor()
        collecttion.clipsToBounds = true
        return collecttion
    }()
    
    
    let activityIndication: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
    let titleActivity: UILabel = UILabel()
    
    // MARK: - Initializetion
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.layoutMargins = UIEdgeInsetsZero
        self.preservesSuperviewLayoutMargins = false
        
        collecttionView.registerReusableCell(CoursesCollectionViewCell.self)
        collecttionView.registerReusableCell(CategoriesCollectionViewCell.self)
        collecttionView.registerReusableCell(CategoriesCollectionViewMain.self)
        
        self.activityIndication.hidesWhenStopped = true
        self.activityIndication.frame = CGRect(x: Int(UDMHelpers.getScreenRect().width)/2 - 25, y: heightCollectionView / 2 - 20, width: 20, height: 20)
        self.titleActivity.frame = CGRect(x: Int(UDMHelpers.getScreenRect().width)/2, y: heightCollectionView / 2 - 20, width: 20, height: 20)
        self.titleActivity.textColor = UIColor.grayColor()
        self.titleActivity.text = "Loading..."
        self.titleActivity.sizeToFit()
        
        self.contentView.addSubview(self.collecttionView)
        self.collecttionView.addSubview(self.activityIndication)
        self.collecttionView.addSubview(self.titleActivity)
        self.activityIndication.startAnimating()
        
        self.backgroundColor = UIColor.clearColor()
    }
    
    func configActivityIndication() {
        self.activityIndication.frame = CGRect(x: Int(UDMHelpers.getScreenRect().width)/2 - 25, y: heightCollectionView / 2 - 20, width: 20, height: 20)
        self.titleActivity.frame = CGRect(x: Int(UDMHelpers.getScreenRect().width)/2, y: heightCollectionView / 2 - 20, width: 20, height: 20)
        self.titleActivity.sizeToFit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MainTableViewCell {
    
    func setCollectionViewDataSourceDelegate<D: protocol<UICollectionViewDataSource, UICollectionViewDelegate>>(dataSourceDelegate: D, forRow: Int) {
        collecttionView.delegate = dataSourceDelegate
        collecttionView.dataSource = dataSourceDelegate
        collecttionView.tag = forRow
        collecttionView.reloadData()
    }
}

