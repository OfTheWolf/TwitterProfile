//
//  Extensions.swift
//  TwitterProfile_Example
//
//  Created by ugur on 10.09.2019.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit

extension UIView{
    func bordered(lineWidth: CGFloat, strokeColor: UIColor = UIColor.background){
        let path = UIBezierPath.init(roundedRect: self.bounds, cornerRadius: self.frame.width/2)
        let borderLayer = CAShapeLayer()
        borderLayer.lineWidth = lineWidth
        borderLayer.strokeColor = strokeColor.cgColor
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.frame = self.bounds
        borderLayer.path = path.cgPath
        self.layer.addSublayer(borderLayer)
    }
    
    func rounded(insets: UIEdgeInsets = .zero){
        let path = UIBezierPath.init(roundedRect: self.bounds.inset(by: insets), cornerRadius: self.frame.width/2)
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.bounds
        maskLayer.path = path.cgPath
        self.layer.mask = maskLayer
    }
}

extension UIColor{
    static let background: UIColor  = {
        if #available(iOS 13.0, *) {
            return UIColor.systemBackground
        } else {
            return UIColor.white
        }
    }()
}
