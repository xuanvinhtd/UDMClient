//
//  CourseReviewsCell.swift
//  UDMClient
//
//  Created by OSXVN on 1/8/17.
//  Copyright © 2017 XUANVINHTD. All rights reserved.
//

import UIKit

final class CourseReviewsCell: UITableViewCell, Reusable {
    // MARK: - Properties
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var titleReview: UILabel!
    @IBOutlet weak var scoresReviews: UILabel!
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var buttonSeeAll: UIButton!
    var reviews = [Review]()
    
    static var nib: UINib? {
        return UINib(nibName: String(CourseReviewsCell.self), bundle: nil)
    }
    
    // MARK: - Initialzation
    override func awakeFromNib() {
        super.awakeFromNib()
        tableview.estimatedRowHeight = 44.0
        tableview.rowHeight = UITableViewAutomaticDimension
        tableview.dataSource = self
        tableview.delegate = self
        tableview.contentInset = UIEdgeInsetsZero
        tableview.registerReusableCell(ReviewsCell.self)
    }
    
    func initData(withID id: String) {
        self.activityIndicator.startAnimating()
        UDMServer.share.getReviews(withCourseId: id) { (data, msg, success) in
            if success {
                self.reviews = Review.createReview(withInfos: data)
                self.tableview.reloadData()
            } else {
                log.error("Cannot get review data: \(msg)")
            }
            dispatch_async(dispatch_get_main_queue(), {
                self.activityIndicator.stopAnimating()
            })
        }
    }
}
// MARK: - Table View
extension CourseReviewsCell : UITableViewDelegate, UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviews.count
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(indexPath: indexPath) as ReviewsCell
        cell.ratingControl.rating = reviews[indexPath.row].rating
        cell.dateReview.text = reviews[indexPath.row].dateRate
        cell.nameReviewer.text = reviews[indexPath.row].userName
        cell.textViewContents.text = reviews[indexPath.row].description
        cell.titleLabel.text = reviews[indexPath.row].title
        return cell
    }
    
}

