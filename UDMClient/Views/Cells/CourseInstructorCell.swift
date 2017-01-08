//
//  CourseInstructorCell.swift
//  UDMClient
//
//  Created by OSXVN on 1/8/17.
//  Copyright © 2017 XUANVINHTD. All rights reserved.
//
import UIKit

final class CourseInstructorCell: UITableViewCell, Reusable {
    // MARK: - Properties
    @IBOutlet weak var titleInstructor: UILabel!
    @IBOutlet weak var avataIntructor: UIImageView!
    @IBOutlet weak var nameIntructor: UILabel!
    @IBOutlet weak var textViewContent: UITextView!
    @IBOutlet weak var buttonSeeAll: UIButton!
    
    static var nib: UINib? {
        return UINib(nibName: String(CourseInstructorCell.self), bundle: nil)
    }
    
    // MARK: - Method
    override func awakeFromNib() {
        super.awakeFromNib()
        textViewContent.sizeToFit()
        textViewContent.scrollEnabled = false
    }
    
    private func initData(with t: Teacher) {
        nameIntructor.text = t.fullName
        textViewContent.text = t.descriptions
        avataIntructor.layer.cornerRadius = avataIntructor.frame.width / 2
        avataIntructor.clipsToBounds = true
        let url = t.avatar
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            let img = UDMHelpers.getImageByURL(with: url)
            dispatch_async(dispatch_get_main_queue(), {
                self.avataIntructor.image = img
            })
        }
    }

    func initData(withTeacherID id: String) {
        // Get Teacher Info
        UDMServer.share.getTeacherInfo(withTeacherID: id) { (data, msg, success) in
            if success {
                if let _data = data.first {
                    let teacher = Teacher(withInfo: _data)
                    self.initData(with: teacher)
                } else {
                    log.error("Data Teacher nil")
                }
            } else {
                log.error("Cannot get teacher info: \(msg)")
            }
        }
    }
}
