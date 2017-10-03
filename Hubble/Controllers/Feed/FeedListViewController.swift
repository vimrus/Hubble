//
//  FeedListViewController.swift
//  Hubble
//
//  Created by vimrus on 2017/9/30.
//  Copyright © 2017年 vimrus. All rights reserved.
//

import UIKit

class FeedListViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    let TITLE_CELL_ID = "FeedTitleViewCell"
    let IMAGE_CELL_ID = "FeedImageViewCell"
    var articles: [Article]?
    var owner: String!
    var repo: String!
    var channel: String!
    var plugin: Plugin!

    var tableView: UITableView = {
        var tableView = UITableView()
        tableView.showsVerticalScrollIndicator = false

        tableView.separatorInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        tableView.separatorColor = fixColor(0xE4E4E4)
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        tableView.showsVerticalScrollIndicator = false

        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100

        return tableView
    }()

    init(owner: String, repo: String, channel: String) {
        super.init(nibName: nil, bundle: nil)
        self.owner   = owner
        self.repo    = repo
        self.channel = channel

        tableView.register(TitleImageViewCell.self, forCellReuseIdentifier: IMAGE_CELL_ID)
        tableView.register(TitleViewCell.self, forCellReuseIdentifier: TITLE_CELL_ID)
        tableView.delegate = self
        tableView.dataSource = self

        hidesBottomBarWhenPushed = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.theme_backgroundColor = globalBackgroundColorPicker

        plugin = PluginModel.get(code: owner + "/" + repo)

        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) -> Void in
            make.left.right.width.height.equalTo(view)
        }
        refresh()

        NotificationCenter.default.addObserver(self, selector: #selector(refresh), name: NSNotification.Name.refresh, object: nil)
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

    @objc func refresh() {
        ArticleModel.getList(owner: owner, repo: repo, channel: channel) { articles in
            self.articles = articles
            tableView.reloadData()
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if articles![indexPath.row].image != "" {
            let cell = tableView.dequeueReusableCell(withIdentifier: IMAGE_CELL_ID, for: indexPath) as! TitleImageViewCell
            cell.bind(articles![indexPath.row])
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: TITLE_CELL_ID, for: indexPath) as! TitleViewCell
            cell.bind(articles![indexPath.row])
            return cell
        }
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.theme_backgroundColor = globalBackgroundColorPicker
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let article = articles?[indexPath.row]
        let articleViewController = ArticleViewController((article?.id)!)
        self.navigationController?.pushViewController(articleViewController, animated: true)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let list = articles {
            return list.count
        }
        return 0
    }
}

