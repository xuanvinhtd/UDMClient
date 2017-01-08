//
//  Review.swift
//  UDMTeacher
//
//  Created by OSXVN on 12/27/16.
//  Copyright © 2016 XUANVINHTD. All rights reserved.
//

struct Review {
    var rating = 0.0
    var dateRate = ""
    var userName = ""
    var description = ""
    var title = ""
    
    init() {}
    
    init(withInfo data: [String: AnyObject]) {
        self.rating = Double(data["value"] as? String ?? "0") ?? 0.0
        self.dateRate = data["dateRate"] as? String ?? ""
        self.userName = data["userName"] as? String ?? ""
        self.description = data["description"] as? String ?? ""
        self.title = data["title"] as? String ?? ""
    }
    
    static func createReview(withInfos datas: [[String: AnyObject]]) -> [Review]{
        var results = [Review]()
        for data in datas {
            results.append(Review(withInfo: data))
        }
        return results
    }
    
}