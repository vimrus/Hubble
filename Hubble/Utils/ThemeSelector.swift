//
//  ThemeSelector.swift
//  Hubble
//
//  Created by vimrus on 2017/10/1.
//  Copyright © 2017年 Hubble. All rights reserved.
//

import UIKit

class ThemeSelector: UIView {
    public var strokeColor = UIColor.gray
    public var fillColor: UIColor!
    public var selectColor = UIColor.gray
    public var circle: UIBezierPath?
    public var select: UIBezierPath?
    private var _selected = false

    var selectTheme: ( () -> Void )?

    public var selected: Bool {
        get {
            return _selected
        }

        set {
            _selected = newValue
            self.setNeedsDisplay()
        }
    }

    init(color: UIColor, selected: Bool = false) {
        super.init(frame: CGRect.zero)

        backgroundColor = UIColor.clear
        fillColor = color
        self.selected = selected

        let recognizer = UITapGestureRecognizer(target: self, action: #selector(tap))
        self.addGestureRecognizer(recognizer)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func draw(_ rect: CGRect) {
        let circleRect = CGRect(x: 8, y: rect.minY + 8, width: rect.width - 16, height: rect.height - 16)
        let selectRect = CGRect(x: 3, y: rect.minY + 3, width: rect.width - 6, height: rect.height - 6)

        let ctx = UIGraphicsGetCurrentContext()
        ctx?.saveGState()
        ctx?.setBlendMode(.copy)

        if selected {
            selectColor.setStroke()
            select = UIBezierPath(ovalIn: selectRect)
            select?.lineWidth = 1
            select?.stroke()
        }

        strokeColor.setStroke()
        fillColor?.setFill()
        circle = UIBezierPath(ovalIn: circleRect)
        circle?.lineWidth = 1
        circle?.close()

        circle?.stroke()
        circle?.fill()
    }

    @objc func tap(_ sender: ThemeSelector) {
        selectTheme?()
    }
}
