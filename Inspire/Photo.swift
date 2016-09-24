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
    
    // info about the camera
    var cameraModel: String?
    var lensModel: String?
    
    // info about the picture
    var shuttleSpeed: String?
    var aperature: String?
    var focalLength: String?
    var iso: String?
    
    init(url: String, title: String) {
        self.url = url
        self.title = title
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
