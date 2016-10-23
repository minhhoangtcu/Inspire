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
                    
                    // Secondly, for each photo, we request its info.
                    self.getEXIFInfo(photoID: Int(temp.id)!)
                }
        }
    }
    
    func getEXIFInfo(photoID: Int) {
        
            let methodParametersForGetEXIF = [
                Constants.FlickrParameterKeys.Method: Constants.FlickrParameterValues.MethodGetEXIF,
                Constants.FlickrParameterKeys.APIKey: Constants.FlickrParameterValues.APIKey,
                Constants.FlickrParameterKeys.PhotoID: String(photoID),
                Constants.FlickrParameterKeys.Format: Constants.FlickrParameterValues.Format,
                Constants.FlickrParameterKeys.NoJSONCallback: Constants.FlickrParameterValues.DisableJSONCallback
            ]
            
            Alamofire.request(Constants.Flickr.APIBaseURL, parameters: methodParametersForGetEXIF)
                .responseJSON { response in
                    
                    guard let value = response.result.value else {
                        print("Cannot convert to EXIF")
                        print(response.result.error)
                        return
                    }

                    let json = JSON(value)
                    
                    guard let photo: Photo = self.photos[photoID] else {
                        print("No such photo id: \(photoID) in the database")
                        return
                    }
                    
                    let exifs = json[Constants.FlickrResponseKeys.Photo][Constants.FlickrResponseKeys.EXIF].arrayValue
                    
                    for exif in exifs {
                        
                        let content = exif[Constants.FlickrResponseKeys.Raw][Constants.FlickrResponseKeys.Content].stringValue
//                        print("TAG: \(exif[Constants.FlickrResponseKeys.Tag].stringValue) \t \(content)")
                        
                        switch (exif[Constants.FlickrResponseKeys.Tag].stringValue) {
                        case Constants.FlickrResponseKeys.Make:
                            photo.cameraMake = content
                            break
                        case Constants.FlickrResponseKeys.Model:
                            photo.cameraModel = content
                            break
                        case Constants.FlickrResponseKeys.ShuttleSpeed:
                            photo.shuttleSpeed = content
                            break
                        case Constants.FlickrResponseKeys.Aperture:
                            photo.aperature = content
                            break
                        case Constants.FlickrResponseKeys.ISO:
                            photo.iso = content
                            break
                        case Constants.FlickrResponseKeys.FocalLength:
                            photo.focalLength = content
                            break
                        case Constants.FlickrResponseKeys.Lens:
                            photo.lensModel = content
                            break
                        default:
                            break // do not do anything otherwise
                        }
                    }
            }
    }
}
