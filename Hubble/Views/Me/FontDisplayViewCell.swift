//
//  FontDisplayViewCell.swift
//  Hubble
//
//  Created by vimrus on 2017/10/1.
//  Copyright © 2017年 Hubble. All rights reserved.
//

import UIKit
import SnapKit

class FontDisplayViewCell: MeViewCell {

    override func setup() {
        super.setup()
        detailMarkHidden = true
        clipsToBounds = true
        titleLabel.text = "哈勃空间望远镜是以天文学家爱德温·哈勃为名，在地球轨道的望远镜。1990年发射之后，已经成为天文史上最重要的仪器。\n\nThe Hubble Space Telescope is a space telescope that was launched into low Earth orbit in 1990 and remains in operation."
        titleLabel.numberOfLines = 0
        titleLabel.preferredMaxLayoutWidth = UIScreen.main.bounds.size.width - 24
        titleLabel.baselineAdjustment = .none

        titleLabel.snp.remakeConstraints { (make) -> Void in
            make.left.top.equalTo(self.contentView).offset(12)
            make.right.equalTo(self.contentView).offset(-12)
            make.height.lessThanOrEqualTo(self.contentView).offset(-12)
        }

        NotificationCenter.default.addObserver(self, selector: #selector(fontScale), name: .fontScale, object: nil)
        fontScale()
    }

    @objc func fontScale() {
        self.titleLabel.font = HubScaleFont(18)
    }
}
