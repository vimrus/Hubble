//
//  API.swift
//  Hubble
//
//  Created by vimrus on 2017/10/1.
//  Copyright © 2017年 Hubble. All rights reserved.
//

import Moya

class API {
    static let BASEURL = "http://hubble.shixian.org"

    static let provider = MoyaProvider<Hubble>(plugins: [AuthPlugin()])
}
