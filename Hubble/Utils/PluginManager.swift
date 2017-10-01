//
//  PluginManager.swift
//  Hubble
//
//  Created by vimrus on 2017/10/1.
//  Copyright © 2017年 Hubble. All rights reserved.
//

import UIKit
import Alamofire
import Zip
import ObjectMapper

protocol DownloadDelegate{
    func start()
    func progress(_ progress: Double)
    func unzip()
}

class PluginConfig: Mappable {
    var site = ""
    var style = ""

    required convenience init?(map: Map) {
        self.init()
    }

    func mapping(map: Map) {
        site  <- map["site"]
        style <- map["style"]
    }
}

class PluginManager {
    private let fileManager = FileManager.default
    var owner: String?
    var repo: String?

    var downloadDelegate: DownloadDelegate?

    func getDownloadFolder() -> URL {
        return URL(fileURLWithPath: NSTemporaryDirectory())
    }

    func getDocumentsFolder() -> URL {
        return fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
    }

    func getSourcePath(owner: String, repo: String, type: String) -> URL {
        switch type {
        case "hubble":
            return URL(string: "http://github.com/\(owner)/\(repo)/zipball/master/")!
        default:
            return URL(string: "\(API.BASEURL)/repos/\(owner)/\(repo).zip")!
        }
    }

    func getOwnerPath(owner: String) -> URL {
        return self.getDocumentsFolder().appendingPathComponent(owner)
    }

    func getRepoPath(owner: String, repo: String) -> URL {
        return self.getOwnerPath(owner: owner).appendingPathComponent(repo)
    }

    func getJsPath(owner: String, repo: String) -> URL {
        return self.getRepoPath(owner: owner, repo: repo).appendingPathComponent("index.js")
    }

    func getStylePath(owner: String, repo: String) -> URL {
        return self.getRepoPath(owner: owner, repo: repo).appendingPathComponent("style.css")
    }

    func getConfig(owner: String, repo: String) -> PluginConfig {
        let configFile = self.getRepoPath(owner: owner, repo: repo).appendingPathComponent("config.json").path
        let content = fileManager.contents(atPath: configFile)
        let config = Mapper<PluginConfig>().map(JSONString: String(data: content!, encoding: .utf8)!)
        return config!
    }

    func getZipPath() -> URL {
        return getDownloadFolder().appendingPathComponent("master.zip")
    }

    func getLogoPath(owner: String, repo: String) -> URL {
        return self.getRepoPath(owner: owner, repo: repo).appendingPathComponent("logo.png")
    }

    func readJs(owner: String, repo: String) -> String {
        if let content = fileManager.contents(atPath: getJsPath(owner: owner, repo: repo).path) {
            return String(data: content, encoding: String.Encoding.utf8)!
        }
        return ""
    }

    func readStyle(owner: String, repo: String) -> String? {
        let content = fileManager.contents(atPath: getStylePath(owner: owner, repo: repo).path)
        return content == nil ? nil : String(data: content!, encoding: String.Encoding.utf8)!
    }

    func renameRepo(from: String, to: String) {
        let documentsFolder = getDocumentsFolder()
        let fromFolder = documentsFolder.appendingPathComponent(from)
        let toFolder = documentsFolder.appendingPathComponent(to)
        if fileManager.fileExists(atPath: toFolder.path) {
            try! fileManager.removeItem(at: toFolder)
        }
        try! fileManager.moveItem(at: fromFolder, to: toFolder)
    }

    func checkDownloadFolder() {
        var isDirectory: ObjCBool = false
        let downloadFolder = getDownloadFolder()

        if fileManager.fileExists(atPath: downloadFolder.path, isDirectory:&isDirectory) {
            if !isDirectory.boolValue {
                try! fileManager.removeItem(atPath: downloadFolder.path)
                try! fileManager.createDirectory(atPath: downloadFolder.path, withIntermediateDirectories: true, attributes: nil)
            }
        } else {
            try! fileManager.createDirectory(atPath: downloadFolder.path, withIntermediateDirectories: true, attributes: nil)
        }
    }

    func downloadPlugin(owner: String, repo: String, type: String, completionHandler: @escaping ()-> Void ) {
        downloadDelegate?.start()
        self.owner = owner
        self.repo = repo

        checkDownloadFolder()

        let zipPath = getZipPath()
        let destination: DownloadRequest.DownloadFileDestination = { _, _ in
            return (zipPath, [.removePreviousFile])
        }

        Alamofire.download(getSourcePath(owner: owner, repo: repo, type: type).absoluteString, to: destination)
            .downloadProgress { progress in
                self.downloadDelegate?.progress(progress.fractionCompleted)
            }
            .response { response in
                if response.destinationURL != nil {
                    do {
                        // 解压到 documentsFolder 中
                        try Zip.unzipFile(zipPath, destination: self.getOwnerPath(owner: self.owner!), overwrite: true, password: "", progress: { (progress) -> () in
                            if (progress >= 1.0) {
                                self.downloadDelegate?.unzip()

                                // 确定解压后的目录名，并重命名
                                let dirname = response.response?.suggestedFilename!.components(separatedBy: ".")[0]
                                self.renameRepo(from: self.owner! + "/" + dirname!, to: self.owner! + "/" + self.repo!)
                            }
                        })
                    } catch {
                        print(error)
                    }
                }
                completionHandler()
        }
    }
}

