//
//  TitleImageViewCell.swift
//  Hubble
//
//  Created by vimrus on 2017/10/1.
//  Copyright © 2017年 Hubble. All rights reserved.
//

import UIKit
import SnapKit
import Kingfisher

class TitleImageViewCell: UITableViewCell {
    var titleLabel: UILabel = {
        let label = UILabel()
        label.font = fixFont(20)
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.theme_textColor = globalTitleColorPicker
        label.numberOfLines = 0
        return label
    }()

    var summaryLabel: UILabel = {
        let label = UILabel()
        label.lineBreakMode = .byTruncatingTail
        label.font = fixFont(16)
        label.theme_textColor = globalTextColorPicker
        return label
    }()

    var imgView: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFit
        return img
    }()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        setup()
    }

    func setup() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(summaryLabel)
        contentView.addSubview(imgView)

        titleLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(contentView).offset(15)
            make.left.equalTo(contentView).offset(10)
            make.right.equalTo(-100)
        }

        imgView.snp.makeConstraints{ (make) -> Void in
            make.left.equalTo(titleLabel.snp.right).offset(10)
            make.top.equalTo(titleLabel)
            make.right.equalTo(-10)
            make.height.equalTo(70)
        }

        summaryLabel.snp.makeConstraints{ (make) -> Void in
            make.left.right.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.height.equalTo(16)
            make.bottom.equalTo(contentView).offset(-25)
        }

    }

    func bind(_ article: Article) {
        titleLabel.text = article.title
        summaryLabel.text = article.summary

        let optionsInfo = [KingfisherOptionsInfoItem.targetCache(KingfisherManager.shared.cache)]
        if let url = URL(string: article.image) {
            imgView.kf.setImage(with: url,
                                placeholder: UIImage(named:"star"),
                                options: optionsInfo,
                                progressBlock: nil,
                                completionHandler: nil)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
