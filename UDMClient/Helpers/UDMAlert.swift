//
//  UDMAlert.swift
//  UDMTeacher
//
//  Created by OSXVN on 12/24/16.
//  Copyright © 2016 XUANVINHTD. All rights reserved.
//

import UIKit

final class UDMAlert {
    
    class func alert(title title: String, message: String, dismissTitle: String, inViewController viewController: UIViewController?, withDismissAction dismissAction: (() -> Void)?) {
        
        dispatch_async(dispatch_get_main_queue()) {
            
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
            
            let action: UIAlertAction = UIAlertAction(title: dismissTitle, style: .Default, handler: { action in
                guard let dismissAction = dismissAction else {
                    log.error("Not found action of Alert!")
                    return
                }
                dismissAction()
            })
            
            alertController.addAction(action)
            viewController?.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    class func alertSorry(message message: String?, inViewController viewController: UIViewController?, withDismissAction dismissAction: () -> Void) {
        
        alert(title: NSLocalizedString("Sorry", comment: ""), message: message!, dismissTitle: NSLocalizedString("OK", comment: ""), inViewController: viewController, withDismissAction: dismissAction)
    }
    
    class func alertSorry(message message: String?, inViewController viewController: UIViewController?) {
        
        alert(title: NSLocalizedString("Sorry", comment: ""), message: message!, dismissTitle: NSLocalizedString("OK", comment: ""), inViewController: viewController, withDismissAction: nil)
    }
    
    class func textInput(title title: String, placeholder: String?, oldText: String?, dismissTitle: String, inViewController viewController: UIViewController, withFinishedAction finishedAction: ((text: String) -> Void)?) {
        
        dispatch_async(dispatch_get_main_queue()) {
            
            let alertController = UIAlertController(title: title, message: nil, preferredStyle: .Alert)
            
            alertController.addTextFieldWithConfigurationHandler({ textField in
                textField.placeholder = placeholder
                textField.text = oldText
            })
            
            let action: UIAlertAction = UIAlertAction(title: title, style: .Default, handler: { action in
                guard let finishedAction = finishedAction else {
                    log.error("Not found action of Alert Text Input")
                    return
                }
                
                guard let textField = alertController.textFields?.first, text = textField.text else {
                    log.error("Not found text input in Alert text input")
                    return
                }
                
                finishedAction(text: text)
            })
            
            alertController.addAction(action)
            
            alertController.view.setNeedsLayout()
            viewController.presentViewController(alertController, animated: true, completion: nil)
        }
    }
}
