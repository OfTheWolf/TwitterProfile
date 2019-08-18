//
//  ViewController.swift
//  TwitterProfile
//
//  Created by OfTheWolf on 08/18/2019.
//  Copyright (c) 2019 OfTheWolf. All rights reserved.
//

import UIKit
import TwitterProfile

class ViewController : UIViewController, UIScrollViewDelegate, TPDataSource, TPProgressDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //implement data source to configure tp controller with header and bottom child viewControllers
        //observe header scroll progress with TPProgressDelegate
        self.tp_configure(with: self, delegate: self)
        
    }
    
    //MARK: TPDataSource
    func headerViewController() -> UIViewController {
        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HeaderViewController")
        return vc
    }
    
    func bottomViewController() -> UIViewController & PagerAwareProtocol {
        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "XLPagerTabStripExampleViewController") as! XLPagerTabStripExampleViewController
        //        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BottomPageContainerViewController") as! BottomPageContainerViewController
        return vc
    }
    
    //headerHeight in the closed range [minValue, maxValue], i.e. minValue...maxValue
    func headerHeight() -> ClosedRange<CGFloat> {
        return topInset...300
    }
    
    //MARK: TPProgressDelegate
    func tp_scrollView(_ scrollView: UIScrollView, didUpdate progress: CGFloat) {
//        print("log: \(progress)")
    }
}


