//
//  BaseViewController.swift
//  Hubble
//
//  Created by vimrus on 2017/10/1.
//  Copyright © 2017年 Hubble. All rights reserved.
//

import UIKit

class BaseViewController: SwipeRightToPopViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.theme_backgroundColor = globalBackgroundColorPicker

        let image = UIImage(named: "back")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        let leftButton = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(backAction))
        navigationItem.leftBarButtonItem = leftButton

        hidesBottomBarWhenPushed = true
    }

    @objc func backAction(barButtonItem: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
}
