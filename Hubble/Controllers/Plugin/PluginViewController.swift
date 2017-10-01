//
//  PluginViewController.swift
//  Hubble
//
//  Created by vimrus on 2017/10/1.
//  Copyright © 2017年 Hubble. All rights reserved.
//

import UIKit
import SwiftyMarkdown
import Moya
import Moya_ObjectMapper

class PluginViewController: BaseViewController, InstallButtonDelegate, DownloadDelegate {
    var owner: String!
    var repo: String!
    var plugin: Plugin!

    var toolBar: UIToolbar!
    var ownerLabel: UILabel!
    let toolHeight: CGFloat = 60

    var logo: UIImageView = {
        let imageview = UIImageView()
        imageview.contentMode = UIViewContentMode.scaleAspectFit
        return imageview
    }()

    var descLabel: UILabel = {
        let label = UILabel()
        label.font = fixFont(18)
        label.textColor = fixColor(0x545454)
        label.textAlignment = .center
        return label;
    }()

    var installButton = InstallButton()

    var readmeLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()

    init (owner: String, repo: String) {
        super.init(nibName: nil, bundle: nil)

        self.hidesBottomBarWhenPushed = true

        self.owner = owner
        self.repo  = repo
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.theme_backgroundColor = globalBackgroundColorPicker

        view.addSubview(logo)
        view.addSubview(descLabel)
        view.addSubview(installButton)
        view.addSubview(readmeLabel)

        logo.snp.makeConstraints{ (make) -> Void in
            make.top.equalTo(20)
            make.centerX.equalTo(self.view.frame.width/2)
            make.width.height.equalTo(80)
        }

        descLabel.snp.makeConstraints{ (make) -> Void in
            make.top.equalTo(logo.snp.bottom).offset(10)
            make.centerX.equalTo(self.view.frame.width/2)
            make.right.equalTo(self.view.frame.width)
            make.height.height.equalTo(35)
        }
        installButton.snp.makeConstraints {(make) -> Void in
            make.centerX.equalTo(self.view.frame.width/2)
            make.top.equalTo(descLabel.snp.bottom).offset(5)
            make.width.equalTo(60)
            make.height.equalTo(30)
        }
        readmeLabel.snp.makeConstraints{ (make) -> Void in
            make.top.equalTo(installButton.snp.bottom).offset(20)
            make.left.equalTo(10)
            make.right.equalTo(-10)
        }

        installButton.delegate = self

        let callbackQueue = DispatchQueue(label: "background_queue", attributes: .concurrent)
        API.provider.request(.getPlugin(code: owner + "/" + repo), callbackQueue: callbackQueue) { result in
            switch result {
            case let .success(response):
                do {
                    self.plugin = try response.mapObject(Plugin.self)

                    let url = URL(string: self.plugin.logo)
                    let data = try? Data(contentsOf: url!)

                    // 主线程更新界面
                    DispatchQueue.main.async(execute: {
                        if data != nil {
                            let image = UIImage(data: data!)
                            self.logo.image = image?.makeImageCornerRadius(radius: 30)
                        }
                        self.descLabel.text = self.plugin.desc
                        self.navigationItem.title = self.plugin.name

                        if PluginModel.get(code: self.plugin.code) != nil {
                            self.installButton.setState(.open)
                        } else {
                            self.installButton.setState(.wait)
                        }

                        let md = SwiftyMarkdown(string: self.plugin.readme)
                        self.readmeLabel.attributedText = md.attributedString()
                    })
                } catch {
                    print(error)
                }
            case let .failure(error):
                print(error)
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isTranslucent = false
        self.tabBarController?.tabBar.isHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isTranslucent = true
        self.tabBarController?.tabBar.isHidden = false
    }

    // button delegate
    func install() {
        let pluginManager = PluginManager()
        pluginManager.downloadDelegate = self

        pluginManager.downloadPlugin(owner: self.plugin.owner, repo: self.plugin.repo, type: "hubble") {
            PluginModel.sync(self.plugin.owner, self.plugin.repo)
            PluginModel.insert(owner: self.plugin.owner, repo: self.plugin.repo, name: self.plugin.name, desc: self.plugin.desc, readme: self.plugin.readme)
        }
    }

    func openClick() {
        let feedViewController = FeedViewController(owner: plugin.owner, repo: plugin.repo)
        self.navigationController?.pushViewController(feedViewController, animated: true)
    }

    // download delegate
    func start() {
        installButton.setState(.downloading)
    }

    func progress(_ progress: Double) {
        installButton.downloadingProgressChanged(to: CGFloat(progress))
    }

    func unzip() {
    }
}
