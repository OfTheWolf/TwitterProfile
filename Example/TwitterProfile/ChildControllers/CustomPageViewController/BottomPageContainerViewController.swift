//
//  BottomPageContainerViewController.swift
//  TwitterProfile
//
//  Created by OfTheWolf on 08/18/2019.
//  Copyright (c) 2019 OfTheWolf. All rights reserved.
//

import UIKit
import TwitterProfile

class BottomPageContainerViewController: UIViewController, PagerAwareProtocol{

    @IBOutlet weak var pagerContainer: UIView!
    @IBOutlet weak var collectionView: UICollectionView!

    weak var pageDelegate: BottomPageDelegate?
    
    var currentViewController: UIViewController?{
        return pager?.currentViewController
    }
    
    var pagerTabHeight: CGFloat?{
        return 44
    }
    
    var pager: BottomPageViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? UIPageViewController{
            pager = vc as? BottomPageViewController
            pager!.pageDelegate = pageDelegate
        }
    }
}

extension BottomPageContainerViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        return cell
    }
}
