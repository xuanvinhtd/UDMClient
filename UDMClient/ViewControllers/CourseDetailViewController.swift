//
//  CourseDetailViewController.swift
//  UDMClient
//
//  Created by OSXVN on 12/28/16.
//  Copyright © 2016 XUANVINHTD. All rights reserved.
//

import UIKit

final class CourseDetailViewController: UIViewController {
    // MARK: - Properties
    @IBOutlet weak var tableView: UITableView!
    
    var courses = [Course]()
    var course = Course()
    var inforDetail:[String: AnyObject] = [:]
    var isRemoveWishList = false
    var reviews = [Review]()
    
    var isBuy = false
    var isWishList = false
    var isReloadReview = false
    
    //Section Index
    enum SectionIndex: Int {
        case Video = 0
        case Description = 1
        case Curruculum = 2
        case Reviews = 3
        case Instructor = 4
        case courses = 5
    }
    private var handlerNotificationPlayVideo: AnyObject?
    
    // MARK: - Initialzation
    override func configItems() {
        tableView.registerReusableCell(CourseVideoCell.self)
        tableView.registerReusableCell(CourseDescriptionCell.self)
        tableView.registerReusableCell(CourseCurriculumCell.self)
        tableView.registerReusableCell(CourseReviewsCell.self)
        tableView.registerReusableCell(CourseInstructorCell.self)
        tableView.registerReusableCell(CourseCell.self)
        self.automaticallyAdjustsScrollViewInsets = false
        tableView.contentInset = UIEdgeInsetsZero;
        tableView.estimatedRowHeight = 44.0
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    override func initData() {
        // Get detail courses
        UDMServer.share.getCoursesDetail(withCourseID: course.id) { (data, msg, success) in
            if success {
                if let _data = data.first {
                    self.inforDetail = _data
                }
                
                for value in data {
                    if let _isBuy = value["buy"] as? Int {
                        if _isBuy == 1 {
                            self.isBuy = true
                        }
                    }
                    if let _isWishList = value["wishList"] as? Int {
                        if _isWishList == 1 {
                            self.isWishList = true
                        }
                    }
                    
                    self.inforDetail = value
                }
                
                dispatch_async(dispatch_get_main_queue(), {
                    self.tableView.beginUpdates()
                    let section = NSIndexSet(index: SectionIndex.Video.rawValue)
                    self.tableView.reloadSections(section, withRowAnimation: UITableViewRowAnimation.None)
                    let sectionCuriculum = NSIndexSet(index: SectionIndex.Curruculum.rawValue)
                    self.tableView.reloadSections(sectionCuriculum, withRowAnimation: UITableViewRowAnimation.None)
                    self.tableView.endUpdates()
                })

            } else {
                log.error("Cannot get detail courses: \(msg)")
            }
        }
    }
    
    // MARK: - Notification
    struct Notification {
        static let PlayVideo = "NotificationPlayVideo"
    }
    
    override func registerNotitication() {
        handlerNotificationPlayVideo = NSNotificationCenter.defaultCenter().addObserverForName(CourseDetailViewController.Notification.PlayVideo, object: nil, queue: nil, usingBlock: { notification in
            
            log.info("Notification info: \(notification.name)")
            
            guard let user = notification.userInfo else {
                log.error("Not found userInfo")
                return
            }
            let url = user["URLVIDEO"] as! String
//            let videoViewController = VideoViewController.createInstance() as! VideoViewController
//            videoViewController.strUrl = url
//            self.navigationController?.pushViewController(videoViewController, animated: true)
        })
    }
    
    override func deregisterNotification() {
        if let _ = handlerNotificationPlayVideo {
            NSNotificationCenter.defaultCenter().removeObserver(handlerNotificationPlayVideo!)
        }
    }
    
    // MARK: - Life view cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configItems()
        initData()
        registerNotitication()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidAppear(animated: Bool) {
        if self.isReloadReview {
            getListReview()
        }
    }
    
    deinit {
        deregisterNotification()
    }
    
    // MARK: - Get Data from server
    
    func getListReview() {
        UDMServer.share.getReviews(withCourseId: course.id) { (data, msg, success) in
            if success {
                self.reviews = Review.createReview(withInfos: data)
                dispatch_async(dispatch_get_main_queue(), {
                    let path = NSIndexPath(forRow: 0, inSection: SectionIndex.Reviews.rawValue)
                    self.tableView.beginUpdates()
                    self.tableView.reloadRowsAtIndexPaths([path], withRowAnimation: UITableViewRowAnimation.None)
                    self.tableView.endUpdates()
                    self.isReloadReview = false
                })
            } else {
                log.error("Cannot get reviews: \(msg)")
            }
        }
    }
}
// MARK: - Table view
extension CourseDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return (SectionIndex.courses.rawValue + 1)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == SectionIndex.courses.rawValue {
            return courses.count
        }
        return 1
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == SectionIndex.courses.rawValue {
            return 20.0
        }
        return 1.0
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == SectionIndex.courses.rawValue {
            return "Course tha other students viewed"
        }
        return ""
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch indexPath.section {
        case SectionIndex.Video.rawValue:
            let cell = tableView.dequeueReusableCell(indexPath: indexPath) as CourseVideoCell
            cell.selectionStyle = .None
            cell.ratingControl.didFinishTouchingCosmos = { rate in
                dispatch_async(dispatch_get_main_queue(), {
                    if !self.isBuy {
                        return
                    }
                    self.isReloadReview = true
                    let vc = RatingViewController.initFromNib() as! RatingViewController
                    vc.idCourses = self.course.id
                    let navigationReview = UINavigationController(rootViewController: vc)
                    self.presentViewController(navigationReview, animated: true, completion: nil)
                })
            }
            if isRemoveWishList {
                cell.addButton.addTarget(self, action: #selector(CourseDetailViewController.actionButtonRemoveWishList(_:)), forControlEvents: .TouchUpInside)
                cell.addButton.selected = true
            } else {
                cell.addButton.addTarget(self, action: #selector(CourseDetailViewController.actionButtonAddWishList(_:)), forControlEvents: .TouchUpInside)
                cell.addButton.setTitle("", forState: UIControlState.Normal)
            }
            cell.buttonBuy.addTarget(self, action: #selector(CourseDetailViewController.actionButtonBuy(_:)), forControlEvents: .TouchUpInside)
            cell.buttonBuy.selected = false
            
            if isBuy {
                cell.buttonBuy.hidden = true
                cell.addButton.hidden = true
                cell.ratingControl.userInteractionEnabled = true
            } else {
                cell.ratingControl.userInteractionEnabled = false
            }
            
            if isWishList && !isRemoveWishList {
                cell.addButton.selected = true
                cell.addButton.addTarget(self, action: #selector(CourseDetailViewController.actionButtonRemoveWishList(_:)), forControlEvents: .TouchUpInside)
            }
            cell.courseName.text = course.title
            cell.costSourse.text = "$" + course.newPrice
            cell.labelPesonName.text = course.author
            let url = course.thumbnail
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
                let img = UDMHelpers.getImageByURL(with: url)
                dispatch_async(dispatch_get_main_queue(), {
                    cell.courseVideo.image = img
                })
            }
            return cell
        case SectionIndex.Description.rawValue:
            let cell = tableView.dequeueReusableCell(indexPath: indexPath) as CourseDescriptionCell
            cell.buttonSeeAll.tag = 101
            cell.selectionStyle = .None
            cell.buttonSeeAll.addTarget(self, action: #selector(CourseDetailViewController.actionButtonSeeAll(_:)), forControlEvents: .TouchUpInside)
            cell.textViewContent.text = inforDetail["description"] as? String
            return cell
        case SectionIndex.Curruculum.rawValue:
            let cell = tableView.dequeueReusableCell(indexPath: indexPath) as CourseCurriculumCell
            cell.selectionStyle = .None
            cell.buttonSeeAll.tag = 102
            cell.buttonSeeAll.addTarget(self, action: #selector(CourseDetailViewController.actionButtonSeeAll(_:)), forControlEvents: .TouchUpInside)
            
            if !isBuy {
                cell.userInteractionEnabled = false
                cell.buttonSeeAll.hidden = true
            } else {
                cell.userInteractionEnabled = true
                cell.buttonSeeAll.hidden = false
            }
            cell.initData()
            return cell
        case SectionIndex.Reviews.rawValue:
            let cell = tableView.dequeueReusableCell(indexPath: indexPath) as CourseReviewsCell
            cell.selectionStyle = .None
            cell.buttonSeeAll.hidden = true
            cell.buttonSeeAll.tag = 103
            cell.buttonSeeAll.addTarget(self, action: #selector(CourseDetailViewController.actionButtonSeeAll(_:)), forControlEvents: .TouchUpInside)
            cell.initData(withID: course.id)
            return cell
        case SectionIndex.Instructor.rawValue:
            let cell = tableView.dequeueReusableCell(indexPath: indexPath) as CourseInstructorCell
            cell.selectionStyle = .None
            cell.initData(withTeacherID: course.authorID)
            cell.buttonSeeAll.tag = 104
            cell.buttonSeeAll.addTarget(self, action: #selector(CourseDetailViewController.actionButtonSeeAll(_:)), forControlEvents: .TouchUpInside)
            return cell
        case SectionIndex.courses.rawValue:
            let cell = tableView.dequeueReusableCell(indexPath: indexPath) as CourseCell
            let course = courses[indexPath.row]
            cell.title.text = course.title
            cell.teacherName.text = course.author
            cell.moneyTextField.text = course.oldPrice
            cell.moneyNew.text = course.newPrice
            cell.ratingControl.rating = Double(course.review) ?? 3.5
            let url = course.thumbnail
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
                let img = UDMHelpers.getImageByURL(with: url)
                dispatch_async(dispatch_get_main_queue(), {
                    cell.courseImage.image = img
                })
            }
            return cell
        default:
            log.error("Cannot create cell table at section: \(indexPath.section)")
            break
        }
        
        var cellTable = tableView.dequeueReusableCellWithIdentifier("defaulCell")
        if cellTable == nil {
            cellTable = UITableViewCell.init(style: .Default, reuseIdentifier: "defaulCell")
        }
        cellTable!.textLabel?.text = String(indexPath.section)
        
        return cellTable!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section < SectionIndex.courses.rawValue {
            return
        }
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
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == SectionIndex.courses.rawValue {
            animateCell(cell)
        }
    }
    
    // MARK: Animation TableViewCell
    func animateCell(cell: UITableViewCell) {
        let animation = CABasicAnimation(keyPath: "opacity")
        animation.fromValue = 0.0
        animation.toValue = 1
        animation.duration = 0.5
        cell.layer.addAnimation(animation, forKey: animation.keyPath)
    }
    
    // MARK: - Event handling
    func actionButtonBuy(sender: UIButton) {
        let userMoney = Int(UserManager.share.info.money)
        let price = Int(course.newPrice)
        
        if userMoney >= price {
            UDMServer.share.buyCourses(withCoures: course.id, completion: { (data, msg, success) in
                if success {
                    UDMAlert.alert(title: "Buy Success", message: "You bought a course.", dismissTitle: "OK", inViewController: self, withDismissAction: nil)
                    dispatch_async(dispatch_get_main_queue(), {
                        sender.selected = true
                        self.isBuy = true
                        let sectionVideo = NSIndexSet(index: SectionIndex.Video.rawValue)
                        self.tableView.reloadSections(sectionVideo, withRowAnimation: UITableViewRowAnimation.None)
                        let sectionCurriculum = NSIndexSet(index: SectionIndex.Curruculum.rawValue)
                        self.tableView.reloadSections(sectionCurriculum, withRowAnimation: UITableViewRowAnimation.None)
                    })
                    log.info("Buy courses success!!!!")
                } else {
                    UDMAlert.alert(title: "Buy Fail", message: msg, dismissTitle: "OK", inViewController: self, withDismissAction: nil)
                    dispatch_async(dispatch_get_main_queue(), {
                        sender.selected = false
                    })
                }
            })
    }
    }
    
    func actionButtonAddWishList(sender: UIButton) {
        if sender.selected {
            actionButtonRemoveWishList(sender)
        } else {
            UDMServer.share.addWishList(withCoures: course.id, completion: { (data, msg, success) in
                if success {
                    UDMAlert.alert(title: "Add Success", message: "You have added the course to wishlist.", dismissTitle: "OK", inViewController: self, withDismissAction: nil)
                    dispatch_async(dispatch_get_main_queue(), {
                        sender.selected = true
                    })
                    log.info("Add wishlist success!!!!")
                } else {
                    UDMAlert.alert(title: "Add Fail", message: msg, dismissTitle: "OK", inViewController: self, withDismissAction: nil)
                    dispatch_async(dispatch_get_main_queue(), {
                        sender.selected = false
                    })
                }
            })
        }
    }
    
    func actionButtonRemoveWishList(sender: UIButton) {
        UDMServer.share.removeWishList(withCoures: course.id) { (data, msg, success) in
            if success {
                UDMAlert.alert(title: "Remove Success", message: "You removed a course in wishlist.", dismissTitle: "OK", inViewController: self, withDismissAction: nil)
                dispatch_async(dispatch_get_main_queue(), {
                    sender.selected = false
                })
                log.info("Remove wishlist success!!!!")
            } else {
                UDMAlert.alert(title: "Remove Fail", message: msg, dismissTitle: "OK", inViewController: self, withDismissAction: nil)
                
                dispatch_async(dispatch_get_main_queue(), {
                    sender.selected = true
                })
            }
        }
    }
    
    func actionButtonSeeAll(sender: UIButton) {
        switch sender.tag {
        case 101:
            log.info("show page See all Description!")
            let vc = CoursesInstructorViewController.initFromNib()
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case 102:
            log.info("show page See all Curriculum!")
            let vc = CurriculumsViewController.initFromNib()
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case 103:
            log.info("show page See all Review!")
            let vc = ReviewsViewController.initFromNib() as! ReviewsViewController
            vc.idCourses = course.id
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case 104:
            log.info("show page See all Instructor!")
            let vc = TeacherInfoViewController.initFromNib() as! TeacherInfoViewController
            vc.initData(withID: course.authorID)
            self.navigationController?.pushViewController(vc, animated: true)
            break
        default:
            log.error("Click button See all Not Found action!")
            break
        }
    }
}
