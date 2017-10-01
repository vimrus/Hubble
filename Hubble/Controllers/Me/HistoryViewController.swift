//
//  HistoryViewController.swift
//  Hubble
//
//  Created by vimrus on 2017/10/1.
//  Copyright © 2017年 Hubble. All rights reserved.
//

import UIKit

class HistoryViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    let TITLE_CELL_ID = "FeedTitleViewCell"
    let IMAGE_CELL_ID = "FeedImageViewCell"
    var articles: [Article]?
    var plugin: Plugin!

    var tableView: UITableView = {
        var tableView = UITableView()
        tableView.showsVerticalScrollIndicator = false

        tableView.layoutMargins = UIEdgeInsets.zero
        tableView.separatorInset = UIEdgeInsets.zero
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        tableView.separatorStyle = .none
        tableView.layoutMargins = UIEdgeInsets.zero
        tableView.separatorInset = UIEdgeInsets.zero
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        tableView.showsVerticalScrollIndicator = false

        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100

        tableView.theme_backgroundColor = globalBackgroundColorPicker

        return tableView
    }()

    init() {
        super.init(nibName: nil, bundle: nil)

        tableView.register(TitleImageViewCell.self, forCellReuseIdentifier: IMAGE_CELL_ID)
        tableView.register(TitleViewCell.self, forCellReuseIdentifier: TITLE_CELL_ID)
        tableView.delegate = self
        tableView.dataSource = self

        hidesBottomBarWhenPushed = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.theme_backgroundColor = globalBackgroundColorPicker
        navigationItem.title = "阅读历史";

        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) -> Void in
            make.left.right.width.height.equalTo(view)
        }
        refresh()

        NotificationCenter.default.addObserver(self, selector: #selector(refresh), name: NSNotification.Name.refresh, object: nil)
    }

    @objc func refresh() {
        ArticleModel.getHistories() { articles in
            self.articles = articles
        }

        tableView.reloadData()
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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

