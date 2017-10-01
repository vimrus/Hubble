//
//  UnreadViewController.swift
//  Hubble
//
//  Created by vimrus on 2017/10/1.
//  Copyright © 2017年 Hubble. All rights reserved.
//

import UIKit
import ReachabilitySwift

class UnreadViewController: UITableViewController {
    let CELL_ID = "UnreadViewCell"
    var articles: [Article]?
    var pluginCount = 0
    let reachability = Reachability.init()!

    init() {
        super.init(nibName: nil, bundle: nil)
        tableView.register(UnreadViewCell.self, forCellReuseIdentifier: CELL_ID)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.theme_backgroundColor = globalBackgroundColorPicker
        navigationItem.title = "阅读";
        tableView.showsVerticalScrollIndicator = false
        tableView.refreshControl = refreshControl
        tableView.delegate = self
        tableView.dataSource = self

        tableView.layoutMargins = UIEdgeInsets.zero
        tableView.separatorInset = UIEdgeInsets.zero
        tableView.tableFooterView = UIView(frame: CGRect.zero)

        NotificationCenter.default.addObserver(self, selector: #selector(refresh), name: NSNotification.Name.refresh, object: nil)

        tableView.rowHeight = UITableViewAutomaticDimension;
        tableView.estimatedRowHeight = 100;

        DispatchQueue.global(qos: .userInitiated).async {
            DispatchQueue.main.async {
                // 每隔10分钟更新
                let timer = Timer.scheduledTimer(timeInterval: 600, target: self, selector: #selector(self.sync), userInfo: nil, repeats: true);
                timer.fire()

                // 每分钟刷新时间
                let refresher = Timer.scheduledTimer(timeInterval: 600, target: self, selector: #selector(self.refresh), userInfo: nil, repeats: true);
                refresher.fire()
            }
        }

        refresh()

        // webview预热
        WebView.sharedInstance.loadHTMLString("", baseURL: URL(string: "http://test.com"))
    }

    @objc func refresh() {
        ArticleModel.getAll() { articles in
            self.articles = articles
            self.tableView.reloadData()
        }
    }

    @objc func sync() {
        if reachability.isReachableViaWiFi {
            PluginModel.sync()
            self.tableView.reloadData()
        }
    }

    @objc func add() {
        let pluginListViewController = PluginListViewController()
        navigationController?.pushViewController(pluginListViewController, animated: true)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL_ID, for: indexPath) as! UnreadViewCell

        cell.layoutMargins = UIEdgeInsets.zero
        let article = articles![indexPath.row]
        let plugin = PluginModel.get(code: article.plugin)
        cell.bind(article, plugin!)

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let article = articles?[indexPath.row]
        let articleViewController = ArticleViewController((article?.id)!)
        self.navigationController?.pushViewController(articleViewController, animated: true)
    }

    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.theme_backgroundColor = globalBackgroundColorPicker
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let list = articles {
            return list.count
        }
        return 0
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
