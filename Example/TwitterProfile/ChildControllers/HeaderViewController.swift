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
    @IBOutlet weak var bannerImageView: UIImageView!
    
    var bannerInitialCenterY: CGFloat!
    var stickyBanner = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userImageView.layer.cornerRadius = userImageView.frame.width / 2
        userImageView.layer.masksToBounds = true
        userImageView.layer.borderColor = UIColor.white.cgColor
        userImageView.layer.borderWidth = 4
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if bannerInitialCenterY == nil{
            bannerInitialCenterY = bannerImageView.center.y
        }
    }
    
    func adjustBannerView(with progress: CGFloat, headerHeight: ClosedRange<CGFloat>){
        
        let y = progress * (headerHeight.upperBound - headerHeight.lowerBound)
        
        if y > headerHeight.lowerBound{
            bannerImageView.center.y = bannerInitialCenterY + y - headerHeight.lowerBound
            if stickyBanner{
                self.stickyBanner = false
                self.view.bringSubviewToFront(bannerImageView)
            }
        }else{
            let scale = min(1, (1-progress))
            let t = CGAffineTransform(scaleX: scale, y: scale)
            userImageView.transform = t.translatedBy(x: 0, y: userImageView.frame.height*(1 - scale))
            
            if !stickyBanner{
                self.stickyBanner = true
                self.view.sendSubviewToBack(bannerImageView)
            }
        }
    }
}
