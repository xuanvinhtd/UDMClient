//
//  Teacher.swift
//  UDMClient
//
//  Created by OSXVN on 1/8/17.
//  Copyright © 2017 XUANVINHTD. All rights reserved.
//

import Foundation

struct Teacher {
    var id = "0"
    var fullName = ""
    var avatar = ""
    var descriptions = ""
    var rank = "0"

    init() {}
    
    init(withInfo data: [String: AnyObject]) {
        self.id = data["id"] as? String ?? ""
        self.fullName = data["fullName"] as? String ?? ""
        self.avatar = data["avatar"] as? String ?? ""
        self.descriptions = data["descriptions"] as? String ?? ""
        self.rank = data["rank"] as? String ?? "0"
    }
    
    static func createTeachers(withInfos datas: [[String: AnyObject]]) -> [Teacher]{
        var results = [Teacher]()
        for data in datas {
            results.append(Teacher(withInfo: data))
        }
        return results
    }
}