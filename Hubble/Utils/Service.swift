//
//  Service.swift
//  Hubble
//
//  Created by vimrus on 2017/10/1.
//  Copyright © 2017年 Hubble. All rights reserved.
//

import Moya

struct AuthPlugin: PluginType {

    func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        var request = request
        if let token = UserDefaults.standard.string(forKey: "token") {
            request.addValue(token, forHTTPHeaderField: "Authorization")
        }
        request.addValue("application/json", forHTTPHeaderField: "Content-type")
        return request
    }
}

enum Hubble {
    case getPlugin(code: String)
    case getPlugins()
    case getProfile()
    case getArticle(url: String)
    case getComment(id: String)
    case getComments(url: String)
    case getHotComments()
    case postComment(url: String, title: String, content: String, replyid: String)
}

extension Hubble: TargetType {
    var headers: [String : String]? {
        return ["version": "0.1.0"]
    }

    var baseURL: URL { return URL(string: API.BASEURL)! }
    var path: String {
        switch self {
        case .getPlugins:
            return "/plugins"
        case .getPlugin(let code):
            return "/plugins/\(code)"
        case .getProfile:
            return "/profile"
        case .getArticle(let url):
            return "/articles/\(url)"
        case .getComment(let id):
            return "/comments/\(id)"
        case .getComments(let url):
            return "/articles/\(url)/comments"
        case .getHotComments():
            return "/comments"
        case .postComment(let url, _, _, _):
            return "/articles/\(url)/comments"
        }
    }
    var method: Moya.Method {
        switch self {
        case .postComment:
            return .post
        default:
            return .get
        }
    }
    var parameters: [String : Any]? {
        switch self {
        case .getHotComments():
            return ["type": "hot"]
        case .postComment(_, let title, let content, let replyid):
            return ["title": title, "content": content, "replyid": replyid]
        default:
            return nil
        }
    }

    var parameterEncoding: ParameterEncoding {
        return URLEncoding.default
    }

    var sampleData: Data {
        return "success".data(using: String.Encoding.utf8)!
    }

    var task: Task {
        return .requestPlain
    }
}

