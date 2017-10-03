//
//  ArticleViewController.swift
//  Hubble
//
//  Created by vimrus on 2017/10/1.
//  Copyright © 2017年 Hubble. All rights reserved.
//

import UIKit
import WebKit

class ArticleViewController: SwipeRightToPopViewController {
    var id: String!
    var article: Article!
    var plugin: Plugin!

    var toolBar: UIToolbar!

    init (_ id: String) {
        super.init(nibName: nil, bundle: nil)

        self.id = id
        article = ArticleModel.get(id)
        plugin  = PluginModel.get(code: article.plugin)

        hidesBottomBarWhenPushed = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white

        let webview = WebView.sharedInstance
        webview.scrollView.bounces = false
        webview.scrollView.showsHorizontalScrollIndicator = false;
        webview.scrollView.showsVerticalScrollIndicator = false;

        view.addSubview(webview)

        var style = "body { font-size: \(18 * HubStyle.sharedInstance.fontScale)px; }"
        style += try! String(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "style", ofType: "css")!))
        let pluginManager = PluginManager()
        if let css = pluginManager.readStyle(owner: plugin.owner, repo: plugin.repo) {
            style += css
        }

        // 文章页面模板
        let time = TimeInterval(article.addtime).toString(format: "yyyy-MM-dd HH:mm")
        let html = "<html><head><meta name='viewport' content='width=device-width, minimal-ui'><style>" + style + "</style></head><body><h1 class='hubble-title'>" + article.title + "</h1><p class='hubble-from'><a href='" + article.url + "'>" + plugin.name + "</a></p><div>" + article.content + "</div><p class='hubble-time'>" + time + "</p></body></html>"
        webview.loadHTMLString(html, baseURL: URL(string: article.url))

        // toolbar
        toolBar = UIToolbar()

        view.addSubview(toolBar)
        configureToolbar();

        toolBar.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(0)
            make.width.bottom.equalTo(view)
        }

        webview.snp.makeConstraints { (make) in
            make.top.equalTo(25)
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.bottom.equalTo(toolBar.snp.top)
        }

        ArticleModel.read(article)
    }

    func configureToolbar() {
        let toolbarButtonItems = [gap, backItem, gap, gap, starItem, gap, gap, shareItem, gap]
        toolBar.setItems(toolbarButtonItems, animated: true)
    }

    let gap = UIBarButtonItem(barButtonSystemItem:.flexibleSpace, target:nil, action:nil)

    let backItem: UIBarButtonItem = {
        let item = UIBarButtonItem(image: UIImage(named: "back")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal), style: .plain, target: self, action: #selector(backAction))
        item.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        return item
    }()

    let starItem: UIBarButtonItem = {
        let item = UIBarButtonItem(image: UIImage(named: "star")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal), style: .plain, target: self, action: #selector(starAction))
        item.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: -10, right: 0)
        return item
    }()

    var shareItem: UIBarButtonItem = {
        let item = UIBarButtonItem(image: UIImage(named: "share")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal), style: .plain, target: self, action: #selector(browseAction))
        item.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: -10, right: 0)
        return item
    }()

    @objc func starAction(barButtonItem: UIBarButtonItem) {
        if article.startime != 0 {
            ArticleModel.unstar(article)
        } else {
            ArticleModel.star(article)
        }
    }

    @objc func browseAction(barButtonItem: UIBarButtonItem) {
        UIApplication.shared.open(URL(string: (article?.url)!)!, options: [:], completionHandler: nil)
    }

    @objc func backAction(barButtonItem: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
