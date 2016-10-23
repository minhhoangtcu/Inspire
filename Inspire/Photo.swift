//
//  Photo.swift
//  Inspire
//
//  Created by Minh Hoang on 9/24/16.
//  Copyright © 2016 Minh Hoang. All rights reserved.
//

import Foundation
import UIKit

class Photo {
    
    // info about the image
    private var url: String!
    var image: UIImage!
    var title: String!
    var id: String!
    
    // info about the camera
    var cameraModel: String?
    var cameraMake: String?
    var camera: String? {
        get {
            return (cameraModel != nil && cameraMake != nil) ? "\(cameraMake) \(cameraModel)" : nil
        }
    }
    var lensModel: String?
    
    // info about the picture
    var shuttleSpeed: String?
    var aperature: String?
    var focalLength: String?
    var iso: String?
    
    init(id: String, url: String, title: String) {
        self.id = id
        self.url = url
        self.title = title
        requestImage()
    }
    
    func requestImage() {
        let imageURL = URL(string: url)
        do {
            let imageData = try Data(contentsOf: imageURL!)
            self.image = UIImage(data: imageData)
        } catch {
            print("Photo: \(title) does not exist at \(imageURL)")
        }
    }
}
