//
//  ViewController.swift
//  world
//
//  Created by 朱金勇 on 2017/6/12.
//  Copyright © 2017年 vimrus. All rights reserved.

import UIKit

class FeedViewController: BaseViewController, SMSwipeableTabViewControllerDelegate {
    var owner: String!
    var repo: String!
    var plugin: Plugin!
    var config: PluginConfig!

    init(owner: String, repo: String) {
        super.init(nibName: nil, bundle: nil)
        self.owner = owner
        self.repo  = repo

        hidesBottomBarWhenPushed = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.theme_backgroundColor = globalBackgroundColorPicker

        plugin = PluginModel.get(code: owner + "/" + repo)
        config = PluginManager().getConfig(owner: owner, repo: repo)

        // 导航栏标题
        let navView = UIView()

        let label = UILabel()
        label.text = plugin?.name
        label.sizeToFit()
        label.center = navView.center
        label.textAlignment = NSTextAlignment.center

        let imageView = UIImageView()
        let logo = PluginManager().getLogoPath(owner: plugin.owner, repo: plugin.repo)
        if let data = try? Data(contentsOf: logo) {
            imageView.image = UIImage(data: data)
        }

        if let img = imageView.image {
            let imageAspect = img.size.width / img.size.height
            imageView.frame = CGRect(x: label.frame.origin.x - label.frame.size.height*imageAspect - 5, y: label.frame.origin.y, width: label.frame.size.height*imageAspect, height: label.frame.size.height)
            imageView.contentMode = UIViewContentMode.scaleAspectFit
            navView.addSubview(imageView)
        }

        navView.addSubview(label)

        self.navigationItem.titleView = navView

        navView.sizeToFit()

        // 更多
        let image = UIImage(named: "more")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        let rightButton = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(alert))
        navigationItem.rightBarButtonItem = rightButton

        if config.channels.count > 0 {
            var titleBarDataSource = [String]()
            for channel in config.channels {
                titleBarDataSource.append(channel["name"] as! String)
            }

            let swipeableView = SMSwipeableTabViewController()
            swipeableView.titleBarDataSource = titleBarDataSource
            swipeableView.delegate = self
            swipeableView.viewFrame = CGRect(x: 0.0, y: 64.0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height-64.0)

            swipeableView.buttonAttributes = [
                SMBackgroundColorAttribute: UIColor.clear,
                SMAlphaAttribute: 0.8 as AnyObject,
                SMButtonHideTitleAttribute: false as AnyObject,
                SMFontAttribute: UIFont(name: ".SFUIText-Medium", size: 17)!
            ]
            swipeableView.selectionBarHeight = 3.0 //For thin line
            swipeableView.segementBarHeight = 40.0 //Default is 40.0
            swipeableView.buttonPadding = 8.0 //Default is 8.0

            self.addChildViewController(swipeableView)
            self.view.addSubview(swipeableView.view)
            swipeableView.didMove(toParentViewController: self)
        } else {
            let feedListViewController = FeedListViewController(owner: owner, repo: repo, channel: "")
            self.addChildViewController(feedListViewController)
            self.view.addSubview(feedListViewController.view)
        }
    }

    func didLoadViewControllerAtIndex(_ index: Int) -> UIViewController {
        var channel = ""
        if config.channels[index]["key"] is String {
            channel = config.channels[index]["key"] as! String
        } else if config.channels[index]["key"] is Int {
            channel = String(config.channels[index]["key"] as! Int)
        }
        let vc = FeedListViewController(owner: owner, repo: repo, channel: channel)
        return vc
    }


    @objc func alert() {
        let items = [AlertSheetItem(title: "取消订阅", style: .special), AlertSheetItem(title: "清空历史", style: .light)]
        let sheet = AlertSheet.actionSheet(title: "操作", cancelItemTitle: "取消", otherItemTitles: items)
        sheet.didClickedItemAtIndexHandler = { rowIndex in
            switch rowIndex {
            case 0:
                PluginModel.delete(code: self.plugin.code)
                NotificationCenter.post(name: .updatePlugins)
                NotificationCenter.post(name: .refresh)
                self.navigationController?.popViewController(animated: true)
            case 1:
                PluginModel.flush(code: self.plugin.code)
                NotificationCenter.post(name: .updatePlugins)
                NotificationCenter.post(name: .refresh)
            default:
                break
            }
        }
        sheet.didClickedCancelHandler = {
            NSLog("didClicked Cancel")
        }
        sheet.show()
    }
}
