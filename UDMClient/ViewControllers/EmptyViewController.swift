//
//  EmptyViewController.swift
//  UDMClient
//
//  Created by OSXVN on 1/4/17.
//  Copyright © 2017 XUANVINHTD. All rights reserved.
//

class EmptyViewController: UIViewController {
    
    // MARK: - Properties
    private var handlerNotificationConnetInternet: AnyObject?
    
    // MARK: Initialzation

    
    // MARK: Notification
    func registerNotification() {
        handlerNotificationConnetInternet = NSNotificationCenter.defaultCenter().addObserverForName(UDMConfig.Notification.ConnectedInternet, object: nil, queue: nil, usingBlock: { notification in
            log.info("Reveiced notification name: \(notification.name)")
            self.dismissViewControllerAnimated(true, completion: nil)
        })
    }
    
    override func deregisterNotification() {
        if let _ = handlerNotificationConnetInternet {
            NSNotificationCenter.defaultCenter().removeObserver(handlerNotificationConnetInternet!)
        }
    }
    
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        registerNotification()
    }
    
    deinit {
        deregisterNotification()
    }
}
