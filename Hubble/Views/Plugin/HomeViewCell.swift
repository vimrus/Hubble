//
//  HomeViewCell.swift
//  Hubble
//
//  Created by vimrus on 2017/10/1.
//  Copyright © 2017年 Hubble. All rights reserved.
//

import UIKit
import SnapKit

class HomeViewCell: UITableViewCell {
    var plugin: Plugin!

    var logoView: UIImageView = {
        let logo = UIImageView()
        logo.contentMode = .scaleAspectFit
        return logo
    }()

    var nameLabel: UILabel = {
        let label = UILabel()
        label.lineBreakMode = .byClipping
        label.font = fixFont(18)
        label.theme_textColor = globalTitleColorPicker
        return label
    }()

    var feedLabel: UILabel = {
        let label = UILabel()
        label.lineBreakMode = .byTruncatingTail
        label.font = fixFont(14)
        label.theme_textColor = globalTextColorPicker
        return label
    }()

    var timeLabel: UILabel = {
        let label = UILabel()
        label.lineBreakMode = .byTruncatingTail
        label.font = fixFont(12)
        label.theme_textColor = globalTextColorPicker
        return label
    }()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setup() {
        contentView.addSubview(logoView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(timeLabel)
        contentView.addSubview(feedLabel)

        logoView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(contentView).offset(15)
            make.left.equalTo(contentView).offset(10)
            make.width.height.equalTo(50)
            make.bottom.equalTo(contentView).offset(-10)
        }

        nameLabel.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(logoView.snp.right).offset(20)
            make.right.equalTo(-70)
            make.top.equalTo(logoView).offset(4)
        }

        timeLabel.snp.makeConstraints { (make) -> Void in
            make.right.equalTo(-10)
            make.top.equalTo(logoView).offset(4)
        }

        feedLabel.snp.makeConstraints{ (make) -> Void in
            make.left.equalTo(nameLabel.snp.left)
            make.right.equalTo(nameLabel)
            make.top.equalTo(nameLabel.snp.bottom).offset(10)
        }
    }

    func bind(_ plugin: Plugin) {
        self.plugin = plugin

        let logo = PluginManager().getLogoPath(owner: plugin.owner, repo: plugin.repo)
        if let data = try? Data(contentsOf: logo) {
            let image = UIImage(data: data)
            logoView.image = image?.makeImageCornerRadius(radius: 25)
        }

        nameLabel.text = plugin.name

        if let article = ArticleModel.getLast(owner: plugin.owner, repo: plugin.repo) {
            feedLabel.text = article.title
            timeLabel.text = TimeInterval(article.addtime).timeAgo()
        }
    }
}
