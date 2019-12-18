//
//  PagerAwareProtocol.swift
//  TwitterProfile
//
//  Created by OfTheWolf on 08/18/2019.
//  Copyright (c) 2019 OfTheWolf. All rights reserved.
//

import UIKit

public protocol PagerAwareProtocol: class {
    var pageDelegate: BottomPageDelegate? {get set}
    var currentViewController: UIViewController? {get}
    var pagerTabHeight: CGFloat? {get}
}
