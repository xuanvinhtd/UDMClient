//
//  ViewController+UDM.swift
//  UDMTeacher
//
//  Created by OSXVN on 12/24/16.
//  Copyright © 2016 XUANVINHTD. All rights reserved.
//

import UIKit

extension UIViewController {
    
    class func initFromNib() -> UIViewController {
        let hasNib: Bool = NSBundle.mainBundle().pathForResource(self.namOfClass, ofType: "nib") != nil
        if hasNib {
            log.error("Not found name of view controller.")
            return UIViewController()
        }
        return UIStoryboard.init(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier(self.identifier)
    }
    func configItems() {}
    
    func initData() {}
    
    func registerNotitication() {}
    
    func deregisterNotification() {}
}
