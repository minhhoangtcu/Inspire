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
import PromiseKit

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
            Constants.FlickrParameterKeys.NumberOfImages: String(size), // have to be String because it is a dictionary [String: String]
            Constants.FlickrParameterKeys.Format: Constants.FlickrParameterValues.Format,
            Constants.FlickrParameterKeys.NoJSONCallback: Constants.FlickrParameterValues.DisableJSONCallback
        ]
        
        // Firstly, request a bunch of images
        Alamofire.request(Constants.Flickr.APIBaseURL, parameters: methodParametersForSearch)
            .responseJSON { response in
                guard let value = response.result.value else {
                    print("Error in getting URLS")
                    print(response.result.error)
                    return
                }
                
                
                let json = JSON(value)
                for photoJSON in (json["photos"].dictionaryValue["photo"]?.array)! {
                    let temp = Photo(id: photoJSON["id"].stringValue, url: photoJSON["url_m"].stringValue, title: photoJSON["title"].stringValue)
                    
                    // Secondly, for each photo, we request its info. The promises are unessary, but it makes the code more readable.
                    firstly {
                        self.getEXIFInfo(photo: temp)
                    }.then { result in
                        print(result)
                    }.catch { error in
                        print("Error in getting photo EXIF")
                        print(error)
                    }
                    
                    
                }
            }
    }
    
    func getEXIFInfo(photo: Photo) -> Promise<JSON> {
        return Promise { solve, reject in
            
            let photoID = photo.id! // since temp was passed into this function, when Alamofire start requesting, temp may disappear -> id may disappear too.
            
            let methodParametersForGetEXIF = [
                Constants.FlickrParameterKeys.Method: Constants.FlickrParameterValues.MethodGetEXIF,
                Constants.FlickrParameterKeys.APIKey: Constants.FlickrParameterValues.APIKey,
                Constants.FlickrParameterKeys.PhotoID: photoID,
                Constants.FlickrParameterKeys.Format: Constants.FlickrParameterValues.Format,
                Constants.FlickrParameterKeys.NoJSONCallback: Constants.FlickrParameterValues.DisableJSONCallback
            ]
            
            Alamofire.request(Constants.Flickr.APIBaseURL, parameters: methodParametersForGetEXIF)
                .responseJSON { response in
                    if let value = response.result.value {
                        let json = JSON(value)
                        solve(json)
                    } else {
                        reject(response.result.error!)
                    }
            }
        }
    }
}
