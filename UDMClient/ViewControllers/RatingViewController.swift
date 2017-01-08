//
//  RatingViewController.swift
//  UDMClient
//
//  Created by OSXVN on 12/28/16.
//  Copyright © 2016 XUANVINHTD. All rights reserved.
//

import UIKit
import Cosmos

final class RatingViewController: UIViewController {
    // MARK: - Properties
    
    @IBOutlet weak var ratingControl: CosmosView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var commentTextView: UITextView!
    var placeholderLabel : UILabel!
    var idCourses = ""
    
    // MARK: - Initialzation
    override func configItems() {
        let sendButton = UIBarButtonItem(title: "Send", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(actionSend(_:)))
        self.navigationItem.rightBarButtonItem = sendButton
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(cancelSend(_:)))
        self.navigationItem.leftBarButtonItem = cancelButton
        
        commentTextView.delegate = self
        placeholderLabel = UILabel()
        placeholderLabel.text = "Enter review text here..."
        placeholderLabel.font = UIFont.systemFontOfSize(commentTextView.font!.pointSize)
        placeholderLabel.sizeToFit()
        commentTextView.addSubview(placeholderLabel)
        placeholderLabel.frame.origin = CGPointMake(5, commentTextView.font!.pointSize / 2)
        placeholderLabel.textColor = UIColor(white: 0, alpha: 0.2)
        placeholderLabel.hidden = !commentTextView.text.isEmpty
    }
    
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configItems()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "Write review"
    }
    
    func cancelSend(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func actionSend(sender: AnyObject) {
        if titleTextField.text == "" {
            UDMAlert.alert(title: "Title Empty", message: "Title is emplty. \nPlease input title", dismissTitle: "OK", inViewController: self, withDismissAction: nil)
            return
        }
        let data = UDMDictionaryBuilder.share.builderRating(withTitle: titleTextField.text, description: commentTextView.text, value: String(ratingControl.rating))
        UDMServer.share.ratingCourses(withData: data, courseID: idCourses) { (data, msg, success) in
            if success {
                log.info("Comment success!")
                self.dismissViewControllerAnimated(true, completion: nil)
            } else {
                UDMAlert.alert(title: "Cannot Write Review", message: msg, dismissTitle: "OK", inViewController: self, withDismissAction: nil)
            }
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidDisappear(animated)
    }
}

extension RatingViewController: UITextViewDelegate {
    func textViewDidChange(textView: UITextView) {
        placeholderLabel.hidden = !textView.text.isEmpty
    }
}