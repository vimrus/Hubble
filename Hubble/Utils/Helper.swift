//
//  Helper.swift
//  Hubble
//
//  Created by vimrus on 2017/10/1.
//  Copyright © 2017年 Hubble. All rights reserved.
//

import UIKit

func fixFont(_ fontSize: CGFloat) -> UIFont {
    return UIFont.systemFont(ofSize: fontSize);
}

func HubScaleFont(_ fontSize: CGFloat) -> UIFont{
    return fixFont(fontSize * CGFloat(HubStyle.sharedInstance.fontScale))
}

func fixColor(_ rgb: UInt) -> UIColor {
    let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
    let green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
    let blue = CGFloat(rgb & 0x0000FF) / 255.0
    let alpha = CGFloat(1.0)
    return UIColor(red: red, green: green, blue: blue, alpha: alpha)
}
