//
//  TagsGetter.swift
//  Inspire
//
//  Created by Minh Hoang on 10/23/16.
//  Copyright © 2016 Minh Hoang. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class TagsGetter {
    
    
    
    func getTags(photo: Photo) -> [String] {
        
        var result: [String] = []
        
        let clarifai = ClarifaiAPI(clientID: Constants.Clarifai.clientID, clientSecret: Constants.Clarifai.clientSecret)
        
        return result
    }
    
}

