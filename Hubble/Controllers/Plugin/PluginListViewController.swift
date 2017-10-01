//
//  PluginListViewController.swift
//  Hubble
//
//  Created by vimrus on 2017/10/1.
//  Copyright © 2017年 Hubble. All rights reserved.
//

import UIKit
import Moya
import Moya_ObjectMapper

class PluginListViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    let CELL_ID = "PluginListViewCell"
    private var plugins: [Plugin]!

    var tableView: UITableView = {
        var tableView = UITableView()
        tableView.showsVerticalScrollIndicator = false

        tableView.layoutMargins = UIEdgeInsets.zero
        tableView.separatorInset = UIEdgeInsets.zero
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        tableView.showsVerticalScrollIndicator = false

        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100

        return tableView
    }()

    init() {
        super.init(nibName: nil, bundle: nil)

        tableView.register(PluginListViewCell.self, forCellReuseIdentifier: CELL_ID)
        tableView.delegate = self
        tableView.dataSource = self

        hidesBottomBarWhenPushed = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.theme_backgroundColor = globalBackgroundColorPicker
        navigationItem.title = "订阅";

        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) -> Void in
            make.left.right.top.bottom.equalTo(view)
        }

        NotificationCenter.default.addObserver(self, selector: #selector(reload), name: .updatePlugins, object: nil)
        refresh()
    }

    @objc func reload() {
        DispatchQueue.main.async(execute: {
            self.tableView.reloadData()
        })
    }

    func refresh() {
        let callbackQueue = DispatchQueue(label: "background_queue", attributes: .concurrent)
        API.provider.request(.getPlugins(), callbackQueue: callbackQueue) { result in
            switch result {
            case let .success(response):
                do {
                    self.plugins = try response.mapArray(Plugin.self)

                    // 主线程更新界面
                    DispatchQueue.main.async(execute: {
                        self.tableView.reloadData()
                    })
                } catch {
                    print(error)
                }
            case let .failure(error):
                print(error)
            }
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL_ID, for: indexPath) as! PluginListViewCell
        cell.viewController = self
        cell.bind(plugins![indexPath.row])

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let plugin = plugins[indexPath.row]
        let pluginViewController = PluginViewController(owner: plugin.owner, repo: plugin.repo)
        self.navigationController?.pushViewController(pluginViewController, animated: true)
    }

    func pushFeedViewController(_ plugin: Plugin) {
        let feedViewController = FeedViewController(owner: plugin.owner, repo: plugin.repo)
        self.navigationController?.pushViewController(feedViewController, animated: true)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let list = plugins {
            return list.count
        }
        return 0
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
