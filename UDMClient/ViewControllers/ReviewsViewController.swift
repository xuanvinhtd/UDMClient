//
//  ReviewsViewController.swift
//  UDMClient
//
//  Created by OSXVN on 12/28/16.
//  Copyright © 2016 XUANVINHTD. All rights reserved.
//

import UIKit

final class ReviewsViewController: UIViewController {
    // MARK: - Properties
    @IBOutlet weak var tableView: UITableView!
    var reviews = [Review]()
    var idCourses = ""
    // MARK: - Life view cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 44.0
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.contentInset = UIEdgeInsetsZero
        tableView.tableFooterView = UIView()
        initData()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "Review List"
    }
    
    override func initData() {
        UDMServer.share.getReviews(withCourseId: idCourses) { (data, msg, success) in
            if success {
                self.reviews = Review.createReview(withInfos: data)
                dispatch_async(dispatch_get_main_queue(), {
                    self.tableView.reloadData()
                })
            } else {
                log.error("Cannot get reviews data: \(msg)")
            }
        }
    }
}

// MARK: - Table View
extension ReviewsViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviews.count
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let rv = reviews[indexPath.row]
        let cell = tableView.dequeueReusableCell(indexPath: indexPath) as ReviewsCell
        cell.ratingControl.rating = rv.rating
        cell.dateReview.text = rv.dateRate
        cell.nameReviewer.text = rv.userName
        cell.textViewContents.text = rv.description
        cell.titleLabel.text = rv.title
        return cell
    }
}

