//
//  CoursesInstructorViewController.swift
//  UDMClient
//
//  Created by OSXVN on 12/28/16.
//  Copyright © 2016 XUANVINHTD. All rights reserved.
//

import UIKit

final class CoursesInstructorViewController: UIViewController {
    // MARK: - Properties
    @IBOutlet weak var textViewContants: UITextView!
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "Instructor Info"
    }
}
