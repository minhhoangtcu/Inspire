//
//  DoubleCatagoryCell.swift
//  Inspire
//
//  Created by Minh Hoang on 9/23/16.
//  Copyright © 2016 Minh Hoang. All rights reserved.
//

import UIKit

class DoubleCatagoryCell: UITableViewCell {
    
    @IBOutlet weak var leftImageView: UIImageView!
    @IBOutlet weak var rightImageView: UIImageView!
    @IBOutlet weak var leftDescriptionLabel: UILabel!
    @IBOutlet weak var rightDescriptionLabel: UILabel!
    
    var leftCatagoryImage: UIImage! {
        set {
            leftImageView.image = newValue
        }
        get {
            return leftImageView.image
        }
    }
    
    var rightCatagoryImage: UIImage! {
        set {
            rightImageView.image = newValue
        }
        get {
            return rightImageView.image
        }
    }
    
    var leftCatagoryLabel: String! {
        set {
            leftDescriptionLabel.text = newValue
        }
        get {
            return leftDescriptionLabel.text
        }
    }
    
    var rightCatagoryLabel: String! {
        set {
            rightDescriptionLabel.text = newValue
        }
        get {
            return rightDescriptionLabel.text
        }
    }
    
}
