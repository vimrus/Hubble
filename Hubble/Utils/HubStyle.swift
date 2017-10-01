//
//  HubStyle.swift
//  Hubble
//
//  Created by vimrus on 2017/10/1.
//  Copyright © 2017年 Hubble. All rights reserved.
//

import UIKit
import SwiftTheme

let globalBackgroundColorPicker: ThemeColorPicker = ["#fff", "#3f3f3f"]
let globalTextColorPicker: ThemeColorPicker = ["#333", "#969696"]
let globalTitleColorPicker: ThemeColorPicker = ["#333", "#c8c8c8"]
let globalSpaceColorPicker: ThemeColorPicker = ["#f5f5f5", "#fdfdfd"]

enum Theme {
    case day
    case warm
    case dark
}

class HubStyle: NSObject {
    static let sharedInstance = HubStyle()

    fileprivate var _fontScale: Float = 1.0
    fileprivate var _theme: Theme = .day
    fileprivate var _readMode: String = "1.0"

    var fontScale: Float {
        get {
            let fontScale = UserDefaults.standard.float(forKey: "fontScale")
            if fontScale > 0 {
                return fontScale
            } else {
                return _fontScale
            }
        }

        set {
            if _fontScale != newValue {
                UserDefaults.standard.set(newValue, forKey: "fontScale")
                _fontScale = newValue
            }
        }
    }

    var theme: Theme {
        get {
            if let theme = UserDefaults.standard.string(forKey: "theme") {
                switch theme {
                case "warm":
                    return .warm
                case "dark":
                    return .dark
                default:
                    return .day
                }
            } else {
                return _theme
            }
        }

        set {
            if _theme != newValue {
                UserDefaults.standard.set("\(newValue)", forKey: "theme")
                _theme = newValue
            }
        }
    }
}
