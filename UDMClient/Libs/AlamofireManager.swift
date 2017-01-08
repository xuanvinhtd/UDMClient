//
//  AlamofireManager.swift
//  UDMTeacher
//
//  Created by OSXVN on 12/24/16.
//  Copyright © 2016 XUANVINHTD. All rights reserved.
//
import Alamofire

final class AlamofireManager {
    static let share = AlamofireManager()
    private init () {}
    
    func requestUrlByPOST(withURL url: String, paramater: [String: AnyObject], Completion completion: Result) {
        var jsontext = ""
        
        do {
            let jsonData = try NSJSONSerialization.dataWithJSONObject(paramater, options: NSJSONWritingOptions.PrettyPrinted)
            jsontext = String(data: jsonData, encoding: NSASCIIStringEncoding)!
        } catch let error as NSError {
            log.error("Parse json fail with: \(error).")
        }
        
        jsontext = "data="+jsontext
        
        Alamofire.request(.POST, url, parameters: [:], encoding: .Custom({
            (convertible, params) in
            let mutableRequest = convertible.URLRequest.copy() as! NSMutableURLRequest
            let data = jsontext.dataUsingEncoding(NSUTF8StringEncoding)
            mutableRequest.HTTPBody = data
            return (mutableRequest, nil)
        }))
            .responseJSON { response in
                log.info("Url request: \(response.request)")
                log.info("Param request: \(paramater)")
                log.info("Data from server: \(String(data: response.data!, encoding:NSUTF8StringEncoding)!)")
                
                if response.result.isSuccess {
                    guard let resultQ = UDMHelpers.convertStringToDictionary(String(data: response.data!, encoding:NSUTF8StringEncoding)!) else {
                        log.error("Do not convert data to dictionary at data get from Server")
                        return
                    }
                    
                    let isSuccess = resultQ["status"] as! String == "SUCCESS" ? true : false
                    completion(data: resultQ, msg: resultQ["message"] as? String ?? "" ,success: isSuccess)
                } else {
                    log.error("Not found data.")
                    completion(data: [String: AnyObject](), msg: "Not found data." ,success: false)
                }
        }
    }
    
    func requestUrlByPOST(withURL url: String, paramater: [String: String], encode: ParameterEncoding, Completion completion: Result) {
        Alamofire.request(.POST, url, parameters: paramater, encoding: encode)
            .responseJSON { response in
                log.info("URL request: \(response.request)")
                log.info("Param request: \(paramater)")
                log.info("Data from server:\n \(String(data: response.data!, encoding:NSUTF8StringEncoding)!)")
                
                if response.result.isSuccess {
                    guard let resultQ = UDMHelpers.convertStringToDictionary(String(data: response.data!, encoding:NSUTF8StringEncoding)!) else {
                        log.error("Do not convert data to dictionary at data get from Server")
                        return
                    }
                    let isSuccess = resultQ["status"] as! String == "SUCCESS" ? true : false
                    completion(data: resultQ, msg: resultQ["message"] as? String ?? "" ,success: isSuccess)
                } else {
                    log.error("Not found data.")
                    completion(data: [String: AnyObject](), msg: "Not found data." ,success: false)
                }
        }
    }
}