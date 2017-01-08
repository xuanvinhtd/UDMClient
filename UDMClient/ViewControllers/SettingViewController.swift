//
//  SettingViewController.swift
//  UDMClient
//
//  Created by OSXVN on 12/28/16.
//  Copyright © 2016 XUANVINHTD. All rights reserved.
//

import UIKit

final class SettingViewController: UITableViewController {
    // MARK: - Initialzation
    
    override func configItems() {
        self.navigationItem.title = "Settings"
    }
    
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configItems()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0 && indexPath.row == 2 {
            let vc = SignInViewController.initFromNib()
            let navigationBarSignIn = UINavigationController(rootViewController: vc)
            self.presentViewController(navigationBarSignIn, animated: true, completion: nil)
            UserManager.share.isLogInSuccess = false
            self.tabBarController?.selectedIndex = 0
        }
    }
    
}
