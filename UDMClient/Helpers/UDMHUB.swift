//
//  UDMHUB.swift
//  UDMTeacher
//
//  Created by OSXVN on 12/25/16.
//  Copyright © 2016 XUANVINHTD. All rights reserved.
//

import Foundation
import UIKit

final class UDMHUD: NSObject {
    
    static let sharedInstance = UDMHUD()
    
    var isShowing = false
    var dismissTimer: NSTimer?
    
    private override init() {
        super.init()
    }
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.5)
        return view
    }()
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
        return view
    }()
    
    class func showActivityIndicator() {
        showActivityIndicatorWhileBlockingUI(true)
    }
    
    class func showActivityIndicatorWhileBlockingUI(blockingUI: Bool) {
        
        if sharedInstance.isShowing {
            return
        }
        
        dispatch_async(dispatch_get_main_queue()) {
            if
                let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate,
                let window = appDelegate.window {
                
                sharedInstance.isShowing = true
                
                sharedInstance.containerView.userInteractionEnabled = blockingUI
                
                sharedInstance.containerView.alpha = 0
                window.addSubview(sharedInstance.containerView)
                sharedInstance.containerView.frame = window.bounds
                
                UIView.animateWithDuration(0.1, delay: 0.0, options: UIViewAnimationOptions(rawValue: 0), animations: {
                    sharedInstance.containerView.alpha = 1
                    
                    }, completion: { _ in
                        
                        sharedInstance.containerView.addSubview(sharedInstance.activityIndicator)
                        sharedInstance.activityIndicator.center = sharedInstance.containerView.center
                        sharedInstance.activityIndicator.startAnimating()
                        
                        sharedInstance.activityIndicator.alpha = 0
                        sharedInstance.activityIndicator.transform = CGAffineTransformMakeScale(0.0001, 0.0001)
                        UIView.animateWithDuration(0.2, delay: 0.0, options: UIViewAnimationOptions(rawValue: 0), animations: {
                            sharedInstance.activityIndicator.transform = CGAffineTransformMakeScale(1.0, 1.0)
                            sharedInstance.activityIndicator.alpha = 1
                            
                            }, completion: { _ in
                                sharedInstance.activityIndicator.transform = CGAffineTransformIdentity
                                
                                if let dismissTimer = sharedInstance.dismissTimer {
                                    dismissTimer.invalidate()
                                }
                                
                                sharedInstance.dismissTimer = NSTimer.scheduledTimerWithTimeInterval(UDMConfig.forcedHideActivityIndicatorTimeInterval, target: self, selector: #selector(UDMHUD.forcedHideActivityIndicator), userInfo: nil, repeats: false)
                        })
                })
            }
        }
    }
    
    class func forcedHideActivityIndicator() {
        hideActivityIndicator() {
            if
                let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate,
                let viewController = appDelegate.window?.rootViewController {
                UDMAlert.alertSorry(message: NSLocalizedString("Wait too long, the operation may not be completed.", comment: ""), inViewController: viewController)
            }
        }
    }
    
    class func hideActivityIndicator() {
        hideActivityIndicator() {
        }
    }
    
    class func hideActivityIndicator(completion: () -> Void) {
        
        dispatch_async(dispatch_get_main_queue()) {
            
            if sharedInstance.isShowing {
                
                sharedInstance.activityIndicator.transform = CGAffineTransformIdentity
                
                UIView.animateWithDuration(0.2, delay: 0.0, options: UIViewAnimationOptions(rawValue: 0), animations: {
                    sharedInstance.activityIndicator.transform = CGAffineTransformMakeScale(0.0001, 0.0001)
                    sharedInstance.activityIndicator.alpha = 0
                    
                    }, completion: { _ in
                        sharedInstance.activityIndicator.removeFromSuperview()
                        
                        UIView.animateWithDuration(0.1, delay: 0.0, options: UIViewAnimationOptions(rawValue: 0), animations: {
                            sharedInstance.containerView.alpha = 0
                            
                            }, completion: { _ in
                                sharedInstance.containerView.removeFromSuperview()
                                
                                completion()
                        })
                })
            }
            
            sharedInstance.isShowing = false
        }
    }
}