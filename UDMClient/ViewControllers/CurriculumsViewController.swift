//
//  Curriculum.swift
//  UDMClient
//
//  Created by OSXVN on 12/28/16.
//  Copyright © 2016 XUANVINHTD. All rights reserved.
//

import UIKit

final class CurriculumsViewController: UIViewController {
    // MARK: - Properties
    @IBOutlet weak var tableView: UITableView!
    var curriculumns = [Curruculum]()
    let tabLabel = 100
    
    // MARK: - Life view cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.contentInset = UIEdgeInsetsZero;
        initData()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "Curriculmn List"
    }
    
    // MARK: - Initialzation
    override func initData() {
        //Get curriculumns
        UDMServer.share.getCurriculumns(withCourseID: "1") { (data, msg, success) in
            if success {
                self.curriculumns = Curruculum.createCurruculum(withInfos: data)
            } else {
                log.error("Cannot get Curriculumns: \(msg)")
            }
            dispatch_async(dispatch_get_main_queue(), {
                self.tableView.reloadData()
            })
        }
    }
}
// MARK: - TableViewDelegate
extension CurriculumsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return curriculumns.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cellTable = tableView.dequeueReusableCellWithIdentifier("defaulCell")
        if cellTable == nil {
            cellTable = UITableViewCell.init(style: .Subtitle, reuseIdentifier: "defaulCell")
            cellTable?.imageView?.image = UIImage(named: "imageWhite")
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
            label.layer.cornerRadius = 12.5
            label.layer.borderWidth = 1.0
            label.layer.borderColor = UDMHelpers.grayTheme().CGColor
            label.text = curriculumns[indexPath.row].numbers
            label.textAlignment = .Center
            label.tag = tabLabel
            label.backgroundColor = UIColor.clearColor()
            
            cellTable?.imageView?.addSubview(label)
            cellTable?.detailTextLabel?.textColor = UDMHelpers.grayTheme()
            cellTable?.detailTextLabel?.text = "Video - " + curriculumns[indexPath.row].timeVideo
            // goi y : thay image co size phu hop va mau trang
        }
        if let labelNumber = cellTable?.imageView?.viewWithTag(tabLabel) as? UILabel {
            labelNumber.text = String(indexPath.row)
        }
        
        cellTable?.textLabel?.text = curriculumns[indexPath.row].title
        return cellTable!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let urlStr = UDMConfig.API.rootDoman + curriculumns[indexPath.row].videoPlay
        print("Clicked row: \(urlStr)")
        //NSNotificationCenter.defaultCenter().postNotificationName(CourseDetailViewController.Notification.PlayVideo, object: nil, userInfo: ["URLVIDEO" : urlStr])
    }
}
