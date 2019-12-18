//
//  BottomPageDelegate.swift
//  TwitterProfile
//
//  Created by OfTheWolf on 08/18/2019.
//  Copyright (c) 2019 OfTheWolf. All rights reserved.
//

import UIKit

public protocol BottomPageDelegate: class {
    func tp_pageViewController(_ currentViewController: UIViewController?, didSelectPageAt index: Int)
}
