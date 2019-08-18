//
//  BottomPageViewController.swift
//  TwitterProfile
//
//  Created by OfTheWolf on 08/18/2019.
//  Copyright (c) 2019 OfTheWolf. All rights reserved.
//

import UIKit
import TwitterProfile

class BottomPageViewController: UIPageViewController, PagerAwareProtocol{
    
//    MARK: PagerAwareProtocol
    var pageDelegate: BottomPageDelegate?
    
    var currentViewController: UIViewController?{
        return viewControllers?.first
    }
    
    var pagerTabHeight: CGFloat?{
        return 44
    }
    
//    Properties
    fileprivate lazy var vcs: [UIViewController] = {
        var vcList: [UIViewController] = []
        let counts = [2, 20, 1, 50]
        for i in 0..<4{
            let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BottomViewController") as! BottomViewController
            vc.pageIndex = i
            vc.count = counts[i]
            vcList.append(vc)
        }
        vcList.append(EmptyViewController())
        return vcList
    }()
    
//    MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        delegate = self
        
        setViewControllers([vcs.first!], direction: .forward, animated: true, completion: nil)

    }
    
}

//  MARK: UIPageViewControllerDataSource
extension BottomPageViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        if !completed { return }
        
        guard let viewController = pageViewController.viewControllers?.first,
            let index = vcs.firstIndex(of: viewController) else {
            return
        }
        
        pageDelegate?.tp_pageViewController(pageViewController.viewControllers?.first, didSelectPageAt: index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = vcs.firstIndex(of: viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        // User is on the first view controller and swiped left to loop to
        // the last view controller.
        guard previousIndex >= 0 else {
            
            return vcs.last
        }
        
        guard vcs.count > previousIndex else {
            return nil
        }
        
        
        
        return vcs[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = vcs.firstIndex(of: viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = vcs.count
        
        // User is on the last view controller and swiped right to loop to
        // the first view controller.
        guard orderedViewControllersCount != nextIndex else {
            return vcs.first
        }
        
        guard orderedViewControllersCount > nextIndex else {
            return nil
        }
                        
        return vcs[nextIndex]
    }
    
}
