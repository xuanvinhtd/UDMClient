//
//  UserManager.swift
//  UDMTeacher
//
//  Created by OSXVN on 12/24/16.
//  Copyright © 2016 XUANVINHTD. All rights reserved.
//

import Foundation

class UserManager {
    // MARK: - Properties
    static let share = UserManager()
    var info = User()
    var isInternet = true
    var isLogInSuccess = false
    
    private init () {}
    
    func getInfos() -> [String: String?] {
        var data: [String: String?] = [:]
        data["Description"] = info.description
        data["Wallet"] = String(info.money) + "VND"
        data["Local"] = info.city
        data["Phone Number"] = info.phoneNumber
        data["Email"] = info.email
        data["BirthDay"] = info.birthday.formatDateFromString()
        
        return data
    }
}