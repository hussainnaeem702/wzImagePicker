
//
//  CustomMethods.swift
//  WzPicker
//
//  Created by Adeel on 12/02/2020.
//  Copyright © 2020 Adeel. All rights reserved.
//

import Foundation
import UIKit
import Photos
//import Alamofire


//let placeHolderImage = UIImage(named: "image-placeholder")!

class CustomMethods: NSObject {
    
    static func standardSizeOfcollectionviewCell() -> CGSize
    {
        let widthOfView = UIScreen.main.bounds.width / 4//self.view.frame.size.width / 4;
        if widthOfView > 110
        {
            return CGSize(width: widthOfView, height: widthOfView)
        }
        return CGSize(width: 110    , height: 110)
    }
    
    static func getAssetThumbnail(asset: PHAsset) -> UIImage
    {
        let manager = PHImageManager.default()
        let option = PHImageRequestOptions()
        var thumbnail = UIImage()
        option.isSynchronous = true
        manager.requestImage(for: asset, targetSize: CGSize(width: 100.0, height: 100.0), contentMode: .aspectFill, options: option, resultHandler: {(result, info)->Void in
                thumbnail = result!
        })
        return thumbnail
    }
    
    static func placeholderImageWithSize(_ size : CGSize) -> UIImage?
    {
        UIGraphicsBeginImageContext(size)
        let context = UIGraphicsGetCurrentContext()

        let backgroundColor = UIColor(red: 239.0 / 255.0, green: 239.0 / 255.0, blue: 244.0 / 255.0, alpha: 1.0)
        let iconColor = UIColor(red: 179.0 / 255.0, green: 179.0 / 255.0, blue: 182.0 / 255.0, alpha: 1.0)
        
        // Background
        context?.setFillColor(backgroundColor.cgColor)
        context?.fill(CGRect(x: 0, y: 0, width: size.width, height: size.height))
        
        // Icon (back)
        let backIconRect = CGRect(x: size.width * (16.0 / 68.0), y: size.height * (20.0 / 68.0), width: size.width * (32.0 / 68.0), height: size.height * (24.0 / 68.0))

        context?.setFillColor(iconColor.cgColor)
        context?.fill(backIconRect)

        context?.setFillColor(backgroundColor.cgColor)
        context?.fill(backIconRect.insetBy(dx: 1.0, dy: 1.0))
        
        
        // Icon (front)
        let frontIconRect = CGRect(x: size.width * (20.0 / 68.0), y: size.height * (24.0 / 68.0), width: size.width * (32.0 / 68.0), height: size.height * (24.0 / 68.0))

        context?.setFillColor(backgroundColor.cgColor)
        context?.fill(frontIconRect.insetBy(dx: -1.0, dy: -1.0))

        context?.setFillColor(iconColor.cgColor)
        context?.fill(frontIconRect)

        context?.setFillColor(backgroundColor.cgColor)
        context?.fill(frontIconRect.insetBy(dx: 1.0, dy: 1.0))

        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
    
    
    static func getStringValue(keyString:String, dictionary dict:[String:Any]) -> String
    {
        if let value = dict[keyString] as? NSNumber
        {
            return value.stringValue
        }
        else if let value = dict[keyString] as? String
        {
            return value
        }
        
        return ""
    }
    
    
    static func getDictionaryValue(keyString:String, dictionary dict:[String:Any]) -> [String:Any]?
    {
        if let value = dict[keyString] as? [String:Any]
        {
            return value
        }
        return nil
    }
    
    static func getDictArrayValue(keyString:String, dictionary dict:[String:Any]) -> [[String : Any]]?
    {
        if let value = dict[keyString] as? [[String : Any]]
        {
            return value
        }
        return  nil
    }
    
    
//    static func restApiGETResponse(eventName:String ,parameters:Parameters, sourceVC : UIViewController ,completionHandler: ((NSDictionary?, NSError?) -> Void)?)
//    {
//
//        print(parameters)
//        //let headers =  ["Content-Type": "application/json"]
//
//        let url = eventName //HOST_URL + eventName.rawValue
//
//        let manager = Alamofire.SessionManager.default
//        manager.session.configuration.timeoutIntervalForRequest = 10
//
//
//        manager.request(url, method:.post, parameters:parameters, encoding: URLEncoding.httpBody,headers:nil)
//
//
//            .responseJSON { (response) in
//            switch response.result
//            {
//            case .success:
//                if let data = response.result.value
//                {
//                    let dictionary = NSDictionary.init(object: data, forKey: "json" as NSCopying)
//                    let jsonDict = dictionary.object(forKey: "json") as! NSDictionary
//                    print(jsonDict)
//                    let status = jsonDict.object(forKey: "status") as! String
//                    if status == "success"
//                    {
//                        completionHandler!(jsonDict, nil)
//                    }
//                    else
//                    {
//                        let errorMessage = jsonDict.object(forKey: "msg") as! String
//                        let error = NSError.init(domain: errorMessage, code: 3, userInfo: nil)
//                        completionHandler!(nil, error)
//
//                        // SH :: If we got token expire response
////                        if errorMessage == "session expired" //error.code == SESSION_EXPIRE_CODE //
////                        {
////                            //completionHandler!(nil, error)
////
////                            let urlRefreshToken = HOST_URL + API_CALLS_METHODS.REFRESH_TOKEN.rawValue
////                            let userName        = UserData.loggedUserDomainName()
////                            //let token           = UserData.loggedUserToken()
////
////                            let params : Parameters = ["public_name"  : userName]
////                            //
////                            Alamofire.request(urlRefreshToken, method:.post, parameters:params, encoding: URLEncoding.httpBody,headers:nil)
////                                .responseJSON { (response) in
////                                    if let data = response.result.value
////                                    {
////                                        let dict = NSDictionary.init(object: data, forKey: "json" as NSCopying)
////                                        let jsonDict = dict.object(forKey: "json") as! NSDictionary
////                                        print(jsonDict)
////                                        let success = jsonDict.object(forKey: "status") as? String
////                                        if success == "success"
////                                        {
////                                            if let msj  = jsonDict.object(forKey: "msg") as? String
////                                            {
////                                                if msj == "user is already logged in"
////                                                {
////                                                    APIManager.restApiGETResponse(eventName: .LOGOUT_USER, parameters: [:], sourceVC: sourceVC) { (response, error) in
////
////                                                        if error != nil
////                                                        {
////                                                            return
////                                                        }
////
////                                                        if response != nil
////                                                        {
////                                                             UserData.logout()
////                                                        }
////
////                                                    }
////                                                }
////                                            }
////                                            if  let token = jsonDict.object(forKey: "token") as? String
////                                            {
////                                                // SH :: WE Got new token and will call same API with updated token.
////
////                                                print("got token \(token)")
////
////                                                UserData.saveUserToken(token)
////
////                                                var newParams : Parameters = parameters
////                                                newParams["token"] = token
////                                                restApiGETResponse(eventName: eventName, parameters: newParams, sourceVC: sourceVC, completionHandler: completionHandler)
////                                            }
////                                        }
////                                    }
////                            }
////
////                        }
////                        else
////                        {
//                            //Constant.showAlertWithTitleAndMessage(title: "", message: errorMessage, fromVC: sourceVC)
//
////                        }
//                    }
//                }
//
//            case .failure(let error):
//
//                if let responseDatavalue = response.data
//                {
//                    let responseError = String(bytes: responseDatavalue, encoding: .utf8) ?? "response.data can not be parsed"
//                    print("error in api: \(responseError)")
//                }
//
//                completionHandler!(nil, error as NSError)
//            }
//        }
//    }
    
}
