//
//  User.swift
//  UDMTeacher
//
//  Created by OSXVN on 12/24/16.
//  Copyright © 2016 XUANVINHTD. All rights reserved.
//

import Foundation

struct User {
    var fullName = ""
    var sex = "0"
    var email = ""
    var password = ""
    var birthday = ""
    var city = ""
    var phoneNumber = ""
    var token = ""
    var level = 0
    var money = "0"
    var avatar = ""
    var description = ""
    
    init() {}
    
    init(withInfo data: [String: AnyObject]) {
        self.fullName = data["fullName"] as? String ?? ""
        self.sex = data["sex"] as? String ?? "0"
        self.email = data["email"] as? String ?? ""
        self.password = data["password"] as? String ?? ""
        self.birthday = data["birthday"] as? String ?? ""
        self.city = data["city"] as? String ?? ""
        self.phoneNumber = data["phoneNumber"] as? String ?? ""
        self.token = data["token"] as? String ?? ""
        self.level = data["level"] as? Int ?? 0
        self.money = data["money"] as? String ?? "0"
        self.avatar = data["avatar"] as? String ?? ""
        self.description = data["description"] as? String ?? ""
    }
}