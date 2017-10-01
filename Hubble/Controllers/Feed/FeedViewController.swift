//
//  FeedViewController.swift
//  Hubble
//
//  Created by vimrus on 2017/10/1.
//  Copyright © 2017年 Hubble. All rights reserved.
//

import UIKit

class FeedViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    let TITLE_CELL_ID = "FeedTitleViewCell"
    let IMAGE_CELL_ID = "FeedImageViewCell"
    var articles: [Article]?
    var owner: String!
    var repo: String!
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

        return tableView
    }()

    init(owner: String, repo: String) {
        super.init(nibName: nil, bundle: nil)
        self.owner = owner
        self.repo  = repo

        tableView.register(TitleImageViewCell.self, forCellReuseIdentifier: IMAGE_CELL_ID)
        tableView.register(TitleViewCell.self, forCellReuseIdentifier: TITLE_CELL_ID)
        tableView.delegate = self
        tableView.dataSource = self

        hidesBottomBarWhenPushed = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.theme_backgroundColor = globalBackgroundColorPicker

        plugin = PluginModel.get(code: owner + "/" + repo)

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
        ArticleModel.getList(owner: owner, repo: repo) { articles in
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

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
