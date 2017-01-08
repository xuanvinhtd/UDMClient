//
//  TeacherInfoViewController.swift
//  UDMClient
//
//  Created by OSXVN on 1/8/17.
//  Copyright © 2017 XUANVINHTD. All rights reserved.
//

import UIKit

final class TeacherInfoViewController: UIViewController {
    // MARK: - Properties
    var teacher = Teacher()
    @IBOutlet weak var textViewContants: UITextView!
    @IBOutlet weak var avata: UIImageView!
    @IBOutlet weak var name: UILabel!
    
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "Instructor Info"
        avata.layer.cornerRadius = avata.frame.width / 2
        avata.clipsToBounds = true
        textViewContants.text = teacher.descriptions
        name.text = teacher.fullName
        let url = teacher.avatar
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            let img = UDMHelpers.getImageByURL(with: url)
            dispatch_async(dispatch_get_main_queue(), {
                self.avata.image = img
            })
        }
    }
    
    func initData(withID id: String) {
        // Get Teacher Info
        UDMServer.share.getTeacherInfo(withTeacherID: id) { (data, msg, success) in
            if success {
                if let _data = data.first {
                    self.teacher = Teacher(withInfo: _data)
                } else {
                    log.error("Not found teacher data with id: \(id)")
                }
                self.viewWillAppear(true)
            } else {
                log.error("Cannot get teacher data with : \(msg)")
            }
        }
    }
}

