//
//  LabelCell.swift
//  TwitterProfile_Example
//
//  Created by ugur on 25.08.2019.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit

class LabelCell: UITableViewCell {
    
    static var reuseId = "labelCell"
    
    @IBOutlet weak var label: UILabel!
    
    var contentText: String?{
        didSet{
            label.text = contentText
        }
    }
}
