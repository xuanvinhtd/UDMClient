//
//  CoursesLiveCell.swift
//  UDMClient
//
//  Created by OSXVN on 1/8/17.
//  Copyright © 2017 XUANVINHTD. All rights reserved.
//

final class CoursesLiveCell: UITableViewCell, Reusable {
    // MARK: - Properties
    @IBOutlet weak var avata: UIImageView!
    @IBOutlet weak var titleLive: UILabel!
    @IBOutlet weak var author: UILabel!
    @IBOutlet weak var dateCreate: UILabel!
    @IBOutlet weak var numberView: UILabel!
    
    static var nib: UINib? {
        return UINib(nibName: String(CoursesLiveCell.self), bundle: nil)
    }
    
    // MARK: - Initialzation
    override func awakeFromNib() {
        super.awakeFromNib()
        numberView.textColor = UDMHelpers.textTheme()
    }
}
