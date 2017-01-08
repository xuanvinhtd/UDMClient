//
//  Course.swift
//  UDMTeacher
//
//  Created by OSXVN on 12/24/16.
//  Copyright © 2016 XUANVINHTD. All rights reserved.
//

import Foundation

struct Course {
    var id = "0"
    var title = ""
    var author = ""
    var authorID = ""
    var descriptions = ""
    var oldPrice = "0"
    var newPrice = "0"
    var thumbnail = ""
    var sale = 0.0
    var rank = "0"
    var review = 0.0
    var student = 0
    
    init() {}
    
    init(withInfo data: [String: AnyObject]) {
        self.id = data["id"] as? String ?? ""
        self.title = data["title"] as? String ?? ""
        self.author = data["author"] as? String ?? ""
        self.authorID = data["authorID"] as? String ?? ""
        self.descriptions = data["idescriptionsd"] as? String ?? ""
        self.oldPrice = data["oldPrice"] as? String ?? ""
        self.newPrice = data["newPrice"] as? String ?? ""
        self.thumbnail = data["thumbnail"] as? String ?? ""
        self.sale = data["sale"] as? Double ?? 0.0
        self.rank = data["rank"] as? String ?? "0"
        self.review = data["review"] as? Double ?? 0.0
        self.student = data["student"] as? Int ?? 0
    }
    
    static func createCourses(withInfos datas: [[String: AnyObject]]) -> [Course]{
        var results = [Course]()
        for data in datas {
            results.append(Course(withInfo: data))
        }
        return results
    }
}
