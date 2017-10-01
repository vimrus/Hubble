//
//  HubSlider.swift
//  Hubble
//
//  Created by vimrus on 2017/10/1.
//  Copyright © 2017年 Hubble. All rights reserved.
//

import UIKit

class HubSlider: UISlider {
    @objc var valueChanged : ( (_ value: Float) -> Void )?

    init() {
        super.init(frame: CGRect.zero)
        self.minimumValue = 0
        self.maximumValue = 16
        self.value = (HubStyle.sharedInstance.fontScale - 0.8 ) / 0.5 * 10
        self.addTarget(self, action: #selector(valueChanged(_:)), for: [.valueChanged])
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func valueChanged(_ sender:UISlider) {
        sender.value = Float(Int(sender.value))
        valueChanged?(sender.value)
    }
}
