//
//  ThemeViewCell.swift
//  Hubble
//
//  Created by vimrus on 2017/10/1.
//  Copyright © 2017年 Hubble. All rights reserved.
//

import UIKit
import SnapKit

class ThemeViewCell: UITableViewCell {
    var daySelector: ThemeSelector!
    var warmSelector: ThemeSelector!
    var darkSelector: ThemeSelector!

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func setup() {
        selectionStyle = .none

        daySelector = ThemeSelector(color: fixColor(0xFEFEFE))
        daySelector.selectTheme = {
            self.daySelector.selected = true
            self.warmSelector.selected = false
            self.darkSelector.selected = false
            HubStyle.sharedInstance.theme = .day
        }

        warmSelector = ThemeSelector(color: fixColor(0xFEFEFE))
        warmSelector.selectTheme = {
            self.daySelector.selected = false
            self.warmSelector.selected = true
            self.darkSelector.selected = false
            HubStyle.sharedInstance.theme = .warm
        }

        darkSelector = ThemeSelector(color: fixColor(0x555555))
        darkSelector.selectTheme = {
            self.daySelector.selected = false
            self.warmSelector.selected = false
            self.darkSelector.selected = true
            HubStyle.sharedInstance.theme = .dark
        }

        switch HubStyle.sharedInstance.theme {
        case .warm:
            warmSelector.selected = true
        case .dark:
            darkSelector.selected = true
        default:
            daySelector.selected = true

        }

        contentView.addSubview(daySelector)
        contentView.addSubview(warmSelector)
        contentView.addSubview(darkSelector)

        warmSelector.snp.makeConstraints{ (make) -> Void in
            make.width.height.equalTo(50)
            make.centerX.equalTo(contentView)
            make.centerY.equalTo(contentView)
        }

        daySelector.snp.makeConstraints{ (make) -> Void in
            make.width.height.equalTo(warmSelector)
            make.right.equalTo(warmSelector.snp.left).offset(-15)
            make.centerY.equalTo(contentView)
        }

        darkSelector.snp.makeConstraints{ (make) -> Void in
            make.width.height.equalTo(warmSelector)
            make.left.equalTo(warmSelector.snp.right).offset(15)
            make.centerY.equalTo(contentView)
        }
    }
}
