//
//  PluginModel.swift
//  Hubble
//
//  Created by vimrus on 2017/10/1.
//  Copyright © 2017年 Hubble. All rights reserved.
//

import UIKit
import ObjectMapper
import RealmSwift

class Plugin: Object, Mappable {
    @objc dynamic var code = ""
    @objc dynamic var owner = ""
    @objc dynamic var repo = ""
    @objc dynamic var name = ""
    @objc dynamic var logo = ""
    @objc dynamic var desc = ""
    @objc dynamic var readme = ""
    @objc dynamic var install = false
    @objc dynamic var updateTime = 0
    @objc dynamic var order = 0

    override static func primaryKey() -> String? {
        return "code"
    }

    required convenience init?(map: Map) {
        self.init()
    }

    func mapping(map: Map) {
        code   <- map["code"]
        owner  <- map["owner"]
        repo   <- map["repo"]
        name   <- map["name"]
        logo   <- map["logo"]
        desc   <- map["description"]
        readme <- map["readme"]
    }
}

class PluginModel {
    class func insert(owner: String, repo: String, name: String, desc: String, readme: String) {
        let logo = PluginManager().getLogoPath(owner: owner, repo: repo).path;
        try! RealmManager.sharedInstance.write {
            RealmManager.sharedInstance.create(Plugin.self, value: ["code": owner + "/" + repo, "owner": owner, "repo": repo, "name": name, "logo": logo, "desc": desc, "readme": readme, "install": true], update: true)
        }
    }

    class func getList(handler: ([Plugin]) -> Void) {
        let plugins = Array(RealmManager.sharedInstance.objects(Plugin.self))
        handler(plugins)
    }

    class func getCount() -> Int {
        return RealmManager.sharedInstance.objects(Plugin.self).filter("install = true").count
    }

    class func get(code: String) -> Plugin? {
        return RealmManager.sharedInstance.objects(Plugin.self).filter("code = '\(code)'").first
    }

    class func flush(code: String) {
        try! RealmManager.sharedInstance.write {
            RealmManager.sharedInstance.delete(RealmManager.sharedInstance.objects(Article.self).filter("plugin = '\(code)'"))
        }
    }

    class func delete(code: String) {
        try! RealmManager.sharedInstance.write {
            RealmManager.sharedInstance.delete(RealmManager.sharedInstance.objects(Article.self).filter("plugin = '\(code)'"))
            RealmManager.sharedInstance.delete(RealmManager.sharedInstance.objects(Plugin.self).filter("code = '\(code)'"))
        }
    }

    static func sync() {
        let plugins = Array(RealmManager.sharedInstance.objects(Plugin.self))
        for plugin in plugins {
            Engine.sharedInstance.load(owner: plugin.owner, repo: plugin.repo)
        }
    }

    static func sync(_ owner: String, _ repo: String) {
        Engine.sharedInstance.load(owner: owner, repo: repo)
    }
}
