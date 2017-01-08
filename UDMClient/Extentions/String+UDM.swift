//
//  String+UDM.swift
//  UDMTeacher
//
//  Created by OSXVN on 12/24/16.
//  Copyright © 2016 XUANVINHTD. All rights reserved.
//

import Foundation

extension String {
    
    func formatDateFromString() -> String? {
        
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        if self == "" {
            return "2016/01/01"
        }
        let someDateTime = formatter.dateFromString(self)
        
        formatter.dateFormat = UDMConfig.formatDate
        
        return formatter.stringFromDate(someDateTime!)
    }
}