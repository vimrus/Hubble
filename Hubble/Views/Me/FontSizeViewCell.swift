//
//  FontSizeViewCell.swift
//  Hubble
//
//  Created by vimrus on 2017/10/1.
//  Copyright © 2017年 Hubble. All rights reserved.
//

import UIKit
import SnapKit

class FontSizeViewCell: UITableViewCell {
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier);
        self.setup();
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func setup() {
        self.selectionStyle = .none

        let leftLabel = UILabel()
        leftLabel.font = fixFont(14 * 0.8)
        leftLabel.text = "A"
        leftLabel.textAlignment = .center
        self.contentView.addSubview(leftLabel)
        leftLabel.snp.makeConstraints{ (make) -> Void in
            make.centerY.equalTo(self.contentView)
            make.width.height.equalTo(30)
            make.left.equalTo(self.contentView).offset(12)
        }

        let rightLabel = UILabel()
        rightLabel.font = fixFont(14 * 1.6)
        rightLabel.text = "A"
        rightLabel.textAlignment = .center
        self.contentView.addSubview(rightLabel)
        rightLabel.snp.makeConstraints{ (make) -> Void in
            make.centerY.equalTo(self.contentView)
            make.width.height.equalTo(30)
            make.right.equalTo(self.contentView).offset(-12)
        }

        let slider = HubSlider()
        slider.valueChanged = { (fontSize) in
            let size = fontSize * 0.05 + 0.8
            if HubStyle.sharedInstance.fontScale != size {
                HubStyle.sharedInstance.fontScale = size
                NotificationCenter.post(name: .fontScale)
            }
        }

        self.contentView.addSubview(slider)
        slider.snp.makeConstraints{ (make) -> Void in
            make.left.equalTo(leftLabel.snp.right)
            make.right.equalTo(rightLabel.snp.left)
            make.centerY.equalTo(self.contentView)
        }

        let topSeparator = UIImageView()
        self.contentView.addSubview(topSeparator)
        topSeparator.snp.makeConstraints{ (make) -> Void in
            make.left.right.top.equalTo(self.contentView)
            make.height.equalTo(1)
        }

        let bottomSeparator = UIImageView()
        self.contentView.addSubview(bottomSeparator)
        bottomSeparator.snp.makeConstraints{ (make) -> Void in
            make.left.right.bottom.equalTo(self.contentView)
            make.height.equalTo(1)
        }
    }
}
