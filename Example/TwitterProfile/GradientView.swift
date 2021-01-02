//
//  GradientView.swift
//  TwitterProfile_Example
//
//  Created by ugur on 31.05.2020.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit

class GradientView: UIView {
    override open class var layerClass: AnyClass {
        return CAGradientLayer.classForCoder()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let gradientLayer = self.layer as! CAGradientLayer
        var color = UIColor.white
        
        if #available(iOS 13.0, *) {
            color = .systemBackground
        }
        
        gradientLayer.colors = [
            color.withAlphaComponent(0).cgColor,
            color.cgColor
        ]
        gradientLayer.locations = [0, 0.9]
        backgroundColor = UIColor.clear
    }
}
