//
//  WebView.swift
//  Hubble
//
//  Created by vimrus on 2017/10/1.
//  Copyright © 2017年 Hubble. All rights reserved.
//

import WebKit

class WebView {
    static let sharedInstance = WKWebView(frame: .zero, configuration: WKWebViewConfiguration())
}
