//
//  Engine.swift
//  Hubble
//
//  Created by vimrus on 2017/10/1.
//  Copyright © 2017年 Hubble. All rights reserved.
//

import WebKit
import JavaScriptCore
import Alamofire

class Engine {
    static let sharedInstance = Engine()

    var jsVM = JSVirtualMachine()

    func load(owner: String, repo: String) {
        let plugin = owner + "/" + repo
        let context = JSContext(virtualMachine: jsVM)
        context?.exceptionHandler = {(context: JSContext!, exception: JSValue!) ->Void in
            context.exception = exception

            let stacktrace = exception.objectForKeyedSubscript("stack").toString()

            let lineNumber = exception.objectForKeyedSubscript("line")
            let column = exception.objectForKeyedSubscript("column")
            let moreInfo = "in method \(String(describing: stacktrace!)) line: \(String(describing: lineNumber!)), column: \(String(describing: column!))"

            print("JS ERROR: \(exception!) \(moreInfo)")
        }
        let jsCheerio = try! String(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "cheerio", ofType: "js")!))
        let jsHook = try! String(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "hook", ofType: "js")!))

        // 方法：request
        let request: @convention(block) () -> Void = {
            let args = JSContext.currentArguments()
            let url = (args?[0] as AnyObject).toString()
            let callback = args?[1] as? JSValue
            Alamofire.request(url!).responseData { response in
                if let res = response.response {
                    let statusCode = response.response?.statusCode
                    var body = ""
                    if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                        body = utf8Text
                    }
                    let error = ""
                    var headers = [String: String]()
                    for (field, value) in res.allHeaderFields {
                        let key = "\(field)".lowercased()
                        headers[key] = "\(value)"
                    }
                    let resp = Response(statusCode: statusCode!, headers: headers, body: body)
                    _ = callback?.call(withArguments: [error, resp, body])
                } else {
                    _ = callback?.call(withArguments: ["network error", Response(statusCode: 400, headers: [String: String](), body: ""), ""])
                }
            }
        }

        context?.setObject(unsafeBitCast(request, to: AnyObject.self), forKeyedSubscript: "request" as NSCopying & NSObjectProtocol)

        // js：app.log
        let consoleLog: @convention(block) (String) -> Void = { message in
            print(message, terminator: "\n")
        }
        context?.setObject(unsafeBitCast(consoleLog, to: AnyObject.self), forKeyedSubscript: "consoleLog" as NSCopying & NSObjectProtocol)

        // js: articles.append
        let append: @convention(block) (JSValue) -> Void = { feed in
            if let dict = feed.toDictionary() {
                let content = dict["content"] as? String ?? ""
                let summary = dict["summary"] as? String ?? String(content.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil).prefix(50))

                ArticleModel.insert(id: dict["id"] as? String ?? "", plugin: plugin, title: dict["title"] as? String ?? "", content: content, summary: summary, image: dict["image"] as? String ?? "", url: dict["url"] as? String ?? "", channel: dict["channel"] as? String ?? "")
                NotificationCenter.post(name: .refresh)
            }
        }
        context?.setObject(unsafeBitCast(append, to: AnyObject.self), forKeyedSubscript: "articleAppend" as NSCopying & NSObjectProtocol)

        // js: articles.get
        let get: @convention(block) (JSValue) -> Void = { article in
            let args = JSContext.currentArguments()
            let field = (args?[0] as AnyObject).toString()
            let value = (args?[1] as AnyObject).toString()
            let callback = args?[2] as? JSValue

            let article = ArticleModel.jsGet(plugin: plugin, field!, value!)
            if article != nil {
                _ = callback?.call(withArguments: [ArticleObject(article: article!)])
            } else {
                _ = callback?.call(withArguments: [0])
            }
        }
        context?.setObject(unsafeBitCast(get, to: AnyObject.self), forKeyedSubscript: "articleGet" as NSCopying & NSObjectProtocol)

        // run
        _ = context?.evaluateScript(jsCheerio)
        _ = context?.evaluateScript(jsHook)

        let pluginManager = PluginManager()
        let jsCode = pluginManager.readJs(owner: owner, repo: repo)

        _ = context?.evaluateScript(jsCode)
    }
}

@objc protocol ResponseJSExports: JSExport {
    var statusCode: Int { get set }
    var body: String { get set }
    var headers: [String: String] { get set }
}
class Response: NSObject, ResponseJSExports {
    var statusCode: Int
    var body: String
    var headers: [String: String]

    init(statusCode: Int, headers: [String: String], body: String) {
        self.statusCode = statusCode
        self.headers = headers
        self.body = body
    }
}

@objc protocol ArticleJSExports: JSExport {
    var id: String { get set }
    var plugin: String { get set }
    var title: String { get set }
    var content: String { get set }
    var summary: String { get set }
    var url: String { get set }
    var image: String { get set }
    var addtime: Int { get set }
    var readtime: Int { get set }
    var startime: Int { get set }
}

class ArticleObject: NSObject, ArticleJSExports {
    var id: String
    var plugin: String
    var title: String
    var content: String
    var summary: String
    var url: String
    var image: String
    var addtime: Int
    var readtime: Int
    var startime: Int

    init(article: Article) {
        self.id = article.id
        self.plugin = article.plugin
        self.title = article.title
        self.content = article.content
        self.summary = article.summary
        self.url = article.url
        self.image = article.image
        self.addtime = article.addtime
        self.readtime = article.readtime
        self.startime = article.startime
    }
}
