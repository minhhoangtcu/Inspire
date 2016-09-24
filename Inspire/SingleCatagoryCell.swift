//
//  SingleCatagoryCell.swift
//  Inspire
//
//  Created by Minh Hoang on 9/23/16.
//  Copyright © 2016 Minh Hoang. All rights reserved.
//

import UIKit

class SingleCatagoryCell: UITableViewCell {
    
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var singleImageView: UIImageView!

    var catagoryImage: UIImage! {
        set {
            singleImageView.image = newValue
        }
        get {
            return singleImageView.image
        }
    }
    
    var catagoryLabel: String! {
        set {
            descriptionLabel.text = newValue
        }
        get {
            return descriptionLabel.text
        }
    }
    
}
