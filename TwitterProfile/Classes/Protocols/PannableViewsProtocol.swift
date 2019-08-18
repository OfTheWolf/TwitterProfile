//
//  PannableViewsProtocol.swift
//  TwitterProfile
//
//  Created by OfTheWolf on 08/18/2019.
//  Copyright (c) 2019 OfTheWolf. All rights reserved.
//

import UIKit

protocol PannableViewsProtocol {
    func panView() -> UIView
}

extension PannableViewsProtocol where Self: UIViewController{
    func panView() -> UIView{
        if let scroll = self.view.subviews.first(where: {$0 is UIScrollView}){
            return scroll
        }else{
            return self.view
        }
    }
}

extension UIViewController: PannableViewsProtocol{}
