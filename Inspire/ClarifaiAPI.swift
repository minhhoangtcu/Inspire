//
//  ClarifaiAPI.swift
//  Inspire
//
//  Created by Minh Hoang on 10/23/16.
//  Copyright © 2016 Minh Hoang. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class ClarifaiAPI {
    
    private var clientID: String
    private var clientSecret: String
    private var accessToken: String?
    
    struct Config {
        static let BaseURL: String = "https://api.clarifai.com/v1"
        static let AppID: String = "com.clarifai.Clarifai.AppID"
        static let AccessToken: String = "com.clarifai.Clarifai.AccessToken"
        static let AccessTokenExpiration: String = "com.clarifai.Clarifai.AccessTokenExpiration"
        static let MinTokenLifetime: TimeInterval = 60
    }
    
    init(clientID: String, clientSecret: String) {
        self.clientID = clientID
        self.clientSecret = clientSecret
        
        loadAccessToken()
    }
    
    // MARK: Access Token Management
    
    private func loadAccessToken() {
        let params = [
            "grant_type": "client_credentials",
            "client_id": self.clientID,
            "client_secret": self.clientSecret
        ]
        
        Alamofire.request(Config.BaseURL.appending("/token"), method: .post, parameters: params)
            .validate()
            .responseJSON() { response in
                switch response.result {
                case .success(_):
                    let json = JSON(response.result.value)
                    let tokenResponse = json["access_token"].stringValue
                    self.accessToken = tokenResponse
                    print(tokenResponse)
                case .failure(let error):
                    print("Cannot get Access Token")
                    print(error)
                }
        }
    }
    
    
}
