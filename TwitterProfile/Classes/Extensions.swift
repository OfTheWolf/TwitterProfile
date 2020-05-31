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
        let vc = ContainerViewController()
        vc.dataSource = dataSource
        vc.delegate = delegate
        self.add(vc)
        vc.view.pinEdges(to: self.view)
    }
}

public extension UIScrollView{
    func donotAdjustContentInset(){
        if #available(iOS 11.0, *) {
            self.contentInsetAdjustmentBehavior = .never
        }
    }
}

internal extension UIView{
    func constraint(to view: UIView, attribute: NSLayoutConstraint.Attribute, secondAttribute: NSLayoutConstraint.Attribute,  inset: CGFloat = 0){
        self.translatesAutoresizingMaskIntoConstraints = false
        let c = NSLayoutConstraint(item: self,
                                   attribute: attribute,
                                   relatedBy: .equal,
                                   toItem: view,
                                   attribute: secondAttribute,
                                   multiplier: 1,
                                   constant: inset)
        c.isActive = true
    }
    
    func constraint(_ anchor: NSLayoutDimension, constant: CGFloat){
        self.translatesAutoresizingMaskIntoConstraints = false
        anchor.constraint(equalToConstant: constant).isActive = true
    }
    
    func pinEdges(to view: UIView, insets: UIEdgeInsets = .zero){
        self.translatesAutoresizingMaskIntoConstraints = false
        
        let top = NSLayoutConstraint(item: self,
                                     attribute: .top,
                                     relatedBy: .equal,
                                     toItem: view,
                                     attribute: .top,
                                     multiplier: 1,
                                     constant: insets.top)
        
        let bottom = NSLayoutConstraint(item: self,
                                        attribute: .bottom,
                                        relatedBy: .equal,
                                        toItem: view,
                                        attribute: .bottom,
                                        multiplier: 1,
                                        constant: insets.bottom)
        
        let leading = NSLayoutConstraint(item: self,
                                        attribute: .leading,
                                        relatedBy: .equal,
                                        toItem: view,
                                        attribute: .leading,
                                        multiplier: 1,
                                        constant: insets.left)
        
        let trailing = NSLayoutConstraint(item: self,
                                        attribute: .trailing,
                                        relatedBy: .equal,
                                        toItem: view,
                                        attribute: .trailing,
                                        multiplier: 1,
                                        constant: insets.right)
        top.isActive = true
        bottom.isActive = true
        leading.isActive = true
        trailing.isActive = true
    }
}
