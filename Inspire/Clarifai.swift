//import UIKit
//import Alamofire
//import SwiftyJSON
//
///** Provides access to the Clarifai image recognition services */
//class Clarifai {
// CREDIT: https://github.com/jodyheavener/Clarifai-iOS
// CONVERTED TO SWIFT 3 BY ME
//    
//    var clientID: String
//    var clientSecret: String
//    var accessToken: String?
//    var accessTokenExpiration: NSDate?
//
//    struct Config {
//        static let BaseURL: String = "https://api.clarifai.com/v1"
//        static let AppID: String = "com.clarifai.Clarifai.AppID"
//        static let AccessToken: String = "com.clarifai.Clarifai.AccessToken"
//        static let AccessTokenExpiration: String = "com.clarifai.Clarifai.AccessTokenExpiration"
//        static let MinTokenLifetime: TimeInterval = 60
//    }
//    
//    init(clientID: String, clientSecret: String) {
//        self.clientID = clientID
//        self.clientSecret = clientSecret
//        
//        self.loadAccessToken()
//    }
//    
//    // MARK: Access Token Management
//    
//    private func loadAccessToken() {
//        let userDefaults: UserDefaults = UserDefaults.standard
//        
//        if self.clientID != userDefaults.string(forKey: Config.AppID) {
//            self.invalidateAccessToken()
//        } else {
//            self.accessToken = userDefaults.string(forKey: Config.AccessToken)!
//            self.accessTokenExpiration = userDefaults.object(forKey: Config.AccessTokenExpiration)! as? NSDate
//        }
//    }
//    
//    private func saveAccessToken(response: AccessTokenResponse) {
//        if let accessToken = response.accessToken, let expiresIn = response.expiresIn {
//            let userDefaults: UserDefaults = UserDefaults.standard
//            let expiration: NSDate = NSDate(timeIntervalSinceNow: expiresIn)
//            
//            userDefaults.setValue(self.clientID, forKey: Config.AppID)
//            userDefaults.setValue(accessToken, forKey: Config.AccessToken)
//            userDefaults.setValue(expiration, forKey: Config.AccessTokenExpiration)
//            userDefaults.synchronize()
//            
//            self.accessToken = accessToken
//            self.accessTokenExpiration = expiration
//        }
//    }
//    
//    private func invalidateAccessToken() {
//        let userDefaults: UserDefaults = UserDefaults.standard
//        
//        userDefaults.removeObject(forKey: Config.AppID)
//        userDefaults.removeObject(forKey: Config.AccessToken)
//        userDefaults.removeObject(forKey: Config.AccessTokenExpiration)
//        userDefaults.synchronize()
//        
//        self.accessToken = nil
//        self.accessTokenExpiration = nil
//    }
//    
//    private func validateAccessToken(handler: @escaping (_ error: NSError?) -> Void) {
//        if self.accessToken != nil && self.accessTokenExpiration != nil && (self.accessTokenExpiration?.timeIntervalSinceNow)! > Config.MinTokenLifetime {
//            handler(nil)
//        } else {
//            let params: Dictionary<String, AnyObject> = [
//                "grant_type": "client_credentials" as AnyObject,
//                "client_id": self.clientID as AnyObject,
//                "client_secret": self.clientSecret as AnyObject
//            ]
//            
//            Alamofire.request(Config.BaseURL.appending("/token"), method: .post, parameters: params)
//                .validate()
//                .responseJSON() { response in
//                    switch response.result {
//                    case .success(let result):
//                        let tokenResponse = AccessTokenResponse(responseJSON: result as! NSDictionary)
//                        self.saveAccessToken(response: tokenResponse)
//                    case .failure(let error):
//                        handler(error as NSError?)
//                    }
//                }
//        }
//    }
//    
//    private class AccessTokenResponse: NSObject {
//        var accessToken: String?
//        var expiresIn: TimeInterval?
//        
//        init(responseJSON: NSDictionary) {
//            self.accessToken = responseJSON["access_token"] as? String
//            self.expiresIn = max(responseJSON["expires_in"] as! Double, Clarifai.Config.MinTokenLifetime)
//        }
//    }
//    
//    // MARK: Recognition Processing
//    
//    /** All available Clarifai recognition types */
//    enum RecognitionType: String {
//        case Tag = "tag"
//        case Color = "color"
//    }
//    
//    /** All available Models to apply to Clarifai Tag recognizition */
//    enum TagModel: String {
//        case General = "general-v1.3"
//        case NSFW = "nsfw-v1.0"
//        case Weddings = "weddings-v1.0"
//        case Travel = "travel-v1.0"
//        case Food = "food-items-v0.1"
//    }
//    
//    /** All available ways to upload data to Clarifai for recognizition */
//    private enum DataInputType {
//        case Image, URL
//    }
//    
//    /** Recognize components of one or more images via UIImage */
//    func recognize(type: RecognitionType = .Tag, image: Array<UIImage>, model: TagModel = .General, completion: @escaping (Response?, NSError?) -> Void) {
//        self.process(type: type, dataInputType: .Image, data: image, model: model, completion: completion)
//    }
//    
//    /** Recognize components of one or more images via string URL */
//    func recognize(type: RecognitionType = .Tag, url: Array<String>, model: TagModel = .General, completion: @escaping (Response?, NSError?) -> Void) {
//        self.process(type: type, dataInputType: .URL, data: url as Array<AnyObject>, model: model, completion: completion)
//    }
//
//    private func process(type: RecognitionType, dataInputType: DataInputType, data: Array<AnyObject>, model: TagModel, completion: @escaping (Response?, NSError?) -> Void) {
//        self.validateAccessToken { (error) in
//            if error != nil {
//                return completion(nil, error)
//            }
//            
//            let multiop = data.count > 1
//            let endpoint = multiop ? "/multiop" : "/\(type.rawValue)"
//            
//            Alamofire.upload(multipartFormData: { multipartFormData in
//                if multiop {
//                    multipartFormData.append(type.rawValue.data(using: String.Encoding.utf8)!, withName: "op")
//                }
//                
//                switch dataInputType {
//                case .URL:
//                    for url in data as! Array<String> {
//                        multipartFormData.append(url.data(using: String.Encoding.utf8)!, withName: "url")
//                    }
//                case .Image:
//                    for image in data as! Array<UIImage> {
//                        // We are reducing the size and quality of the input image so it will
//                        //   consume less data when transfering over to Clarifai. This has very
//                        //   little effect on the processing.
//                        let size = CGSize(width: 320, height: 320 * image.size.height / image.size.width)
//                        
//                        UIGraphicsBeginImageContext(size)
//                        image.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
//                        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
//                        UIGraphicsEndImageContext()
//                        
//                        multipartFormData.append(UIImageJPEGRepresentation(scaledImage!, 0.9)!, withName: "encoded_image", fileName: "image.jpg", mimeType: "image/jpeg")
//                    }
//                }
//                
//                if type == .Tag {
//                    multipartFormData.append(model.rawValue.data(using: String.Encoding.utf8)!, withName: "model")
//                }
//            },
//            to: Config.BaseURL.appending(endpoint),
//            method: .post,
//            headers: ["Authorization": "Bearer " + self.accessToken!],
//            encodingCompletion: { (encodingResult) in
//                switch encodingResult {
//                case .success(let upload, _, _):
//                    upload.validate().responseJSON { response in
//                        switch response.result {
//                        case .success(let result):
//                            let results = Response(type: type, data: result as! Dictionary<NSObject, AnyObject>)
//                            completion(results, nil)
//                        case .failure(let error):
//                            completion(nil, error as NSError?)
//                        }
//                    }
//                case .failure(let encodingError):
//                    print(encodingError)
//                }
//            })
//        }
//    }
//    
//    class RecognitionTag: NSObject {
//        var classLabel: String
//        var probability: Float
//        var conceptId: String
//        
//        init(classLabel label: String, probability prob: Float, conceptId conId: String) {
//            classLabel = label
//            probability = prob
//            conceptId = conId
//        }
//    }
//    
//    class RecognitionColor: NSObject {
//        var density: Float
//        var hex: String
//        var w3c: Dictionary<String, String>
//        
//        init(colorData: Dictionary<String, AnyObject>) {
//            density = colorData["density"] as! Float
//            hex = colorData["hex"] as! String
//            w3c = [
//                "hex": colorData["w3c"]!["hex"] as! String,
//                "name": colorData["w3c"]!["name"] as! String
//            ]
//        }
//        
//        // Thanks to:
//        // https://gist.github.com/arshad/de147c42d7b3063ef7bc#gistcomment-1733974
//        func toColor() -> UIColor {
//            var colorString: String = hex.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines).uppercased()
//            colorString = (colorString as NSString).substring(from: 1)
//            
//            let red: String = (colorString as NSString).substring(to: 2)
//            let green = ((colorString as NSString).substring(from: 2) as NSString).substring(to: 2)
//            let blue = ((colorString as NSString).substring(from: 4) as NSString).substring(to: 2)
//            
//            var r: CUnsignedInt = 0, g: CUnsignedInt = 0, b: CUnsignedInt = 0;
//            Scanner(string: red).scanHexInt32(&r)
//            Scanner(string: green).scanHexInt32(&g)
//            Scanner(string: blue).scanHexInt32(&b)
//            
//            return UIColor(red: CGFloat(r) / CGFloat(255.0), green: CGFloat(g) / CGFloat(255.0), blue: CGFloat(b) / CGFloat(255.0), alpha: CGFloat(1))
//        }
//    }
//    
//    class Result: NSObject {
//        var recognitionType: RecognitionType
//        var docId: String
//        var tags: Array<RecognitionTag>?
//        var colors: Array<RecognitionColor>?
//        
//        init(type: RecognitionType, data: Dictionary<String, AnyObject>) {
//            self.recognitionType = type
//            self.docId = data["docid_str"] as! String
//            
//            switch type {
//            case .Tag:
//                tags = []
//                
//                // We have to deconstruct the tag results here and not in RecognitionTag
//                //   because the returned JSON groups classes, probabilities, and conceptIds
//                //   seperately.
//                let classLabels = (data["result"] as! JSON)["tag"]["classes"].arrayValue // String
//                let probabilities = (data["result"] as! JSON)["tag"]["probs"].arrayValue // Float
//                let conceptIds = (data["result"] as! JSON)["tag"]["concept_ids"].arrayValue // String
//                
//                for (index, label) in classLabels {
//                    let probability = probabilities[index]
//                    let conceptId = conceptIds[index]
//                    
//                    tags?.append(RecognitionTag(classLabel: label, probability: probability, conceptId: conceptId))
//                }
//            case .Color:
//                colors = []
//                
//                // We are able to pass all the data to RecognitionColor and deconstruct it there
//                //   since the returned JSON contains colors in self-contained objects
//                for colorResult in data["colors"]! as! Array<Dictionary<NSObject, AnyObject>> {
//                    colors?.append(RecognitionColor(colorData: colorResult))
//                }
//            }
//        }
//    }
//    
//    class Response: NSObject {
//        var statusCode: String
//        var statusMessage: String
//        var recognitionType: RecognitionType
//        var results: Array<Result> = []
//        
//        init(type: RecognitionType, data: Dictionary<String, AnyObject>) {
//            self.recognitionType = type
//            self.statusCode = data["status_code"] as! String
//            self.statusMessage = data["status_msg"] as! String
//            
//            for resultData in data["results"] as! Array<Dictionary<NSObject, AnyObject>> {
//                let result = Result(type: type, data: resultData)
//                results.append(result)
//            }
//        }
//    }
//    
//}
