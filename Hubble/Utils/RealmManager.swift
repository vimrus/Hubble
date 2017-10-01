//
//  Realm.swift
//  Hubble
//
//  Created by vimrus on 2017/10/1.
//  Copyright © 2017年 Hubble. All rights reserved.
//

import Foundation
import RealmSwift

class RealmManager {
    static let sharedInstance: Realm = {
        let config = Realm.Configuration(fileURL: FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("hubble.realm"), shouldCompactOnLaunch: { totalBytes, usedBytes in
            // Compact if the file is over 100MB in size and less than 50% 'used'
            let size = 100 * 1024 * 1024
            return (totalBytes > size) && (Double(usedBytes) / Double(totalBytes)) < 0.5
        })
        return try! Realm(configuration: config)
    }()
}
