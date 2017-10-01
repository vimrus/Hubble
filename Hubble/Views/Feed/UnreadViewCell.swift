//
//  UnreadViewCell.swift
//  Hubble
//
//  Created by vimrus on 2017/10/1.
//  Copyright © 2017年 Hubble. All rights reserved.
//

import UIKit
import SnapKit

class UnreadViewCell: UITableViewCell {
    var titleLabel: UILabel = {
        let label = UILabel()
        label.font = fixFont(20)
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.numberOfLines = 0
        label.theme_textColor = globalTitleColorPicker
        return label
    }()
    var summaryLabel: UILabel = {
        let label = UILabel()
        label.lineBreakMode = .byTruncatingTail
        label.font = fixFont(16)
        label.textColor = fixColor(0x545454)
        label.theme_textColor = globalTextColorPicker
        return label
    }()
    var logoView: UIImageView = {
        let logo = UIImageView()
        logo.contentMode = .scaleAspectFit
        return logo
    }()
    var nameLabel: UILabel = {
        let label = UILabel()
        label.font = fixFont(15)
        label.theme_textColor = globalTextColorPicker
        return label
    }()
    var timeLabel: UILabel = {
        let label = UILabel()
        label.font = fixFont(15)
        label.theme_textColor = globalTextColorPicker
        return label
    }()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        setup()
    }

    func setup() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(summaryLabel)
        contentView.addSubview(logoView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(timeLabel)

        titleLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(contentView).offset(15)
            make.left.equalTo(contentView).offset(10)
            make.right.equalTo(-10)
        }

        summaryLabel.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(titleLabel.snp.left)
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.height.equalTo(16)
            make.right.equalTo(-10)
        }

        logoView.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(titleLabel.snp.left)
            make.top.equalTo(summaryLabel.snp.bottom).offset(10)
            make.width.height.equalTo(18)
            make.bottom.equalTo(contentView).offset(-10)
        }

        nameLabel.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(logoView.snp.right).offset(10)
            make.top.equalTo(logoView)
            make.height.equalTo(18)
        }

        timeLabel.snp.makeConstraints { (make) -> Void in
            make.right.equalTo(-10)
            make.top.equalTo(logoView)
            make.height.equalTo(18)
        }
    }

    func bind(_ article: Article, _ plugin: Plugin) {
        titleLabel.text = article.title
        summaryLabel.text = article.summary

        let logo = PluginManager().getLogoPath(owner: plugin.owner, repo: plugin.repo)
        let data = try? Data(contentsOf: logo)

        let image = UIImage(data: data!)
        logoView.image = image?.makeImageCornerRadius(radius: UIScreen.main.bounds.size.width/10)

        nameLabel.text = plugin.name
        timeLabel.text = TimeInterval(article.addtime).timeAgo()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
