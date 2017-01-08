//
//  StreamsViewController.swift
//  UDMClient
//
//  Created by OSXVN on 12/28/16.
//  Copyright © 2016 XUANVINHTD. All rights reserved.
//

import UIKit

final class StreamsViewController: UIViewController {
    // MARKL - Properties
    var streams = [Stream]()
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Initialzation
    override func initData() {
        self.activityIndicator.startAnimating()
        UDMServer.share.getCoursesLive { (data, msg, success) in
            if success {
                self.streams = Stream.createStreams(withInfos: data)
                self.tableView.reloadData()
            } else {
                log.error("Cannot get courses live data: \(msg)")
            }
            self.activityIndicator.stopAnimating()
        }
    }
    
    override func configItems() {
        let rightSearchBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Search, target: self, action: #selector(StreamsViewController.actionSearchBarButtonItem))
        self.navigationItem.setRightBarButtonItems([rightSearchBarButtonItem], animated: true)
    }
    
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configItems()
        initData()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "Stream List"
        self.tableView.contentInset = UIEdgeInsetsMake(-35, 0, -35, 0)
        self.tableView.registerReusableCell(CoursesLiveCell.self)
    }
    
    // MARK: - Handling
    func actionSearchBarButtonItem(sender: UIButton) {
    }
}

// MARK: - Table view
extension StreamsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return streams.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(indexPath: indexPath) as CoursesLiveCell
        cell.titleLive.text = streams[indexPath.row].title
        cell.author.text = streams[indexPath.row].author
        cell.numberView.text = streams[indexPath.row].student + " views"
        cell.dateCreate.text = streams[indexPath.row].createdDate
        let url = streams[indexPath.row].thumbnail
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            let img = UDMHelpers.getImageByURL(with: url)
            dispatch_async(dispatch_get_main_queue(), {
                cell.avata.image = img
            })
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.activityIndicator.startAnimating()
        UDMServer.share.getCoursesDetail(withCourseID: streams[indexPath.row].id) { (data, msg, success) in
            if success {
                if self.streams[indexPath.row].active == "0" {
                    UDMAlert.alert(title: "Stream", message: "Room not live", dismissTitle: "Cancel", inViewController: self, withDismissAction: nil)
                    return
                } else {
//                    let createCourse = EditCourseViewController.createInstance() as! EditCourseViewController
//                    createCourse.isEdit = true
//                    createCourse.courseID = idCouses
//                    createCourse.idRoom = Cdata[0]["liveName"] as? String ?? "DefaultRoomName"
//                    self.navigationController?.pushViewController(createCourse, animated: true)
                }
            } else {
                log.error("Cannot get Courses Detail: \(msg)")
            }
            self.activityIndicator.stopAnimating()
        }
    }
}