//
//  Category.swift
//  UDMClient
//
//  Created by OSXVN on 1/4/17.
//  Copyright © 2017 XUANVINHTD. All rights reserved.
//

import Foundation

struct Category {
    var id = "0"
    var parentID = "0"
    var title = ""
    var thumbnail = ""
    
    init() {}
    
    init(withInfo data: [String: AnyObject]) {
        self.id = data["id"] as? String ?? ""
        self.title = data["title"] as? String ?? ""
        self.parentID = data["parentID"] as? String ?? ""
        self.thumbnail = data["thumbnail"] as? String ?? ""
    }
    
    static func createCategories(withInfos datas: [[String: AnyObject]]) -> [Category]{
        var results = [Category]()
        for data in datas {
            results.append(Category(withInfo: data))
        }
        return results
    }
}