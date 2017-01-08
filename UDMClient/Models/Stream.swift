//
//  Stream.swift
//  UDMClient
//
//  Created by OSXVN on 1/8/17.
//  Copyright © 2017 XUANVINHTD. All rights reserved.
//

import Foundation

struct Stream {
    var id = "0"
    var title = ""
    var author = ""
    var student = "0"
    var createdDate = ""
    var thumbnail = "0"
    var active = ""
    
    init() {}
    
    init(withInfo data: [String: AnyObject]) {
        self.id = data["id"] as? String ?? ""
        self.title = data["title"] as? String ?? ""
        self.author = data["author"] as? String ?? ""
        self.thumbnail = data["thumbnail"] as? String ?? ""
        self.createdDate = data["createdDate"] as? String ?? ""
        self.student = data["student"] as? String ??  "0"
        self.active = data["active"] as? String ??  ""
    }
    
    static func createStreams(withInfos datas: [[String: AnyObject]]) -> [Stream]{
        var results = [Stream]()
        for data in datas {
            results.append(Stream(withInfo: data))
        }
        return results
    }
}