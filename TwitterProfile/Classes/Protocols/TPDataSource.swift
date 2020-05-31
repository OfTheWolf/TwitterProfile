//
//  TPDataSource.swift
//  TwitterProfile
//
//  Created by OfTheWolf on 08/18/2019.
//  Copyright (c) 2019 OfTheWolf. All rights reserved.
//

import UIKit

public protocol TPDataSource: class {
    func headerViewController() -> UIViewController
    func bottomViewController() -> UIViewController & PagerAwareProtocol
    func minHeaderHeight() -> CGFloat //stop scrolling headerView at this point
}
