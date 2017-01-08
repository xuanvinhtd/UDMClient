//
//  AccountSettingViewController.swift
//  UDMClient
//
//  Created by OSXVN on 12/28/16.
//  Copyright © 2016 XUANVINHTD. All rights reserved.
//

import UIKit

final class AccountSettingViewController: UIViewController {
    // MARK: - Properties
    private var arrSetting: [String: String?] = [:]
    var keysName: [String] = []
    var keysValue: [String] = []
    
    @IBOutlet weak var myAvata: UIImageView!
    @IBOutlet weak var settingTable: UITableView!
    @IBOutlet weak var levelLabel: UILabel!
    
    // MARK: - Initialzation
    override func configItems() {
        myAvata.layer.cornerRadius = myAvata.frame.width / 2
        myAvata.clipsToBounds = true
        // Add RightBarButtonItem
        let rightBarButton = UIBarButtonItem(barButtonSystemItem: .Edit, target: self, action: #selector(clickedBarButtonAction(_:)))
        self.navigationItem.rightBarButtonItem = rightBarButton
        settingTable.tableFooterView = UIView()
        log.info("Info account: \(UserManager.share.info)")
    }
    
    override func initData() {
        if UserManager.share.isLogInSuccess {
            arrSetting = UserManager.share.getInfos()
            let user = UserManager.share.info
            levelLabel.text = "Level: " + String(user.level)
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
                let img = UDMHelpers.getImageByURL(with: user.avatar)
                dispatch_async(dispatch_get_main_queue(), {
                    self.myAvata.image = img
                })
            }
        } else {
            self.myAvata.image = UIImage(named: "default_avatar")
        }
    }
    
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configItems()
        initData()
    }
    
    override func viewWillAppear(animated: Bool) {
        if animated {
            initData()
            settingTable.reloadData()
        }
    }
    
    // MARK: - Action RightBarButton
    func clickedBarButtonAction(sender: UIButton) {
//        if UDMUser.shareManager.isLoginSuccess {
//            let edidAccountSettingViewController = EdidAccountSettingViewController.createInstance()
//            self.navigationController?.pushViewController(edidAccountSettingViewController, animated: true)
//        }
    }
}
// MARK: - UITableView
extension AccountSettingViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrSetting.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cellProfile = tableView.dequeueReusableCellWithIdentifier("idProfileCell")
        if cellProfile == nil {
            cellProfile = UITableViewCell(style: .Default, reuseIdentifier: "idProfileCell")
        }
        guard let title = cellProfile?.contentView.viewWithTag(10) as? UILabel else {
            fatalError()
        }
        title.text = Array(arrSetting.keys)[indexPath.row]
        guard let value = cellProfile?.contentView.viewWithTag(11) as? UILabel else {
            fatalError()
        }
        value.text = Array(arrSetting.values)[indexPath.row]
        if title.text == "Sex" {
            value.text = Array(arrSetting.values)[indexPath.row] == "0" ? "Female" : "Male"
        }
        return cellProfile!
    }
}

