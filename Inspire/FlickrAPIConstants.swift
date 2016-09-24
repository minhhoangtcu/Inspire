//
//  FlickrAPIConstants.swift
//  Inspire
//
//  Created by Minh Hoang on 9/23/16.
//  Copyright © 2016 Minh Hoang. All rights reserved.
//

struct Constants {
    
    // Check out: https://www.flickr.com/services/api/explore/flickr.photos.search
    // Also: https://www.flickr.com/services/api/explore/flickr.photos.getExif for photoID: 28512674940 (my image)
    
    // MARK: Flickr
    struct Flickr {
        static let APIBaseURL = "https://api.flickr.com/services/rest/"
    }
    
    struct FlickrParameterKeys {
        static let Method = "method"
        static let APIKey = "api_key"
        
        // Mark: for getting images with certain tags
        static let Tags = "tags"
        static let Extras = "extras"
        static let Format = "format"
        static let NumberOfImages = "per_page"
        static let NoJSONCallback = "nojsoncallback"
        
        // Mark: for getting Camera's info for certain images
        static let PhotoID = "photo_id"
        
    }
    
    struct FlickrParameterValues {
        static let APIKey = "e69aa948f3ae0d66f11239b92b5af5f9" // TODO: Change it and hide the **** out of this key
        
        // Mark: for getting images with certain tags
        static let MethodSearch = "flickr.photos.search"
        static let TagsForPortrait = "portrait"
        static let Format = "json"
        static let DisableJSONCallback = "1"
        static let MediumURL = "url_m"
    }
    
    struct FlickrResponseKeys {
        static let Status = "stat"
        static let Photo = "photo"
        
        // Mark: for getting images with certain tags
        static let Photos = "photos"
        static let Title = "title"
        static let PhotoID = "id"
        static let MediumURL = "url_m"
        
        // Mark: for getting Camera's info for certain images
        static let EXIF = "exif"
        static let Raw = "raw"
        static let Clean = "clean"
        static let tagspace = "tagspace"
        static let Tag = "tag"
        static let Content = "_content"
        static let Model = "Model"
        static let ShuttleSpeed = "ExposureTime"
        static let Aperture = "FNumber"
        static let ISO = "ISO"
        static let FocalLength = "FocalLength"
        static let Lens = "LensModel"
    }
    
    struct FlickrResponseValues {
        static let OKStatus = "ok"
    }
}
