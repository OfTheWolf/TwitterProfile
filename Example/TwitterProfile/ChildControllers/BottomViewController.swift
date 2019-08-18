//
//  BottomViewController.swift
//  TwitterProfile
//
//  Created by OfTheWolf on 08/18/2019.
//  Copyright (c) 2019 OfTheWolf. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class BottomViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var pageIndex: Int = 0
    
    var count = 0

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath) as! LabelCell
//        cell.contentText = "page \(pageIndex) row at index \(indexPath.row)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("didselect at index \(indexPath.row)")
    }
}

class LabelCell: UITableViewCell {
    
    static var reuseId = "labelCell"
    
    @IBOutlet weak var label: UILabel!
    
    var contentText: String?{
        didSet{
            label.text = contentText
        }
    }
    
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        selectionStyle = .none
//        contentView.addSubview(label)
//        backgroundColor = .orange
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
}



class EmptyViewController: UIViewController {
    
    let label = UILabel()
    
    override func loadView() {
        
        let view = UIView()
        view.backgroundColor = .white
        
        label.text = "Empty View"
        label.textAlignment = .center
        label.textColor = .black
        label.backgroundColor = .lightGray
        view.addSubview(label)
        self.view = view
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        label.frame = CGRect.init(x: 0, y: 0, width: view.bounds.width, height: 200)
    }
}

extension EmptyViewController: IndicatorInfoProvider{
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo.init(title: "Tab 1")
    }
}

extension BottomViewController: IndicatorInfoProvider{
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo.init(title: "Tab \(pageIndex)")
    }
}
