//
//  Curruculum.swift
//  UDMTeacher
//
//  Created by OSXVN on 12/27/16.
//  Copyright © 2016 XUANVINHTD. All rights reserved.
//

// MARK: - CURRICULUMS
struct Curruculum {
    var id = "0"
    var ccourseID = ""
    var numbers = "0"
    var title = ""
    var type = "0"
    var timeVideo = ""
    var videoReview = ""
    var videoPlay = ""
    
    init() {}
    
    init(withInfo data: [String: AnyObject]) {
        self.id = data["id"] as? String ?? ""
        self.title = data["title"] as? String ?? ""
        self.ccourseID = data["ccourseID"] as? String ?? ""
        self.numbers = data["numbers"] as? String ?? ""
        self.title = data["title"] as? String ?? ""
        self.type = data["type"] as? String ?? ""
        self.timeVideo = data["timeVideo"] as? String ?? ""
        self.videoReview = data["videoReview"] as? String ?? ""
        self.videoPlay = data["videoPlay"] as? String ?? ""
    }
    
    static func createCurruculum(withInfos datas: [[String: AnyObject]]) -> [Curruculum]{
        var results = [Curruculum]()
        for data in datas {
            results.append(Curruculum(withInfo: data))
        }
        return results
    }

}
