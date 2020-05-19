//
//  HeaderViewController.swift
//  TwitterProfile
//
//  Created by OfTheWolf on 08/18/2019.
//  Copyright (c) 2019 OfTheWolf. All rights reserved.
//

import UIKit

class HeaderViewController: UIViewController {
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var covermageView: UIImageView!
    @IBOutlet weak var titleView: UIScrollView!
    @IBOutlet weak var visualEffectView: UIVisualEffectView!

    var animator = UIViewPropertyAnimator(duration: 0.5, curve: .linear, animations: nil)

    var titleInitialCenterY: CGFloat!
    var covernitialCenterY: CGFloat!
    var covernitialHeight: CGFloat!
    var stickyCover = true
    
    var viewDidLayoutOnce = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        animator.addAnimations {
            self.visualEffectView.effect = UIBlurEffect(style: .regular)
        }
        
        userImageView.layer.zPosition = 2
        covermageView.layer.zPosition = 1
        visualEffectView.layer.zPosition = 1.1
        titleView.layer.zPosition = 1.2

        visualEffectView.effect = nil

        userImageView.rounded()
        userImageView.bordered(lineWidth: 8)
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        titleView.setContentOffset(CGPoint(x: 0, y: -titleView.frame.height), animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        if !viewDidLayoutOnce{
            covernitialCenterY = covermageView.center.y
            covernitialHeight = covermageView.frame.height
            titleInitialCenterY = titleView.center.y
        }

    }
    
    func update(with progress: CGFloat, headerHeight: ClosedRange<CGFloat>){

        let y = progress * (headerHeight.upperBound - headerHeight.lowerBound)
                
        let h =  (headerHeight.upperBound - headerHeight.lowerBound)
        let hh = userNameLabel.frame.minY + titleView.frame.height + headerHeight.lowerBound - 5
        let titleOffset = max(-titleView.frame.height, min(0, -hh + h * progress))
        titleView.contentOffset.y = titleOffset

        if progress < 0 {
            animator.fractionComplete = abs(min(0, progress))
        }else{
            animator.fractionComplete = (1 - abs(titleOffset/(titleView.frame.height)))
        }
        
        let topLimit = covernitialHeight - headerHeight.lowerBound
        if y > topLimit{
            covermageView.center.y = covernitialCenterY + y - topLimit
            if stickyCover{
                self.stickyCover = false
                self.userImageView.layer.zPosition = 0
            }
        }else{
            covermageView.center.y = covernitialCenterY
            let scale = min(1, (1-progress*1.3))
            let t = CGAffineTransform(scaleX: scale, y: scale)
            userImageView.transform = t.translatedBy(x: 0, y: userImageView.frame.height*(1 - scale))
            
            if !stickyCover{
                self.stickyCover = true
                self.userImageView.layer.zPosition = 2
            }
        }
        visualEffectView.center.y = covermageView.center.y
        titleView.center.y = covermageView.frame.maxY - titleView.frame.height/2
    }
}
