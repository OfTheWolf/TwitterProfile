//
//  HeaderViewController.swift
//  TwitterProfile
//
//  Created by OfTheWolf on 08/18/2019.
//  Copyright (c) 2019 OfTheWolf. All rights reserved.
//

import UIKit

class HeaderViewController: UIViewController {
    
    @IBOutlet weak var coverImageHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var covermageView: UIImageView!
    @IBOutlet weak var titleView: UIScrollView!
    @IBOutlet weak var visualEffectView: UIVisualEffectView!
    @IBOutlet weak var gradientView: UIView!

    private var animator: UIViewPropertyAnimator?

    var titleInitialCenterY: CGFloat!
    var covernitialCenterY: CGFloat!
    var covernitialHeight: CGFloat!
    var stickyCover = true
    
    var viewDidLayoutOnce = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        animator = blurAnimator()

        covermageView.layer.zPosition = 0.1
        visualEffectView.layer.zPosition = covermageView.layer.zPosition + 0.1
        titleView.layer.zPosition = visualEffectView.layer.zPosition + 0.1
        userImageView.layer.zPosition = titleView.layer.zPosition

        userImageView.rounded()
        userImageView.bordered(lineWidth: 8)
        
        descriptionLabel.numberOfLines = 2
        
        NotificationCenter.default.addObserver(self, selector: #selector(appWillEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(appDidEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addBlurAnimation()
        update(with: lastProgress, minHeaderHeight: lastMinHeaderHeight)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        resetAnimator()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        if !viewDidLayoutOnce{
            viewDidLayoutOnce = true
            covernitialCenterY = covermageView.center.y
            covernitialHeight = covermageView.frame.height
            titleInitialCenterY = titleView.center.y
            titleView.setContentOffset(CGPoint(x: 0, y: -titleView.frame.height), animated: true)
        }

    }
    
    private func blurAnimator() -> UIViewPropertyAnimator{
        visualEffectView.effect = nil
        return UIViewPropertyAnimator(duration: 0.5, curve: .linear)
    }
    
    private func addBlurAnimation(){
        animator?.addAnimations {[weak visualEffectView] in
            visualEffectView?.effect = UIBlurEffect(style: .regular)
        }
        animator?.stopAnimation(true)
    }
        
    private func resetAnimator(){
        if (animator?.state == .active){
            animator?.stopAnimation(false)
        }
        if animator?.state == .stopped {
            animator?.finishAnimation(at: .current)
        }
        visualEffectView.effect = nil
    }
    
    @objc
    func appWillEnterForeground(){
        addBlurAnimation()
        update(with: lastProgress, minHeaderHeight: lastMinHeaderHeight)
    }
    
    @objc
    func appDidEnterBackground(){
        resetAnimator()
    }
    
    @IBAction func readMoreAction(_ sender: UIButton) {
        UIView.animate(withDuration: 0.3) {
            self.descriptionLabel.numberOfLines = 0
            self.gradientView.isHidden = true
        }
    }
    
    var lastProgress: CGFloat = .zero
    var lastMinHeaderHeight: CGFloat = .zero

    func update(with progress: CGFloat, minHeaderHeight: CGFloat){
        lastProgress = progress
        lastMinHeaderHeight = minHeaderHeight
        
        let y = progress * (view.frame.height - minHeaderHeight)
        
        guard covernitialHeight != nil else {
            return
        }
        
        coverImageHeightConstraint.constant = max(covernitialHeight, covernitialHeight - y)
                
        let titleOffset = max(min(0, (userNameLabel.convert(userNameLabel.bounds, to: nil).minY - minHeaderHeight)), -titleView.frame.height)
        titleView.contentOffset.y = -titleOffset-titleView.frame.height
        
        if progress < 0 {
            animator?.fractionComplete = abs(min(0, progress))
        }else{
            animator?.fractionComplete = (abs((titleOffset)/(titleView.frame.height)))
        }
                
        let topLimit = covernitialHeight - minHeaderHeight
        if y > topLimit{
            covermageView.center.y = covernitialCenterY + y - topLimit
            if stickyCover{
                self.stickyCover = false
                userImageView.layer.zPosition = 0
            }
        }else{
            covermageView.center.y = covernitialCenterY
            let scale = min(1, (1-progress*1.3))
            let t = CGAffineTransform(scaleX: scale, y: scale)
            userImageView.transform = t.translatedBy(x: 0, y: userImageView.frame.height*(1 - scale))
            
            if !stickyCover{
                self.stickyCover = true
                userImageView.layer.zPosition = titleView.layer.zPosition
            }
        }
        visualEffectView.center.y = covermageView.center.y
        titleView.center.y = covermageView.frame.maxY - titleView.frame.height/2
    }
}
