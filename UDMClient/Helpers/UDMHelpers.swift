//
//  UDMHelpers.swift
//  UDMTeacher
//
//  Created by OSXVN on 12/24/16.
//  Copyright © 2016 XUANVINHTD. All rights reserved.
//
import Foundation
import XCGLogger
import ChameleonFramework
import ReachabilitySwift

let log = XCGLogger.defaultInstance()

public typealias Result = ((data: [String: AnyObject], msg: String, success: Bool) ->Void)
public typealias Results = ((data: [[String: AnyObject]], msg: String ,success: Bool) ->Void)

final class UDMHelpers {
    
    // MARK: - Common func
    
    class func getScreenRect() -> CGRect {
        return UIScreen.mainScreen().bounds
    }
    
    class func convertStringToDictionary(text: String) -> [String:AnyObject]? {
        if let data = text.dataUsingEncoding(NSUTF8StringEncoding) {
            do {
                return try NSJSONSerialization.JSONObjectWithData(data, options: []) as? [String:AnyObject]
            } catch let error as NSError {
                log.debug(error)
            }
        }
        return nil
    }
    
    class func getImageByURL(with url: String) -> UIImage {
        if url == "" || !url.containsString("/") {
            return UIImage(named: "Imagedefault")!
        } else {
            if let urlImage = NSURL(string: UDMConfig.API.rootDoman + url) {
                if let data = NSData(contentsOfURL: urlImage) {
                    guard let image = UIImage(data: data) as UIImage? else {
                        log.debug("User cannot get avata to url = \(url)")
                        return UIImage(named: "Imagedefault")!
                    }
                    return image
                }
            }
            return UIImage(named: "Imagedefault")!
        }
    }
    
    class func myModel() -> PhoneModel {
        let size = UIScreen.mainScreen().bounds
        switch size.height {
        case 736:
            return .iPhone6Plus
        case 667:
            return .iPhone6
        case 568:
            return .iPhone5
        case 480:
            return .iPhone4
        default:
            return .iPhone6
        }
    }
    
    // MARK: - Validation
    static func isValidEmail(testStr:String) -> Bool {
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluateWithObject(testStr)
    }
    
    static func checkMaxLength(textField: UITextField!, maxLength: Int) -> Bool {
        if (textField.text!.characters.count > maxLength) {
            return true
        }
        return false
    }
    
    static func checkMinLength(textField: UITextField!, minLength: Int) -> Bool{
        if (textField.text!.characters.count > minLength) {
            return true
        }
        return false
    }
    
    // MARK: Log
    class func setupLog() {
        if UDMConfig.isRelease == false {
            log.setup(.Debug, showLogIdentifier: false, showFunctionName: true, showThreadName: false, showLogLevel: true, showFileNames: true, showLineNumbers: true, showDate: false, writeToFile: nil, fileLogLevel: nil)
        }
    }
    
    // MARK: Chameleon Color
    class func setupTheme() {
    }
    
    class func theme() -> UIColor {
        return FlatGreen()
    }
    
    class func tintTheme() -> UIColor {
        return FlatGreen()
    }
    
    class func textTheme() -> UIColor {
        return FlatGreen()
    }
    
    class func toolBarTheme() -> UIColor {
        return FlatGreen()
    }
    
    class func backgroudTheme() -> UIColor {
        return FlatWhite()
    }
    
    class func grayTheme() -> UIColor {
        return FlatGray()
    }
    
    // MARK: - ReachabilitySwift
    private static var reachability: Reachability?
    
    class func startCheckConnectNetwork() {
        do {
            reachability = try Reachability(hostname: "http://google.com/")
        } catch let error {
            log.error("Cannot init reachability with error: \(error)")
        }
        
        guard let reachability = reachability else {
            log.error("Reachability = nil")
            return
        }
        
        reachability.whenReachable = { reachability in
            dispatch_async(dispatch_get_main_queue(), {
                if reachability.isReachableViaWiFi() {
                    log.info("Reachable via Wifi")
                } else {
                    log.info("Reachable via Cellular")
                }
                UserManager.share.isInternet = true
                NSNotificationCenter.defaultCenter().postNotificationName(UDMConfig.Notification.ConnectedInternet, object: nil, userInfo:nil)
            })
        }
        reachability.whenUnreachable = { reachability in
            dispatch_async(dispatch_get_main_queue(), {
                log.info("Not reachable")
                UserManager.share.isInternet = false
                NSNotificationCenter.defaultCenter().postNotificationName(UDMConfig.Notification.DisconnetedInternet, object: nil, userInfo: nil)
            })
        }
        do {
            try reachability.startNotifier()
        } catch let e {
            log.error("Cannot start Notifier Reachability NetWork : \(e)")
        }
    }
    
    class func stopCheckConnectNetwork() {
        guard let reachability = reachability else {
            log.error("Reachability = nil")
            return
        }
        reachability.stopNotifier()
    }
}

// MARK: - Function Name
enum FuncName: String {
    case RegisterEmail = "register_email"
    case LoginMail = "login_email"
    case ResetPassword = "reset_password"
    case GetCourseSale = "get_onSale"
    case GetMyCourseList = "get_my_courses"
    case GetMyWishList = "get_my_wishList"
    case GetCouseLive = "get_live"
    case GetCouseDetailLive = "get_live_detail"
    case GetCourseDetail = "get_detail"
    case TurnLive = "turn_live"
    case GetData = "get"
    case GetRateList = "get_rate"
    case BuyCourses = "buy"
    case RateCourses = "rate"
    case GetTeacherInfo = "get_teacherInfo"
    case UpdateProfile = "user_update"
}

// MARK: - Model name
enum ModelName: String {
    case Course = "courses"
    case Category = "category"
    case Teacher = "teacher"
    case User = "user"
    case Curriculums = "curriculums"
}

// MARK: - Phone Model
enum PhoneModel {
    case iPhone4
    case iPhone5
    case iPhone6
    case iPhone6Plus
}

