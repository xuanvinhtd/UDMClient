//
//  MainViewController.swift
//  UDMClient
//
//  Created by OSXVN on 12/28/16.
//  Copyright © 2016 XUANVINHTD. All rights reserved.
//

import UIKit

final class MainViewController: UIViewController {
    // MARK: - Properties
    private let heightHeader0:CGFloat = 100
    private let heightHeader = 30
    private var heightCoursesSection = 250
    private var widthCoursesSection = 60
    private var heightCategoriSection = 100
    private var widthCategoriSection = 10
    private let tabButton = 101
    
    private var widthCourseCollectionViewCell = 0
    private var widthCategoryCollectionViewCell = 0
    
    private var categories: [Category] = []
    private var courses: [Course] = []
    private var coursesSale = [Course]()
    
    private var notifyDisConnetInternet: AnyObject?
    private var notifyGetDataCourseAndCategory: AnyObject?
    
    var numberSecction = 3
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Initialzation
    override func configItems() {
        self.tableView.tableFooterView = UIView()
        self.navigationItem.title = "Featured"
    }
    
    override func initData() {
        if !UserManager.share.isLogInSuccess {
            return
        }
        checkDeviceAndConfig()
        UDMServer.share.getCategories { (data, msg, success) in
            if success {
                self.categories = Category.createCategories(withInfos: data)
                dispatch_async(dispatch_get_main_queue(), {
                    let section = NSIndexSet(index: 1) // 2 is index section
                    self.tableView.reloadSections(section, withRowAnimation: UITableViewRowAnimation.None)
                })
            } else {
                log.error("Cannot get category: \(msg)")
            }
        }
        
        UDMServer.share.getCourses(withCategoryID: "1", limit: "10", offset: "10") { (data, msg, success) in
            if success {
                self.courses = Course.createCourses(withInfos: data)
                dispatch_async(dispatch_get_main_queue(), {
                    let section = NSIndexSet(index: 2) // 2 is index section
                    self.tableView.reloadSections(section, withRowAnimation: UITableViewRowAnimation.None)
                })
            } else {
                log.error("Cannot get courses: \(msg)")
            }
        }
        
        UDMServer.share.getCoursesSale(withCategoryID: nil, limit: "10", offset: "10") { (data, msg, success) in
            if success {
                self.coursesSale = Course.createCourses(withInfos: data)
                dispatch_async(dispatch_get_main_queue(), {
                    let section = NSIndexSet(index: 0) // 0 is index section
                    self.tableView.reloadSections(section, withRowAnimation: UITableViewRowAnimation.None)
                })
            } else {
                log.error("Cannot get Courses sale: \(msg)")
            }
        }
    }
    
    // MARK: - Notification
    override func registerNotitication() {
        notifyDisConnetInternet = NSNotificationCenter.defaultCenter().addObserverForName(UDMConfig.Notification.DisconnetedInternet, object: nil, queue: nil, usingBlock: { notification in
            log.info("Reveiced notification name: \(notification.name)")
            let vc = EmptyViewController.initFromNib()
            self.presentViewController(vc, animated: true, completion: nil)
        })
        
        notifyGetDataCourseAndCategory = NSNotificationCenter.defaultCenter().addObserverForName(UDMConfig.Notification.GetDataCourseAndCategory, object: nil, queue: nil, usingBlock: { notification in
            log.info("Reveiced notification name: \(notification.name)")
            self.initData()
        })
    }
    
    override func deregisterNotification() {
        if let _ = notifyDisConnetInternet {
            NSNotificationCenter.defaultCenter().removeObserver(notifyDisConnetInternet!)
        }
        if let _ = notifyGetDataCourseAndCategory {
            NSNotificationCenter.defaultCenter().removeObserver(notifyGetDataCourseAndCategory!)
        }
    }
    
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configItems()
        initData()
        registerNotitication()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        if UserManager.share.isLogInSuccess {
            return
        }
        // Init screen Sign
        let login = SignInViewController.initFromNib()
        let navigationBarSignIn = UINavigationController(rootViewController: login)
        self.presentViewController(navigationBarSignIn, animated: true, completion: nil)
    }
    
    deinit {
        deregisterNotification()
    }
    
    // MARK: - Func Orther
    func checkDeviceAndConfig() {
        if UDMHelpers.myModel() == PhoneModel.iPhone5 {
            heightCoursesSection = 250
            widthCoursesSection = 60
            heightCategoriSection = 100
            widthCategoriSection = 10
        }
        if UDMHelpers.myModel() == PhoneModel.iPhone6 {
            heightCoursesSection = 250
            widthCoursesSection = 40
            heightCategoriSection = 100
            widthCategoriSection = 10
        }
    }
}
// MARK: - TableView
extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return numberSecction
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 || indexPath.section == 2 {
            return CGFloat(heightCoursesSection)
        }
        return CGFloat(heightCategoriSection)
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(heightHeader)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cellTable = tableView.dequeueReusableCellWithIdentifier(MainTableViewCell.reuseIdentifier) as? MainTableViewCell
        if cellTable == nil {
            self.tableView.registerClass(MainTableViewCell.self, forCellReuseIdentifier: MainTableViewCell.reuseIdentifier)
            cellTable = tableView.dequeueReusableCellWithIdentifier(MainTableViewCell.reuseIdentifier) as? MainTableViewCell
            configTableViewCellCollectionView(with:cellTable!, at: indexPath)
        } else {
            configTableViewCellCollectionView(with:cellTable!, at: indexPath)
        }
        return cellTable!
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        guard let tableViewCell = cell as? MainTableViewCell else {
            log.error("MainTableViewCell cannot be nil at MainViewController")
            fatalError()
        }
        tableViewCell.setCollectionViewDataSourceDelegate(self, forRow: indexPath.section)
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var viewHeader = tableView.dequeueReusableHeaderFooterViewWithIdentifier("defaulCell")
        if viewHeader == nil {
            viewHeader = UITableViewHeaderFooterView(reuseIdentifier: "defaulCell")
            //FIX
            let rectLabel = CGRect(x: 10, y: 15, width: 200, height: 20)
            let titleHeader: UILabel = UILabel(frame: rectLabel)
            titleHeader.font = UIFont(name: (titleHeader.font?.fontName)!, size: 14)
            titleHeader.textColor = UIColor.grayColor()
            titleHeader.tag = 102
            viewHeader!.contentView.insertSubview(titleHeader, atIndex: 1)
            
            configTableViewCellNormal(with: viewHeader!, at: section)
        } else {
            configTableViewCellNormal(with: viewHeader!, at: section)
        }
        return viewHeader
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        log.info("Row selected \(indexPath)")
    }
    
    // MARK: - Config cell
    func configTableViewCellCollectionView(with cellConfig:MainTableViewCell ,at index: NSIndexPath) {
        guard let layout = cellConfig.collecttionView.collectionViewLayout as? UICollectionViewFlowLayout else {
            log.info("Layout cellConfig cannot be nil at MainViewController")
            fatalError()
        }
        
        var frameUICollection: CGRect!
        var sizeItemCollection: CGSize!
        
        if courses.count > 0 {
            cellConfig.titleActivity.hidden = true
            cellConfig.activityIndication.stopAnimating()
        }
        if coursesSale.count > 0 {
            cellConfig.titleActivity.hidden = true
            cellConfig.activityIndication.stopAnimating()
        }
        if categories.count > 0 {
            cellConfig.titleActivity.hidden = true
            cellConfig.activityIndication.stopAnimating()
        }
        
        switch index.section {
        case 0,2:
            widthCourseCollectionViewCell = Int(UDMHelpers.getScreenRect().width / 3) + widthCoursesSection
            frameUICollection = CGRect(x: 0, y: 0, width: Int(UDMHelpers.getScreenRect().width), height: heightCoursesSection + 20)
            sizeItemCollection = CGSize(width: widthCourseCollectionViewCell, height: heightCoursesSection)
            cellConfig.heightCollectionView = heightCoursesSection + 10
            break
        case 1:
            widthCategoryCollectionViewCell = Int(UDMHelpers.getScreenRect().width / 3) + widthCategoriSection
            frameUICollection = CGRect(x: 0, y: 0, width: Int(UDMHelpers.getScreenRect().width), height: heightCategoriSection + 20)
            sizeItemCollection = CGSize(width: widthCategoryCollectionViewCell, height: heightCategoriSection)
            cellConfig.heightCollectionView = heightCategoriSection + 50
            break
        default:
            break
        }
        
        cellConfig.configActivityIndication()
        cellConfig.collecttionView.frame = frameUICollection
        layout.itemSize = sizeItemCollection
    }
    
    func configTableViewCellNormal(with cellConfig: UITableViewHeaderFooterView, at index: Int) {
        guard let titleHeader = cellConfig.contentView.viewWithTag(102) as? UILabel else {
            log.error("CellConfig not found titleHeader at MainViewController")
            fatalError()
        }
        switch index {
        case 0:
            titleHeader.text = "On Sale"
            break
        case 1:
            titleHeader.text = "Browse Categories"
            break
        case 2:
            titleHeader.text = "Other Students Are Viewing"
            break
        default:
            break
        }
    }
    // MARK: - action button
    func pressedSeeAll(OfRow row: Int) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        let vc = CoursesViewController.initFromNib() as! CoursesViewController
        if row == 0 {
            vc.courses = self.coursesSale
        } else {
            vc.courses = self.courses
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
// MARK: - CollectionView
extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 0 {
            return courses.count == 0 ? 0 : courses.count + 1
        } else if collectionView.tag == 1 {
            return categories.count
        } else {
            return courses.count == 0 ? 0 : courses.count + 1
        }
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        if collectionView.tag != 1{
            if indexPath.item == courses.count {
                return CGSize(width: widthCourseCollectionViewCell - 40, height: heightCoursesSection)
            } else {
                return CGSize(width: widthCourseCollectionViewCell, height: heightCoursesSection)
            }
        } else {
            return CGSize(width: widthCategoryCollectionViewCell, height: heightCategoriSection)
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        if collectionView.tag == 0 {
            let cell = collectionView.dequeueReusableCell(indexPath: indexPath) as CoursesCollectionViewCell
            if coursesSale.count == indexPath.item {
                cell.isSeeAll = true
            } else {
                cell.isSeeAll = false
                cell.course = self.coursesSale[indexPath.item]
            }
            return cell
        } else if collectionView.tag == 1 {
            let cell = collectionView.dequeueReusableCell(indexPath: indexPath) as CategoriesCollectionViewCell
            cell.categorie = categories[indexPath.row]
            cell.rect = CGRect(x: 0, y: 0, width: widthCategoryCollectionViewCell, height: heightCategoriSection)
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(indexPath: indexPath) as CoursesCollectionViewCell
            if courses.count == indexPath.item {
                cell.isSeeAll = true
            } else {
                cell.isSeeAll = false
                cell.course = self.courses[indexPath.item]
            }
            return cell
        }
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        log.info("Click collectionView at row \(collectionView.tag) and index path \(indexPath)")
        if collectionView.tag == 0 { // Courses
            if coursesSale.count == indexPath.row {
                pressedSeeAll(OfRow: 0)
            } else {
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
        if collectionView.tag == 1 { // Categories
            let vc = CategoryViewController.initFromNib() as! CategoryViewController
            vc.categories = self.categories
            vc.courses = self.courses
            vc.title = self.categories[indexPath.row].title
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        if collectionView.tag == 2 { // Courses
            if courses.count == indexPath.row {
                pressedSeeAll(OfRow: 2)
            } else {
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
    }
    
    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        animateCell(cell)
    }
    
    // MARK: Animation CollectionViewCell
    func animateCell(cell: UICollectionViewCell) {
        let animation = CABasicAnimation(keyPath: "opacity")
        animation.fromValue = 0.0
        animation.toValue = 1
        animation.duration = 0.5
        cell.layer.addAnimation(animation, forKey: animation.keyPath)
    }
}
