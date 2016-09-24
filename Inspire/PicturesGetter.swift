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
    
    func getUrls() {
        
        
        
    }

    /**
        Take in a dictionary of keys and values array and convert it into query safe string
    */
    private func getUsableParamsForQuery(parameters: [String:AnyObject]) -> String {
        if parameters.isEmpty {
            return ""
        }
        
        var pairs = [String]()
        for (key, value) in parameters {
            // replacing all characters not in the specified set with percent encoded characters.
            let escapedValue = "\(value)".addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
            pairs.append(key + "=" + "\(escapedValue!)")
        }
        
        return "?\(pairs.joined(separator: "&"))"
    }
}
