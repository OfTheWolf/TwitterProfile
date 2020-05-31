//
//  ContainerViewController.swift
//  TwitterProfile
//
//  Created by OfTheWolf on 08/18/2019.
//  Copyright (c) 2019 OfTheWolf. All rights reserved.
//

import UIKit

class ContainerViewController : UIViewController, UIScrollViewDelegate {
    var containerScrollView: UIScrollView! //contains headerVC + bottomVC
    var overlayScrollView: UIScrollView! //handles whole scroll logic
    var panViews: [Int: UIView] = [:] // bottom view(s)/scrollView(s)

    var currentIndex: Int = 0
    
    var pagerTabHeight: CGFloat = 44
    
    weak var dataSource: TPDataSource!
    weak var delegate: TPProgressDelegate?
    
    var headerView: UIView!
    var bottomView: UIView!

    var contentOffsets: [Int: CGFloat] = [:]
    
    override func loadView() {
        containerScrollView = UIScrollView()
        containerScrollView.scrollsToTop = false
        containerScrollView.showsVerticalScrollIndicator = false
        
        
        let f = UIScreen.main.bounds
//        containerScrollView.frame = CGRect(x: f.minX, y: f.minY, width: f.width, height: f.height)
        containerScrollView.contentSize = CGSize.init(width: f.width, height: f.height + dataSource.headerHeight().upperBound)
        
        overlayScrollView = UIScrollView()
        overlayScrollView.showsVerticalScrollIndicator = false
        overlayScrollView.backgroundColor = UIColor.clear

//        overlayScrollView.frame = CGRect(x: f.minX, y: f.minY, width: f.width, height: f.height)
        overlayScrollView.contentSize = self.containerScrollView.contentSize
        
        let view = UIView()
        view.addSubview(overlayScrollView)
        view.addSubview(containerScrollView)
        view.frame = UIScreen.main.bounds
        self.view = view
        
        containerScrollView.addGestureRecognizer(overlayScrollView.panGestureRecognizer)
        overlayScrollView.donotAdjustContentInset()
        containerScrollView.donotAdjustContentInset()
        overlayScrollView.layer.zPosition = 999
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let headerVC = dataSource.headerViewController()
        //        add(headerVC, to: containerScrollView, frame: CGRect(x: f.minX, y: 0, width: f.width, height: dataSource.headerHeight().upperBound))
        add(headerVC, to: containerScrollView)
        headerView = headerVC.view
        let bottomVC = dataSource.bottomViewController()
        bottomView = bottomVC.view
        bottomVC.pageDelegate = self
        self.pagerTabHeight = bottomVC.pagerTabHeight ?? 44

//        add(bottomVC, to: containerScrollView, frame: CGRect(x: f.minX, y: dataSource.headerHeight().upperBound, width: f.width, height: f.height))
        add(bottomVC, to: containerScrollView)
        if let vc = bottomVC.currentViewController{
            self.panViews[currentIndex] = vc.panView()
            if let scrollView = self.panViews[currentIndex] as? UIScrollView{
                scrollView.panGestureRecognizer.require(toFail: self.overlayScrollView.panGestureRecognizer)
                scrollView.donotAdjustContentInset()
                }
        }

        
        overlayScrollView.snap(to: self.view)
        containerScrollView.snap(to: self.view)
        headerView.constraint(to: containerScrollView, attribute: .leading, secondAttribute: .leading)
        headerView.constraint(to: containerScrollView, attribute: .trailing, secondAttribute: .trailing)
        headerView.constraint(to: containerScrollView, attribute: .top, secondAttribute: .top)
        headerView.constraint(to: containerScrollView, attribute: .width, secondAttribute: .width)
        
        bottomView.constraint(to: containerScrollView, attribute: .leading, secondAttribute: .leading)
        bottomView.constraint(to: containerScrollView, attribute: .trailing, secondAttribute: .trailing)
        bottomView.constraint(to: containerScrollView, attribute: .bottom, secondAttribute: .bottom)
        bottomView.constraint(to: headerView, attribute: .top, secondAttribute: .bottom)
        bottomView.constraint(to: containerScrollView, attribute: .width, secondAttribute: .width)
        bottomView.constraint(to: containerScrollView,
                              attribute: .height,
                              secondAttribute: .height)

        if let scrollView = self.panViews[currentIndex] as? UIScrollView{
            let bottomHeight = max(scrollView.contentSize.height, self.view.frame.height - dataSource.headerHeight().lowerBound)
            self.overlayScrollView.contentSize = CGSize.init(width: scrollView.contentSize.width, height: bottomHeight + headerView.frame.height + pagerTabHeight + bottomInset)
            scrollView.addObserver(self, forKeyPath: #keyPath(UIScrollView.contentSize), options: .new, context: nil)
        }else if let view = self.panViews[currentIndex]{
            let bottomHeight = self.view.frame.height - dataSource.headerHeight().lowerBound
            self.overlayScrollView.contentSize = CGSize.init(width: view.frame.width, height: bottomHeight + headerView.frame.height + pagerTabHeight + bottomInset)
        }
        
        delegate?.tp_scrollViewDidLoad(overlayScrollView)

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        overlayScrollView.delegate = self
    }
    
    deinit {
        self.panViews.forEach({ (arg0) in
            let (_, value) = arg0
            if let scrollView = value as? UIScrollView{
                scrollView.removeObserver(self, forKeyPath: #keyPath(UIScrollView.contentSize))
            }
        })
    }
    
    func getContentSize(for bottomView: UIView) -> CGSize{
        if let scroll = bottomView as? UIScrollView{
            let bottomHeight = max(scroll.contentSize.height, self.view.frame.height - dataSource.headerHeight().lowerBound - pagerTabHeight - bottomInset)
            return CGSize.init(width: scroll.contentSize.width, height: bottomHeight + headerView.frame.height + pagerTabHeight + bottomInset)
        }else{
            let bottomHeight = self.view.frame.height - dataSource.headerHeight().lowerBound - pagerTabHeight
            return CGSize.init(width: bottomView.frame.width, height: bottomHeight + headerView.frame.height + pagerTabHeight + bottomInset)
        }
        
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let obj = object as? UIScrollView, let scroll = self.panViews[currentIndex] as? UIScrollView {
            if obj == scroll && keyPath == #keyPath(UIScrollView.contentSize) {
                self.overlayScrollView.contentSize = getContentSize(for: scroll)
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        contentOffsets[currentIndex] = scrollView.contentOffset.y
        let topHeight = bottomView.frame.minY - dataSource.headerHeight().lowerBound
        
        if scrollView.contentOffset.y < topHeight{
            self.containerScrollView.contentOffset.y = scrollView.contentOffset.y
            self.panViews.forEach({ (arg0) in
                let (_, value) = arg0
                (value as? UIScrollView)?.contentOffset.y = 0
            })
            contentOffsets.removeAll()
        }else{
            self.containerScrollView.contentOffset.y = topHeight
            (self.panViews[currentIndex] as? UIScrollView)?.contentOffset.y = scrollView.contentOffset.y - self.containerScrollView.contentOffset.y
            
        }

        
        headerView.translatesAutoresizingMaskIntoConstraints = true
        if scrollView.contentOffset.y < 0{
            headerView.frame = CGRect(x: headerView.frame.minX,
                                      y: min(topHeight, scrollView.contentOffset.y),
                                      width: headerView.frame.width,
                                      height: max(dataSource.headerHeight().lowerBound, bottomView.frame.minY + -scrollView.contentOffset.y))

        }else{
            headerView.frame = CGRect(x: headerView.frame.minX,
                                      y: 0,
                                      width: headerView.frame.width,
                                      height: bottomView.frame.minY)
        }
        
        let progress = self.containerScrollView.contentOffset.y / topHeight
        self.delegate?.tp_scrollView(self.containerScrollView, didUpdate: progress)
    }
}

//MARK: BottomPageDelegate
extension ContainerViewController : BottomPageDelegate {

    func tp_pageViewController(_ currentViewController: UIViewController?, didSelectPageAt index: Int) {
        currentIndex = index

        if let offset = contentOffsets[index]{
            self.overlayScrollView.contentOffset.y = offset
        }else{
            self.overlayScrollView.contentOffset.y = self.containerScrollView.contentOffset.y
        }
        
        if let vc = currentViewController, self.panViews[currentIndex] == nil{
            self.panViews[currentIndex] = vc.panView()
            if let scrollView = self.panViews[currentIndex] as? UIScrollView{
                scrollView.panGestureRecognizer.require(toFail: self.overlayScrollView.panGestureRecognizer)
                scrollView.donotAdjustContentInset()
            }
        }
        
        if let scrollView = self.panViews[currentIndex] as? UIScrollView{
            self.overlayScrollView.contentSize = getContentSize(for: scrollView)
            scrollView.addObserver(self, forKeyPath: #keyPath(UIScrollView.contentSize), options: .new, context: nil)
        }else if let bottomView = self.panViews[currentIndex]{
            self.overlayScrollView.contentSize = getContentSize(for: bottomView)
        }
    }

}
