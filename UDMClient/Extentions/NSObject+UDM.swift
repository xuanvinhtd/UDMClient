//
//  NSObject+UDM.swift
//  UDMTeacher
//
//  Created by OSXVN on 12/24/16.
//  Copyright © 2016 XUANVINHTD. All rights reserved.
//

import Foundation
import UIKit

extension NSObject {
    class var namOfClass: String {
        return NSStringFromClass(self).componentsSeparatedByString(".").last! as String
    }
    
    class var identifier: String {
        return String(format: "%@ID", self.namOfClass)
    }
}
