//
//  CourseCurriculumCell.swift
//  UDMClient
//
//  Created by OSXVN on 1/8/17.
//  Copyright © 2017 XUANVINHTD. All rights reserved.
//

import UIKit

final class CourseCurriculumCell: UITableViewCell, Reusable {
    // MARK: - Properties
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var buttonSeeAll: UIButton!
    @IBOutlet weak var tableview: UITableView!
    
    static var nib: UINib? {
        return UINib(nibName: String(CourseCurriculumCell.self), bundle: nil)
    }
    
    var curriculumns = [Curruculum]()
    
    // MARK: - Method init
    override func awakeFromNib() {
        super.awakeFromNib()
        tableview.delegate = self
        tableview.dataSource = self
        tableview.contentInset = UIEdgeInsetsZero;
    }
    
    func initData() {
        self.activityIndicator.startAnimating()
        //Get curriculumns
        UDMServer.share.getCurriculumns(withCourseID: "1") { (data, msg, success) in
            if success {
                self.curriculumns = Curruculum.createCurruculum(withInfos: data)
                self.tableview.reloadData()
            } else {
                log.error("Cannot get curriculumns: \(msg)")
            }
            dispatch_async(dispatch_get_main_queue(), {
                self.activityIndicator.stopAnimating()
            })
        }
    }
}

extension CourseCurriculumCell: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return curriculumns.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cellTable = tableView.dequeueReusableCellWithIdentifier("defaultCell")
        if cellTable == nil {
            cellTable = UITableViewCell.init(style: .Subtitle, reuseIdentifier: "defaultCell")
            cellTable?.imageView?.image = UIImage(named: "imageWhite")
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
            label.layer.cornerRadius = 12.5
            label.layer.borderWidth = 1.0
            label.layer.borderColor = UDMHelpers.grayTheme().CGColor
            label.text = curriculumns[indexPath.row].numbers
            label.textAlignment = .Center
            label.tag = 100
            label.backgroundColor = UIColor.clearColor()
            
            cellTable?.imageView?.addSubview(label)
            cellTable?.detailTextLabel?.textColor = UDMHelpers.grayTheme()
            cellTable?.detailTextLabel?.text = "Video - " + curriculumns[indexPath.row].timeVideo
            // goi y : thay image co size phu hop va mau trang
        }
        if let labelNumber = cellTable?.imageView?.viewWithTag(100) as? UILabel {
            labelNumber.text = String(indexPath.row)
        }
        
        cellTable?.textLabel?.text = curriculumns[indexPath.row].title
        return cellTable!
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        animateCell(cell)
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let urlStr = UDMConfig.API.doman + curriculumns[indexPath.row].videoPlay
        log.info("Play video with URL: \(urlStr)")
        
       // NSNotificationCenter.defaultCenter().postNotificationName(CourseDetailViewController.Notification.PlayVideo, object: nil, userInfo: ["URLVIDEO" : urlStr])
    }
    
    // MARK: Animation TableViewCell
    func animateCell(cell: UITableViewCell) {
        let animation = CABasicAnimation(keyPath: "opacity")
        animation.fromValue = 0.0
        animation.toValue = 1
        animation.duration = 0.5
        cell.layer.addAnimation(animation, forKey: animation.keyPath)
    }
}

