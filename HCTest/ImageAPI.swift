//
//  ImageAPI.swift
//  HCTest
//
//  Created by 이채원 on 2018. 5. 29..
//  Copyright © 2018년 david. All rights reserved.
//

import Foundation
import Alamofire

class ImageAPI {
    
    static let URLSTRING = "https://api.flickr.com/services/feeds/photos_public.gne"
    
    class func loadImages(completion: (([String]) -> ())?, error: (() -> ())? = nil) {
        Alamofire.request(URLSTRING).responseString { response in

            if let responseString = response.value {
                let parsedStrings = responseString.components(separatedBy: " ")
                
                let imgUrlList = parsedStrings.filter { $0.contains("src") }.map { $0.replacingOccurrences(of: "&quot;", with: "").replacingOccurrences(of: "src=", with: "") }
                if completion != nil {
                    completion!(imgUrlList)
                }
                
            } else {
                print("connection error")
                if error != nil {
                    error!()
                }
            }
        }
    }
}
