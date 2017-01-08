//
//  UDMServer.swift
//  UDMTeacher
//
//  Created by OSXVN on 12/24/16.
//  Copyright © 2016 XUANVINHTD. All rights reserved.
//

import Foundation

struct UDMServer {
    static let share = UDMServer()
    private init() {}
    
    // EXECUTES API
    private func executeRequestAPI(withData info: [String: String]?, AndCompletion completion: Result) {
        guard let _info = info else {
            log.info("Requester Infomation nil")
            return
        }
        AlamofireManager.share.requestUrlByPOST(withURL: UDMConfig.API.doman, paramater: _info, encode: .URLEncodedInURL, Completion: completion)
    }
    
    private func executeUploadAPI(withData info: [String: AnyObject]?, url: String, AndCompletion completion: Result) {
        guard let _info = info else {
            log.info("Requester Infomation nil")
            return
        }
        AlamofireManager.share.requestUrlByPOST(withURL: url, paramater: _info, Completion: completion)
    }
    
    func signInAccount(withData info: [String: String]?, Completion completion: Result) {
        executeRequestAPI(withData: info, AndCompletion: completion)
    }
    
    func getListDataFromServer(withData info: [String: String]?, Completion completion: Result) {
        executeRequestAPI(withData: info, AndCompletion: completion)
    }
    
    func ratingCourses(withData info: [String: String]?, courseID id: String, Completion completion: Result) {
        let urlUpdate = UDMConfig.API.getDataDetail(withFunc: FuncName.RateCourses.rawValue,
                                                    model: ModelName.Course.rawValue,
                                                    token: UserManager.share.info.token,
                                                    courseID: id)
        executeUploadAPI(withData: info, url: urlUpdate, AndCompletion: completion)
    }
    
    func editProfile(withData info: [String: String]?, courseID id: String, Completion completion: Result) {
        let urlUpdate = UDMConfig.API.getDataDetail(withFunc: FuncName.UpdateProfile.rawValue,
                                                    model: ModelName.User.rawValue,
                                                    token: UserManager.share.info.token,
                                                    courseID: id)
        executeUploadAPI(withData: info, url: urlUpdate, AndCompletion: completion)
    }
    
    // REQUEST API
    func login(withEmail email: String, password: String, completion: Result) {
        let data = UDMDictionaryBuilder.share.login(withEmail: email, password: password)
        self.executeRequestAPI(withData: data) { (data, msg, success) in
            guard let _data = data["data"] as? [String: AnyObject] else {
                log.error("Not found data.")
                completion(data: [String: AnyObject](), msg: "Not found data.", success: false)
                return
            }
            completion(data: _data, msg: msg, success: success)
        }
    }
    
    func resetPassword(withEmail email: String, completion: Result) {
        let data = UDMDictionaryBuilder.share.resetPassword(withEmail: email)
        self.executeRequestAPI(withData: data) { (data, msg, success) in
            guard let _data = data["data"] as? [String: AnyObject] else {
                log.error("Not found data.")
                completion(data: [String: AnyObject](), msg: "Not found data.", success: false)
                return
            }
            completion(data: _data, msg: msg, success: success)
        }
    }
    
    func getList(withData data:[String: String], Andcompletion completion: Results ) {
        self.getListDataFromServer(withData: data) { (data, msg ,success) in
            guard let _data = data["data"] as? [[String: AnyObject]] else {
                log.error("Not found data.")
                completion(data: [[String: AnyObject]](), msg: "Not found data.", success: false)
                return
            }
            completion(data: _data, msg: msg, success: success)
        }
    }
    
    func getTeacherInfo(withTeacherID id: String, completion: Results) {
        let data = UDMDictionaryBuilder.share.getTeacherInfo(with: id)
        self.getList(withData: data, Andcompletion: completion)
    }
    
    func getMyCourses(completion: Results) {
        let data = UDMDictionaryBuilder.share.getMyCourseList()
        self.getList(withData: data, Andcompletion: completion)
    }
    
    func getWishList(completion: Results) {
        let data = UDMDictionaryBuilder.share.getWishList()
        self.getList(withData: data, Andcompletion: completion)
    }
    
    func getCoursesLive(completion: Results) {
        let data = UDMDictionaryBuilder.share.getCoursesLive()
        self.getList(withData: data, Andcompletion: completion)
    }
    
    func getReviews(withCourseId id: String?, completion: Results) {
        let data = UDMDictionaryBuilder.share.getReviews(withCourseId: id)
        self.getList(withData: data, Andcompletion: completion)
    }
    
    func getCourseLiveDetail(withCourseID id: String, completion: Results) {
        let data = UDMDictionaryBuilder.share.getCourseLiveDetail(courseID: id)
        self.getList(withData: data, Andcompletion: completion)
    }

    func getCourses(withCategoryID id: String, limit: String, offset: String, completion: Results) {
        let data = UDMDictionaryBuilder.share.getCourseList(with: id, limit: limit, offset: offset)
        self.getList(withData: data, Andcompletion: completion)
    }
    
    func getCoursesSale(withCategoryID id: String?, limit: String, offset: String, completion: Results) {
        let data = UDMDictionaryBuilder.share.getCourseSaleList(with: id, limit: limit, offset: offset)
        self.getList(withData: data, Andcompletion: completion)
    }
    
    func getCategories(completion: Results) {
        let data = UDMDictionaryBuilder.share.getCategories(withID: "1")
        self.getList(withData: data, Andcompletion: completion)
    }
    
    func getCoursesDetail(withCourseID id: String, completion: Results) {
        let data = UDMDictionaryBuilder.share.getCoursesDetail(with: id)
        self.getList(withData: data, Andcompletion: completion)
    }
    
    func getCurriculumns(withCourseID id: String, completion: Results) {
        let data = UDMDictionaryBuilder.share.getCurriculums(with: id)
        self.getList(withData: data, Andcompletion: completion)
    }
    
    func turnStream(withCoures id: String, state: String, completion: Results) {
        let data = UDMDictionaryBuilder.share.turnOnOffCourseLive(with: id, status: state)
        self.executeRequestAPI(withData: data) { (data, msg ,success) in
            guard let _data = data["data"] as? [[String: AnyObject]] else {
                log.error("Not found data.")
                completion(data: [[String: AnyObject]](), msg: "Not found data.", success: false)
                return
            }
            completion(data: _data, msg: msg, success: success)
        }
    }
    
    func buyCourses(withCoures id: String, completion: Results) {
        let data = UDMDictionaryBuilder.share.buyCourses(withCourseId: id)
        self.executeRequestAPI(withData: data) { (data, msg ,success) in
            guard let _data = data["data"] as? [[String: AnyObject]] else {
                log.error("Not found data.")
                completion(data: [[String: AnyObject]](), msg: "Not found data.", success: false)
                return
            }
            completion(data: _data, msg: msg, success: success)
        }
    }
    
    func addWishList(withCoures id: String, completion: Results) {
        let data = UDMDictionaryBuilder.share.addWishList(withCourseId: id)
        self.executeRequestAPI(withData: data) { (data, msg ,success) in
            guard let _data = data["data"] as? [[String: AnyObject]] else {
                log.error("Not found data.")
                completion(data: [[String: AnyObject]](), msg: "Not found data.", success: false)
                return
            }
            completion(data: _data, msg: msg, success: success)
        }
    }
    
    func removeWishList(withCoures id: String, completion: Results) {
        let data = UDMDictionaryBuilder.share.removeWishList(withCourseId: id)
        self.executeRequestAPI(withData: data) { (data, msg ,success) in
            guard let _data = data["data"] as? [[String: AnyObject]] else {
                log.error("Not found data.")
                completion(data: [[String: AnyObject]](), msg: "Not found data.", success: false)
                return
            }
            completion(data: _data, msg: msg, success: success)
        }
    }
}
