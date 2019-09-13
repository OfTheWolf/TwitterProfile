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
    var bannerInitialHeight: CGFloat!
    var stickyBanner = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
        userImageView.layer.zPosition = 2
        bannerImageView.layer.zPosition = 1
        
        userImageView.rounded()
        userImageView.bordered(lineWidth: 8)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if bannerInitialCenterY == nil{
            bannerInitialCenterY = bannerImageView.center.y
        }
        
        if bannerInitialHeight == nil{
            bannerInitialHeight = bannerImageView.frame.height
        }
        
       
    }
    
    func adjustBannerView(with progress: CGFloat, headerHeight: ClosedRange<CGFloat>){
        let y = progress * (headerHeight.upperBound - headerHeight.lowerBound)
        let topLimit = bannerInitialHeight - headerHeight.lowerBound
        if y > topLimit{
            bannerImageView.center.y = bannerInitialCenterY + y - topLimit
            if stickyBanner{
                self.stickyBanner = false
                self.userImageView.layer.zPosition = 0
            }
        }else{
            bannerImageView.center.y = bannerInitialCenterY
            let scale = min(1, (1-progress*1.3))
            let t = CGAffineTransform(scaleX: scale, y: scale)
            userImageView.transform = t.translatedBy(x: 0, y: userImageView.frame.height*(1 - scale))
            
            if !stickyBanner{
                self.stickyBanner = true
                self.userImageView.layer.zPosition = 2
            }
        }
    }
}
