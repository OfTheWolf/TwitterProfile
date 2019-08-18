//
//  Extensions.swift
//  TwitterProfile
//
//  Created by OfTheWolf on 08/18/2019.
//  Copyright (c) 2019 OfTheWolf. All rights reserved.
//

import UIKit

public extension UIViewController {
    func add(_ child: UIViewController, to: UIView? = nil, frame: CGRect? = nil) {
        addChild(child)
        if let frame = frame {
            child.view.frame = frame
        }
        if let toView = to{
            toView.addSubview(child.view)
        }else{
            view.addSubview(child.view)
        }
        child.didMove(toParent: self)
    }
    
    func remove() {
        // Just to be safe, we check that this view controller
        // is actually added to a parent before removing it.
        guard parent != nil else {
            return
        }
        
        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }
    
    var bottomInset: CGFloat{
        if #available(iOS 11.0, *) {
            return view.safeAreaInsets.bottom
        } else {
            return bottomLayoutGuide.length
        }
    }
    
    var topInset: CGFloat{
        if #available(iOS 11.0, *) {
            return view.safeAreaInsets.top
        } else {
            return topLayoutGuide.length
        }
    }
    
    func tp_configure(with dataSource: TPDataSource, delegate: TPProgressDelegate? = nil) {
        let vc = MasterViewController()
        vc.dataSource = dataSource
        vc.delegate = delegate
        self.add(vc)
    }
}

public extension UIScrollView{
    func donotAdjustContentInset(){
        if #available(iOS 11.0, *) {
            self.contentInsetAdjustmentBehavior = .never
        }
    }
}
