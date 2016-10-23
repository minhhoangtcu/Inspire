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
    
    var photos: [Int:Photo] = [:]
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
                for photoJSON in (json[Constants.FlickrResponseKeys.Photos].dictionaryValue[Constants.FlickrResponseKeys.Photo]?.array)! {
                    let temp = Photo(id: photoJSON[Constants.FlickrResponseKeys.PhotoID].stringValue, url: photoJSON[Constants.FlickrResponseKeys.MediumURL].stringValue, title: photoJSON[Constants.FlickrResponseKeys.Title].stringValue)
                    self.photos[Int(temp.id)!] = temp // add to the list right away, so that the app can display the image first as soon as possible
                    
                    // Secondly, for each photo, we request its info. The promises are unessary, but it makes the code more readable.
                    
                    self.getEXIFInfo(photoID: temp.id)
                    .then { result -> Void in
                        
                        let photo = self.photos[result.0]!
                        let exifs = result.1[Constants.FlickrResponseKeys.Photo][Constants.FlickrResponseKeys.EXIF].arrayValue
                        
//                        print(result.1)
//                        print()
                        
                        for exif in exifs {
                            
//                            print(exif)
                            
                            let content = exif[Constants.FlickrResponseKeys.Raw][Constants.FlickrResponseKeys.Content].stringValue
                            
                            switch (exif[Constants.FlickrResponseKeys.Tag].stringValue) {
                            case Constants.FlickrResponseKeys.Make:
                                photo.cameraMake = content
                                print(content)
                                break
                            case Constants.FlickrResponseKeys.Model:
                                break
                            case Constants.FlickrResponseKeys.ShuttleSpeed:
                                break
                            case Constants.FlickrResponseKeys.Aperture:
                                break
                            case Constants.FlickrResponseKeys.ISO:
                                break
                            case Constants.FlickrResponseKeys.FocalLength:
                                break
                            case Constants.FlickrResponseKeys.Lens:
                                break
                            default:
                                break // do not do anything otherwise
                            }
                        }
                        
                    }.catch { error in
                        print("Error in getting photo EXIF")
                        print(error)
                    }
                    
                    
                }
            }
    }
    
    func getEXIFInfo(photoID: String) -> Promise<(Int, JSON)> {
        return Promise { solve, reject in
            
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
                        solve((Int(photoID)!, json))
                    } else {
                        reject(response.result.error!)
                    }
            }
        }
    }
}
