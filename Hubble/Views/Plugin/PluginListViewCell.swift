//
//  PluginListViewCell.swift
//  Hubble
//
//  Created by vimrus on 2017/10/1.
//  Copyright © 2017年 Hubble. All rights reserved.
//

import UIKit
import SnapKit
import Kingfisher

class PluginListViewCell: UITableViewCell, InstallButtonDelegate, DownloadDelegate {
    var plugin: Plugin!

    var logoView = UIImageView()

    var nameLabel = UILabel()

    var descLabel = UILabel()

    var installButton = InstallButton()

    var isCancelled = false

    var progress: CGFloat = 0

    var viewController: PluginListViewController!

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setup() {
        addSubview(logoView)
        addSubview(nameLabel)
        addSubview(descLabel)
        addSubview(installButton)

        logoView.snp.makeConstraints { (make) -> Void in
            make.left.top.equalTo(self.contentView).offset(15)
            make.width.height.equalTo(60)
        }
        logoView.contentMode = .scaleAspectFit

        nameLabel.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(self.logoView.snp.right).offset(20)
            make.top.equalTo(self.logoView).offset(4)
        }
        nameLabel.font = fixFont(18)

        descLabel.snp.makeConstraints{ (make) -> Void in
            make.left.equalTo(self.nameLabel.snp.left)
            make.top.equalTo(self.nameLabel.snp.bottom).offset(10)
        }
        descLabel.font = fixFont(15)
        descLabel.textColor = fixColor(0x545454)

        installButton.snp.makeConstraints {(make) -> Void in
            make.left.equalTo(self.contentView.snp.right).offset(-100)
            make.top.equalTo(30)
            make.width.equalTo(60)
            make.height.equalTo(30)
        }
    }

    func bind(_ plugin: Plugin) {
        self.plugin = plugin

        //_ = try? Data(contentsOf: URL(string: plugin.logo)!)
        //let image = UIImage(data: data!)
        //logoView.image = image?.makeImageCornerRadius(radius: 30)

        let optionsInfo = [KingfisherOptionsInfoItem.targetCache(KingfisherManager.shared.cache),
                           KingfisherOptionsInfoItem.processor(RoundCornerImageProcessor(cornerRadius: 500))]
        logoView.kf.setImage(with: URL(string: plugin.logo)!,
                             placeholder: UIImage(named: "star"),
                             options: optionsInfo,
                             progressBlock: nil,
                             completionHandler: nil)


        nameLabel.text = plugin.name
        descLabel.text = plugin.desc

        installButton.delegate = self
        if PluginModel.get(code: plugin.code) != nil {
            installButton.setState(.open)
        } else {
            installButton.setState(.wait)
        }
    }

    // button delegate
    func install() {
        let pluginManager = PluginManager()
        pluginManager.downloadDelegate = self

        pluginManager.downloadPlugin(owner: self.plugin.owner, repo: self.plugin.repo, type: "hubble") {
            PluginModel.sync(self.plugin.owner, self.plugin.repo)
            PluginModel.insert(owner: self.plugin.owner, repo: self.plugin.repo, name: self.plugin.name, desc: self.plugin.desc, readme: self.plugin.readme)
            NotificationCenter.post(name: .updatePlugins)
        }
    }

    func openClick() {
        self.viewController.pushFeedViewController(plugin)
    }

    // download delegate
    func start() {
        installButton.setState(.downloading)
    }

    func progress(_ progress: Double) {
        if progress >= 1.0 {
            installButton.downloadingProgressChanged(to: CGFloat(progress))
        }
    }

    func unzip() {
    }
}
