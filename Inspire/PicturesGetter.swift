//
//  PicturesGetter.swift
//  Inspire
//
//  Created by Minh Hoang on 9/23/16.
//  Copyright © 2016 Minh Hoang. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON

class PictureGetter {
    
    var photos: [Photo] = []
    private var tagValue: String = ""
    private var size: Int = 0
    
    init(withTags tags: String..., numOfPictures size: Int) {
        tagValue = getTagValue(tags: tags)
        self.size = size
    }
    
    private func getTagValue(tags: [String]) -> String {
        var result = ""
        for tag in tags {
            result.append(tag + ",")
        }
        return result
    }
    
    func getUrls(completionHandler functionToExecuteAtTheEnd: @escaping (Void) -> Void) {
        
        let methodParametersForSearch = [
            Constants.FlickrParameterKeys.Method: Constants.FlickrParameterValues.MethodSearch,
            Constants.FlickrParameterKeys.APIKey: Constants.FlickrParameterValues.APIKey,
            Constants.FlickrParameterKeys.Tags: tagValue,
            Constants.FlickrParameterKeys.Extras: Constants.FlickrParameterValues.MediumURL,
            Constants.FlickrParameterKeys.NumberOfImages: String(size),
            Constants.FlickrParameterKeys.Format: Constants.FlickrParameterValues.Format,
            Constants.FlickrParameterKeys.NoJSONCallback: Constants.FlickrParameterValues.DisableJSONCallback
        ]
        
        Alamofire.request(Constants.Flickr.APIBaseURL, parameters: methodParametersForSearch)
            .responseJSON { response in
                guard let value = response.result.value else {
                    print("Error in getting URLS")
                    print(response.result.error)
                    return
                }
                
                
                let json = JSON(value)
                for photo in (json["photos"].dictionaryValue["photo"]?.array)! {
                    let temp = Photo(url: photo["url_m"].stringValue, title: photo["title"].stringValue)
                    self.photos.append(temp)
                }
            }
    }
}
