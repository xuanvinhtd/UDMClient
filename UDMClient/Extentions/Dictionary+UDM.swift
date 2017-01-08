//
//  Dictionary+UDM.swift
//  UDMTeacher
//
//  Created by OSXVN on 12/25/16.
//  Copyright © 2016 XUANVINHTD. All rights reserved.
//

import Foundation

extension Dictionary {
    
    mutating func update(other: Dictionary) {
        for (key, value) in other {
            self.updateValue(value, forKey: key)
        }
    }
    
    mutating func changeKey(from: Key, to: Key) {
        self[to] = self[from]
        self.removeValueForKey(from)
    }
}

extension Dictionary {
    
    mutating func removeValueNil()  {
        for (key, value) in self {
            if let unwrappedValue = value as? AnyObject {
                print("Unwrapped value for '\(key)' is '\(unwrappedValue)'")
            } else {
                self.removeValueForKey(key)
                print("Value for '\(key)' is nil")
            }
        }
    }
}