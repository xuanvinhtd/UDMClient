//
//  UDMDictionaryBuilder.swift
//  UDMUser
//
//  Created by OSXVN on 12/25/16.
//  Copyright © 2016 XUANVINHTD. All rights reserved.
//

import Foundation

struct UDMDictionaryBuilder {
    static let share = UDMDictionaryBuilder()
    private init() {}
    
    private func builder(withModel model: String, funcName: String, token: String?) -> [String:String] {
        var result: [String: String] = [:]
        //Common paramater
        result["model"] = model
        result["func"] = funcName
        if let _token = token {
            result["token"] = _token
        }
        return result
    }
    // MARK: - USER
    private func builderUser(withModel model: String, funcName: String,token: String?, email: String?, password: String?, currentPassword: String?, newPassword: String?, fullName: String?, sex: String?, phoneNumber: String?, birthday: String?, city: String?) -> [String: String]{
        
        let commonDictionary = builder(withModel: model, funcName: funcName, token: token)
        var result: [String: String] = [:]
        if let _email = email {
            result["email"] = _email
        }
        if let _password = password {
            result["password"] = _password
        }
        if let _currentPassword = currentPassword {
            result["currentPassword"] = _currentPassword
        }
        if let _newPassword = newPassword {
            result["newPassword"] = _newPassword
        }
        if let _fullName = fullName {
            result["fullName"] = _fullName
        }
        if let _sex = sex {
            result["sex"] = _sex
        }
        if let _phoneNumber = phoneNumber {
            result["phoneNumber"] = _phoneNumber
        }
        if let _city = city {
            result["city"] = _city
        }
        if let _birthday = birthday {
            result["birthday"] = _birthday
        }
        result.update(commonDictionary)
        return result
    }
    
    func updateProfile(withFullName fullName: String, phoneNumber: String, sex: String, birthday: String, city: String) -> [String: String] {
        return builderUser(withModel: "",
                           funcName: "",
                           token: "",
                           email: nil, password: nil, currentPassword: nil, newPassword: nil,
                           fullName: fullName,
                           sex: sex,
                           phoneNumber: phoneNumber,
                           birthday: birthday,
                           city: city)
    }
    
    func login(withEmail email: String, password: String) -> [String: String] {
        return builderUser(withModel: ModelName.User.rawValue,
                           funcName: FuncName.LoginMail.rawValue,
                           token: nil,
                           email: email,
                           password: password,
                           currentPassword: nil,
                           newPassword: nil,
                           fullName: nil,
                           sex: nil,
                           phoneNumber: nil,
                           birthday: nil,
                           city: nil)
    }
    
    func signin(withFullName fullName: String, email: String, password: String) -> [String: String] {
        return builderUser(withModel: ModelName.User.rawValue,
                           funcName: FuncName.RegisterEmail.rawValue,
                           token: nil,
                           email: email,
                           password: password, currentPassword: nil, newPassword: nil,
                           fullName: fullName,
                           sex: nil, phoneNumber: nil, birthday: nil, city: nil)
    }
    
    func resetPassword(withEmail email: String) -> [String: String] {
        return builderUser(withModel: ModelName.User.rawValue,
                           funcName: FuncName.ResetPassword.rawValue,
                           token:nil,
                           email: email,
                           password: nil, currentPassword: nil, newPassword: nil,
                           fullName: nil, sex: nil, phoneNumber: nil, birthday: nil, city: nil)
    }
    
    // MARK: - COURSE
    private func builderCourse(withModel model: String, funcName: String, token: String?, idCategory: String?, courseID: String?, limit: String?, offset: String?) -> [String: String]{
        let commonDictionary = builder(withModel: model, funcName: funcName, token: token)
        var result: [String: String] = [:]
        if let _idCategory = idCategory {
            result["categoryID"] = _idCategory
        }
        if let _limit = limit {
            result["limit"] = _limit
        }
        if let _offset = offset {
            result["offset"] = _offset
        }
        if let _courseID = courseID {
            result["coursesID"] = _courseID
        }
        result.update(commonDictionary)
        return result
    }
    
    func getMyCourseList() -> [String: String] {
        return builderCourse(withModel: ModelName.Course.rawValue,
                             funcName: FuncName.GetMyCourseList.rawValue,
                             token: UserManager.share.info.token,
                             idCategory: nil, courseID: nil,
                             limit: nil,
                             offset: nil)
    }
    
    func getWishList() -> [String: String] {
        return builderCourse(withModel: ModelName.Course.rawValue,
                             funcName: FuncName.GetMyWishList.rawValue,
                             token: UserManager.share.info.token,
                             idCategory: nil, courseID: nil,
                             limit: nil,
                             offset: nil)
    }
    
    func getReviews(withCourseId id: String?) -> [String: String] {
        return builderCourse(withModel: ModelName.Course.rawValue,
                             funcName: FuncName.GetRateList.rawValue,
                             token: UserManager.share.info.token,
                             idCategory: nil, courseID: id,
                             limit: nil,
                             offset: nil)
    }
    
    func buyCourses(withCourseId id: String) -> [String: String] {
        return builderCourse(withModel: ModelName.Course.rawValue,
                             funcName: FuncName.BuyCourses.rawValue,
                             token: UserManager.share.info.token,
                             idCategory: nil, courseID: id,
                             limit: nil,
                             offset: nil)
    }
    
    func getCoursesLive() -> [String: String] {
        return builderCourse(withModel: ModelName.Course.rawValue,
                             funcName: FuncName.GetCouseLive.rawValue,
                             token: UserManager.share.info.token,
                             idCategory: nil, courseID: nil,
                             limit: nil,
                             offset: nil)
    }
    
    func getCourseDetail(with courseID: String?) -> [String: String] {
        return builderCourse(withModel: ModelName.Course.rawValue,
                             funcName: FuncName.GetCourseDetail.rawValue,
                             token: UserManager.share.info.token,
                             idCategory: nil, courseID: courseID,
                             limit: nil,
                             offset: nil)
    }
    
    func getCourseLiveDetail(courseID id: String) -> [String: String] {
        return builderCourse(withModel: ModelName.Course.rawValue,
                             funcName: FuncName.GetCouseDetailLive.rawValue,
                             token: UserManager.share.info.token,
                             idCategory: nil, courseID: id,
                             limit: nil,
                             offset: nil)
    }

    func getCourseList(with idCategory: String?, limit: String, offset: String) -> [String: String] {
        return builderCourse(withModel: ModelName.Course.rawValue,
                             funcName: FuncName.GetData.rawValue,
                             token: UserManager.share.info.token,
                             idCategory: idCategory, courseID: nil,
                             limit: limit,
                             offset: offset)
    }
    
    func getCourseSaleList(with idCategory: String?, limit: String, offset: String) -> [String: String] {
        return builderCourse(withModel: ModelName.Course.rawValue,
                             funcName: FuncName.GetCourseSale.rawValue,
                             token: UserManager.share.info.token,
                             idCategory: nil, courseID: nil,
                             limit: nil,
                             offset: nil)
    }
    
    func getCoursesDetail(with courseID: String?) -> [String: String] {
        return builderCourse(withModel: ModelName.User.rawValue,
                             funcName: FuncName.GetCourseDetail.rawValue,
                             token: UserManager.share.info.token,
                             idCategory: nil, courseID: courseID,
                             limit: nil,
                             offset: nil)
    }
    
    func addWishList(withCourseId id: String) -> [String: String] {
        return builderCourse(withModel: ModelName.Course.rawValue,
                             funcName: FuncName.AddWishList.rawValue,
                             token: UserManager.share.info.token,
                             idCategory: nil, courseID: id,
                             limit: nil,
                             offset: nil)
    }
    
    func removeWishList(withCourseId id: String) -> [String: String] {
        return builderCourse(withModel: ModelName.Course.rawValue,
                             funcName: FuncName.RemoveWishList.rawValue,
                             token: UserManager.share.info.token,
                             idCategory: nil, courseID: id,
                             limit: nil,
                             offset: nil)
    }
    
    // MARK: - Rating
    func builderRating(withTitle title: String?, description: String?, value: String?) -> [String: String]{
        var result: [String: String] = [:]
        
        if let _title = title {
            result["title"] = _title
        }
        
        if let _description = description {
            result["description"] = _description
        }
        
        if let _value = value {
            result["value"] = _value
        }
        return result
    }
    
    func turnOnOffCourseLive(with courseID: String, status: String) -> [String: String] {
        let commonDictionary = builder(withModel: ModelName.Course.rawValue,
                                       funcName: FuncName.TurnLive.rawValue,
                                       token: UserManager.share.info.token)
        var result: [String: String] = [:]
        result["coursesID"] = courseID
        result["status"] = status
        result.update(commonDictionary)
        return result
    }

    // MARK: - Model Teacher
    private func builderTeacher(withModel model: String, funcName: String,token: String, teacherID: String?) -> [String: String]{
        let commonDictionary = builder(withModel: model, funcName: funcName, token: token)
        var result: [String: String] = [:]
        
        if let _teacherID = teacherID {
            result["teacherID"] = _teacherID
        }
        
        result.update(commonDictionary)
        
        return result
    }
    
    func getTeacherInfo(with teacherID: String?) -> [String: String] {
        return builderTeacher(withModel: ModelName.Teacher.rawValue,
                              funcName: FuncName.GetTeacherInfo.rawValue,
                              token: UserManager.share.info.token,
                              teacherID: teacherID)
    }
    
    // MARK: - Model Category
    private func builderCategory(withModel model: String, funcName: String,token: String?, idParent: String?) -> [String: String]{
        let commonDictionary = builder(withModel: model, funcName: funcName, token: token)
        var result: [String: String] = [:]
        if let _idParent = idParent {
            result["parentID"] = _idParent
        }
        result.update(commonDictionary)
        
        return result
    }
    
    func getCategories(withID idParent: String?) -> [String: String] {
        return builderCategory(withModel: ModelName.Category.rawValue,
                               funcName: FuncName.GetData.rawValue,
                               token: UserManager.share.info.token,
                               idParent: idParent)
    }
    
    // MARK: - Model Curriculums
    func getCurriculums(with courseID: String?) -> [String: String] {
        return builderCourse(withModel: ModelName.Curriculums.rawValue,
                             funcName: FuncName.GetData.rawValue,
                             token: UserManager.share.info.token,
                             idCategory: nil, courseID: courseID,
                             limit: nil,
                             offset: nil)
    }
}