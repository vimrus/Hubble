//
//  HomeViewController.swift
//  Hubble
//
//  Created by vimrus on 2017/10/1.
//  Copyright © 2017年 Hubble. All rights reserved.
//

import UIKit
import ReachabilitySwift

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let CELL_ID = "HomeViewCell"
    var plugins: [Plugin]!
    let addButton = UIImageView()
    let guideLabel = UILabel()
    let reachability = Reachability.init()!

    var tableView: UITableView = {
        var tableView = UITableView()
        tableView.showsVerticalScrollIndicator = false

        tableView.layoutMargins = UIEdgeInsets.zero
        tableView.separatorInset = UIEdgeInsets.zero
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        tableView.layoutMargins = UIEdgeInsets.zero
        tableView.separatorInset = UIEdgeInsets.zero
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        tableView.showsVerticalScrollIndicator = false

        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100

        return tableView
    }()

    init() {
        super.init(nibName: nil, bundle: nil)
        tableView.register(HomeViewCell.self, forCellReuseIdentifier: CELL_ID)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.theme_backgroundColor = globalBackgroundColorPicker

        navigationItem.title = "首页";

        tableView.delegate = self
        tableView.dataSource = self

        NotificationCenter.default.addObserver(self, selector: #selector(refresh), name: NSNotification.Name.refresh, object: nil)

        // 添加按钮
        let image = UIImage(named: "more")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        let rightButton = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(add))
        navigationItem.rightBarButtonItem = rightButton

        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) -> Void in
            make.left.right.width.height.equalTo(view)
        }

        DispatchQueue.global(qos: .userInitiated).async {
            DispatchQueue.main.async {
                self.sync()
            }
        }

        if PluginModel.getCount() == 0 {
            displayGuide()
        }

        refresh()

        // webview预热
        WebView.sharedInstance.loadHTMLString("", baseURL: URL(string: "http://test.com"))
    }

    @objc func refresh() {
        PluginModel.getList { plugins in
            if plugins.count > 0 {
                addButton.removeFromSuperview()
                guideLabel.removeFromSuperview()
            }

            self.plugins = plugins
            self.tableView.reloadData()
        }
    }

    @objc func sync() {
        if reachability.isReachableViaWiFi {
            PluginModel.sync()
            self.tableView.reloadData()
        }
    }

    func displayGuide() {
        addButton.contentMode = .scaleAspectFit

        guideLabel.font = fixFont(20)
        guideLabel.textColor = fixColor(0x888888)
        guideLabel.textAlignment = .center

        view.addSubview(addButton)
        view.addSubview(guideLabel)

        addButton.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(100)
            make.centerX.equalTo(UIScreen.main.bounds.size.width/2)
            make.width.height.equalTo(100)
        }

        guideLabel.snp.makeConstraints { (make) -> Void in
            make.centerX.equalTo(UIScreen.main.bounds.size.width/2)
            make.top.equalTo(addButton.snp.bottom).offset(20)
        }
        addButton.image = UIImage(named: "add")
        guideLabel.text = "点击添加订阅源"

        addButton.isUserInteractionEnabled = true
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(add))
        addButton.addGestureRecognizer(singleTap)
    }

    @objc func add() {
        let pluginListViewController = PluginListViewController()
        navigationController?.pushViewController(pluginListViewController, animated: true)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL_ID, for: indexPath) as! HomeViewCell

        let plugin = plugins?[indexPath.row]
        cell.bind(plugin!)

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let plugin = plugins[indexPath.row]
        let feedViewController = FeedViewController(owner: plugin.owner, repo: plugin.repo)
        self.navigationController?.pushViewController(feedViewController, animated: true)
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.theme_backgroundColor = globalBackgroundColorPicker
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let list = plugins {
            return list.count
        }
        return 0
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
