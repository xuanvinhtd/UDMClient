//
//  CourseViewController.swift
//  UDMClient
//
//  Created by OSXVN on 12/28/16.
//  Copyright © 2016 XUANVINHTD. All rights reserved.
//

import UIKit

final class CoursesViewController: UIViewController {
    // MARK: - Properties
    @IBOutlet weak var tableView: UITableView!
    var courses: [Course] = []
    
    override func configItems() {
        tableView.registerReusableCell(CourseCell.self)
        tableView.estimatedRowHeight = 44.0
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configItems()
    }
}
// MARK: - UITableV
extension CoursesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return courses.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(indexPath: indexPath) as CourseCell
        cell.title.text = courses[indexPath.row].title
        cell.teacherName.text = courses[indexPath.row].author
        cell.moneyTextField.text = "$" +  courses[indexPath.row].newPrice
        cell.moneyNew.text = "$" + courses[indexPath.row].oldPrice
        cell.ratingControl.rating = Double(courses[indexPath.row].review) ?? 3.5
        let url = courses[indexPath.row].thumbnail
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            let img = UDMHelpers.getImageByURL(with: url)
            dispatch_async(dispatch_get_main_queue(), {
                cell.courseImage.image = img
            })
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        log.info("Clicked cell row: \(indexPath.row)")
        let vc =  CourseDetailViewController.initFromNib() as! CourseDetailViewController
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