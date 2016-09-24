//
//  PicturesGetter.swift
//  Inspire
//
//  Created by Minh Hoang on 9/23/16.
//  Copyright © 2016 Minh Hoang. All rights reserved.
//

import Foundation

class PictureGetter {
    
    var urls: [String]!
    
    init() {
        urls = []
    }
    
    func getUrls() {
        
        let methodParametersForSearch = [
        Constants.FlickrParameterKeys.Method: Constants.FlickrParameterValues.MethodSearch,
        Constants.FlickrParameterKeys.APIKey: Constants.FlickrParameterValues.APIKey,
        Constants.FlickrParameterKeys.Tags: Constants.FlickrParameterValues.TagsForPortrait,
        Constants.FlickrParameterKeys.Extras: Constants.FlickrParameterValues.MediumURL,
        Constants.FlickrParameterKeys.NumberOfImages: Constants.FlickrParameterValues.TenImage,
        Constants.FlickrParameterKeys.Format: Constants.FlickrParameterValues.Format,
        Constants.FlickrParameterKeys.NoJSONCallback: Constants.FlickrParameterValues.DisableJSONCallback
        ]
        
        // create url and request
        let session = URLSession.shared
        let urlString = Constants.Flickr.APIBaseURL + getUsableParamsForQuery(parameters: methodParametersForSearch)
        let url = URL(string: urlString)!
        let request = URLRequest(url: url)
        
        // create network request
        let task = session.dataTask(with: request) { (data, response, error) in
            
            // check for error
            guard (error == nil) else {
                print("PicturesGetter: Error with data task request!")
                return
            }
            
            // check for good response
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200, statusCode <= 299 else {
                print("PicturesGetter: Status Code is not 2xx!")
                return
            }
            
            guard let data = data else {
                print("PicturesGetter: No data!")
                return
            }
            
            // parsing data
            let parsedResult: NSDictionary!
            do {
                parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? NSDictionary
            } catch {
                print("PicturesGetter: Could not parse the data as JSON: '\(data)'")
                return
            }
            
            // check error from Flickr API
            guard let stat = parsedResult[Constants.FlickrResponseKeys.Status] as? String, stat == Constants.FlickrResponseValues.OKStatus else {
                print("PicturesGetter: Flickr API returned error code: \(parsedResult)")
                return
            }
            
            // get array of photos
            guard let photosDictionary = parsedResult[Constants.FlickrResponseKeys.Photos] as? [String:AnyObject],
                let photos = photosDictionary[Constants.FlickrResponseKeys.Photo] as? [[String:AnyObject]] else {
                    print("PicturesGetter: Cannot find keys '\(Constants.FlickrResponseKeys.Photos)' and '\(Constants.FlickrResponseKeys.Photo)' in \(parsedResult)")
                    return
            }
            
            var tempURLS: [String] = []
            
            // get all the info of the photo
            for photo in photos {
                
                // TODO: Create a Photo class and store the data into it instead
                guard let url = photo[Constants.FlickrParameterValues.MediumURL] as? String else {
                    print("PicturesGetter: Cannot find keys '\(Constants.FlickrParameterValues.MediumURL) in \(photo)")
                    return
                }
                
                tempURLS.append(url)
            }
            
            DispatchQueue.main.async {
                self.urls = tempURLS
                print(self.urls)
            }
        }
        
        // start the task
        task.resume()
    }

    /**
        Take in a dictionary of keys and values array and convert it into query safe string
    */
    private func getUsableParamsForQuery(parameters: [String: String]) -> String {
        if parameters.isEmpty {
            return ""
        }
        
        var pairs = [String]()
        for (key, value) in parameters {
            // replacing all characters not in the specified set with percent encoded characters.
            let escapedValue = value.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
            pairs.append(key + "=" + "\(escapedValue!)")
        }
        
        return "?\(pairs.joined(separator: "&"))"
    }
}
