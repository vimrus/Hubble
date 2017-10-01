//
//  MeViewCell.swift
//  Hubble
//
//  Created by vimrus on 2017/10/1.
//  Copyright © 2017年 Hubble. All rights reserved.
//

import UIKit

class MeViewCell: UITableViewCell {
    var titleLabel: UILabel = {
        let label = UILabel()
        label.font = fixFont(16)
        label.theme_textColor = globalTitleColorPicker
        return label
    }()

    var detailLabel: UILabel = {
        let label = UILabel()
        label.font = fixFont(13)
        label.theme_textColor = globalTextColorPicker
        return label
    }()

    var detailMarkImageView: UIImageView = {
        let imageview = UIImageView(image: UIImage(named: "arrow_right"))
        imageview.contentMode = .center
        return imageview
    }()

    var separator: UIImageView = UIImageView()

    var detailMarkHidden: Bool {
        get {
            return self.detailMarkImageView.isHidden
        }

        set {
            if self.detailMarkImageView.isHidden == newValue {
                return ;
            }

            self.detailMarkImageView.isHidden = newValue
            if newValue {
                self.detailMarkImageView.snp.remakeConstraints { (make) -> Void in
                    make.width.height.equalTo(0)
                    make.centerY.equalTo(self.contentView)
                    make.right.equalTo(self.contentView).offset(-12)
                }
            } else {
                self.detailMarkImageView.snp.remakeConstraints { (make) -> Void in
                    make.width.height.equalTo(20)
                    make.centerY.equalTo(self.contentView)
                    make.right.equalTo(self.contentView).offset(-12)
                }
            }
        }
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setup()
        separator.image = {
            let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
            UIGraphicsBeginImageContext(rect.size)
            let context = UIGraphicsGetCurrentContext()
            context?.setFillColor(fixColor(0xDDDDDD).cgColor)
            context?.fill(rect)

            let theImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return theImage!
        }()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func setup() {
        let selectedBackgroundView = UIView()
        self.selectedBackgroundView = selectedBackgroundView

        self.contentView.addSubview(self.titleLabel)
        self.contentView.addSubview(self.detailMarkImageView)
        self.contentView.addSubview(self.detailLabel)
        self.contentView.addSubview(self.separator)

        self.titleLabel.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(self.contentView).offset(12)
            make.centerY.equalTo(self.contentView)
        }

        self.detailMarkImageView.snp.remakeConstraints { (make) -> Void in
            make.height.equalTo(24)
            make.width.equalTo(14)
            make.centerY.equalTo(self.contentView)
            make.right.equalTo(self.contentView).offset(-12)
        }

        self.detailLabel.snp.makeConstraints { (make) -> Void in
            make.right.equalTo(self.detailMarkImageView.snp.left).offset(-5)
            make.centerY.equalTo(self.contentView)
        }

        self.separator.snp.makeConstraints { (make) -> Void in
            make.left.right.bottom.equalTo(self.contentView)
            make.height.equalTo(1.0 / UIScreen.main.scale)
        }
    }
}
