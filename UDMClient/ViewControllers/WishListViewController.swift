//
//  WishListViewController.swift
//  UDMClient
//
//  Created by OSXVN on 12/28/16.
//  Copyright © 2016 XUANVINHTD. All rights reserved.
//

import UIKit

final class WishListViewController: UIViewController {
    // MARK: - Properties
    private let heightHeader: CGFloat = 250
    private let heightSection: CGFloat = 650
    private var heightRow: CGFloat = 120
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var courses = [Course]()
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Initialzation
    override func configItems() {
        tableView.tableFooterView = UIView()
        self.navigationItem.title = "Wishlish"
    }
    
    override func initData() {
        if !UserManager.share.isLogInSuccess {
            log.error("Login not success")
            return
        }
        
        checkDeviceAndConfig()
        self.activityIndicator.startAnimating()
        UDMServer.share.getWishList { (data, msg, success) in
            if success {
                self.courses = Course.createCourses(withInfos: data)
                self.tableView.reloadData()
            } else {
                log.error("Cannot get wishlist data: \(msg)")
            }
            self.activityIndicator.stopAnimating()
        }
    }
    
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configItems()
        initData()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidDisappear(animated)
        self.tableView.contentInset = UIEdgeInsetsMake(-35, 0, -35, 0);
    }
    
    // MARK: - Func Orther
    func checkDeviceAndConfig() {
        if UDMHelpers.myModel() == PhoneModel.iPhone5 {
            heightRow = 120
        }
        if UDMHelpers.myModel() == PhoneModel.iPhone6 {
            heightRow = 120
        }
    }
}
// MARK: - TableView
extension WishListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return courses.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return heightRow
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(indexPath: indexPath) as CourseCell
        let course = courses[indexPath.row]
        cell.title.text = course.title
        cell.teacherName.text = course.author
        cell.moneyTextField.text = "$" +  course.newPrice
        cell.moneyNew.text = "$" + course.oldPrice
        let url = self.courses[indexPath.row].thumbnail
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            let img = UDMHelpers.getImageByURL(with: url)
            dispatch_async(dispatch_get_main_queue(), {
                cell.courseImage.image = img
            })
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let vc = CourseDetailViewController.initFromNib() as! CourseDetailViewController
        vc.course = courses[indexPath.row]
        var courseArrSmall = [Course]()
        for (index, course) in courses.enumerate() {
            if index > 5 {
                break
            }
            courseArrSmall.append(course)
        }
        vc.courses = courseArrSmall
        self.navigationController?.pushViewController(vc, animated: true)
    }
}