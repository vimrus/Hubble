//
//  ArticleModel.swift
//  Hubble
//
//  Created by vimrus on 2017/10/1.
//  Copyright © 2017年 Hubble. All rights reserved.
//

import UIKit
import RealmSwift

class Article: Object {
    @objc dynamic var id = ""
    @objc dynamic var plugin = ""
    @objc dynamic var title = ""
    @objc dynamic var content = ""
    @objc dynamic var summary = ""
    @objc dynamic var url = ""
    @objc dynamic var image = ""
    @objc dynamic var channel = ""
    @objc dynamic var addtime = 0
    @objc dynamic var readtime = 0
    @objc dynamic var startime = 0
    @objc dynamic var deleted = 0

    override static func primaryKey() -> String? {
        return "id"
    }

    func toJsValue() -> [String: Any] {
        let index = id.index(id.startIndex, offsetBy: plugin.count)

        return [
            "id": id[index...],
            "title": title,
            "content": content,
            "summary": summary,
            "url": url,
            "time": time
        ]
    }
}

class ArticleModel {
    class func insert(id: String, plugin: String, title: String, content: String, summary: String, image: String, url: String, channel: String) {
        try! RealmManager.sharedInstance.write {
            RealmManager.sharedInstance.create(Article.self, value: ["id": "\(plugin)/\(id)", "plugin": plugin, "title": title, "content": content, "summary": summary, "image": image, "url": url, "channel": channel, "addtime": Int(Date().timeIntervalSince1970)], update: true)
        }
    }

    class func getList(owner: String, repo: String, completion: ([Article]) -> Void) {
        let articles = Array(RealmManager.sharedInstance.objects(Article.self).filter("plugin = '\(owner)/\(repo)'").sorted(byKeyPath: "addtime", ascending: false))
        completion(articles)
    }

    class func getList(owner: String, repo: String, channel: String, completion: ([Article]) -> Void) {
        let articles = Array(RealmManager.sharedInstance.objects(Article.self).filter("plugin = '\(owner)/\(repo)' and channel = '\(channel)'").sorted(byKeyPath: "addtime", ascending: false))
        completion(articles)
    }

    class func getLast(owner: String, repo: String) -> Article? {
        return RealmManager.sharedInstance.objects(Article.self).filter("plugin = '\(owner)/\(repo)'").sorted(byKeyPath: "addtime", ascending: false).first
    }

    class func getStarList(completion: ([Article]) -> Void) {
        let articles = Array(RealmManager.sharedInstance.objects(Article.self).filter("startime != 0").sorted(byKeyPath: "startime", ascending: false))
        completion(articles)
    }

    class func getHistories(completion: ([Article]) -> Void) {
        let articles = Array(RealmManager.sharedInstance.objects(Article.self).filter("readtime != 0").sorted(byKeyPath: "readtime", ascending: false))
        completion(articles)
    }

    class func getAll(completion: ([Article]) -> Void) {
        let articles = Array(RealmManager.sharedInstance.objects(Article.self).sorted(byKeyPath: "addtime", ascending: false))
        completion(articles)
    }

    class func get(_ id: String) -> Article? {
        return RealmManager.sharedInstance.objects(Article.self).filter("id = '\(id)'").first
    }

    class func jsGet(plugin: String, _ field: String, _ value: String) -> Article? {
        return RealmManager.sharedInstance.objects(Article.self).filter("\(field) = '\(plugin)/\(value)'").first
    }

    class func read(_ article: Article) {
        try! RealmManager.sharedInstance.write {
            article.readtime = Int(Date().timeIntervalSince1970)
        }
    }

    class func star(_ article: Article) {
        try! RealmManager.sharedInstance.write {
            article.startime = Int(Date().timeIntervalSince1970)
        }
    }

    class func unstar(_ article: Article) {
        try! RealmManager.sharedInstance.write {
            article.startime = 0
        }
    }
}
