//
//  UDMConfig.swift
//  UDMTeacher
//
//  Created by OSXVN on 12/24/16.
//  Copyright © 2016 XUANVINHTD. All rights reserved.
//

import Foundation

final class UDMConfig {
    
    static let isRelease = false
    // MARK: App Config
    static let formatDate = "yyyy/MM/dd"
    static let forcedHideActivityIndicatorTimeInterval: NSTimeInterval = 30
    
    // MARK: R5Streaming config
    struct R5Stream {
        static let ip = "61.28.226.35"
        static let port: Int32 = 8554
        static let context = "live"
        static let buffer_time:Float = 1.0
        static let bitrate = 750
        
        static let camera_width = 640
        static let camera_height = 360
        
        static let hostName = "61.28.226.35"
        static let streamName1 = "vinh1"
        static let streamName2 = "vinh2"
        
        static let isDebugView = true
        static let onVideo = true
        static let onAudio = true
    }
    
    
    // MARK: Notification Name
    struct Notification {
        static let ConnectedInternet = "UDMConfig.Notification.ConnectedInternet"
        static let DisconnetedInternet = "UDMConfig.Notification.DisconnetedInternet"
        static let GetDataCourseAndCategory = "UDMConfig.Notification.GetDataCourseAndCategory"
    }
    
    struct API {
        static let rootDoman = "http://61.28.226.35:8012"
        static let doman = "\(rootDoman)/server/api/"
        
        static func buildUrl(withFunc name: String, model: String) -> String {
            return "\(doman)index.php?func=\(name)&model=\(model)"
        }
        
        static func signIn(withFunc name: String, mode strModel: String) -> String {
            return buildUrl(withFunc: name, model: strModel)
        }
        
        static func getData(withFunc name: String, model strModel: String, token: String) -> String {
            return buildUrl(withFunc: name, model: strModel) + "&token=\(token)"
        }
        
        static func getDataDetail(withFunc name: String, model strModel: String, token strToken: String, courseID: String) -> String{
            return getData(withFunc: name, model: strModel, token: strToken) + "&coursesID=\(courseID)"
        }
    }
}
