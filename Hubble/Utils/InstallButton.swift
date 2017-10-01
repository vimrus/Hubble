//
//  InstallButton.swift
//  Hubble
//
//  Created by vimrus on 2017/10/1.
//  Copyright © 2017年 Hubble. All rights reserved.
//

import UIKit

public protocol InstallButtonDelegate: class {
    func openClick()
    func install()
}

public enum InstallStates {
    case wait
    case connecting
    case downloading
    case installing
    case open
}

private enum AnimationStates: String {
    case none
    case borderToCircle
    case borderToCircleReverse
    case circleRotation
    case circleRotationReverse
    case downloading
    case downloadingReverse
    case rotateToEnd
    case done
}

public class InstallButton: UIControl {
    var title: String = "订阅"
    var titleOpen: String = "打开"
    var titleColor: UIColor = UIColor.blue
    var titleColorDone: UIColor = UIColor.blue
    var titleFont: UIFont = UIFont.boldSystemFont(ofSize: 18)
    var titleFontDone: UIFont = UIFont.boldSystemFont(ofSize: 18)

    var lineWidth: CGFloat = 2
    var progressLineWidth: CGFloat = 2

    private var prevValue: CGFloat = 0

    private var titleLabel = UILabel()
    private var titleLabelOpen = UILabel()
    private var borderLine = CAShapeLayer()
    private var downloadingLine = CAShapeLayer()
    private var downloadingProgressLine = CAShapeLayer()

    var mainColor: UIColor = UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1)
    var downloadingColor: UIColor = UIColor.blue

    public var delegate: InstallButtonDelegate?

    override public func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = getRaduis()
        self.layer.backgroundColor = mainColor.cgColor
        addLines()
        addTitle()
    }

    private func addLines() {
        downloadingProgressLine.bounds = bounds
        downloadingProgressLine.position = CGPoint(x: bounds.width / 2.0, y: bounds.height / 2.0)
        downloadingProgressLine.fillColor = UIColor.clear.cgColor
        downloadingProgressLine.strokeColor = downloadingColor.cgColor
        downloadingProgressLine.lineWidth = progressLineWidth
        downloadingProgressLine.path = pathForCircle().cgPath
        downloadingProgressLine.strokeStart = 0
        downloadingProgressLine.strokeEnd = 0

        downloadingLine.bounds = bounds
        downloadingLine.position = CGPoint(x: bounds.width / 2.0, y: bounds.height / 2.0)
        downloadingLine.fillColor = UIColor.clear.cgColor
        downloadingLine.strokeColor = mainColor.cgColor
        downloadingLine.lineWidth = lineWidth
        downloadingLine.path = pathForCircle().cgPath
        downloadingLine.strokeStart = 0
        downloadingLine.strokeEnd = 0

        borderLine.bounds = bounds
        borderLine.position = CGPoint(x: bounds.width / 2.0, y: bounds.height / 2.0)
        borderLine.fillColor = UIColor.clear.cgColor
        borderLine.strokeColor = mainColor.cgColor
        borderLine.lineWidth = lineWidth
        borderLine.path = pathForBorder().cgPath

        self.layer.addSublayer(borderLine)
        self.layer.addSublayer(downloadingLine)
        self.layer.addSublayer(downloadingProgressLine)
    }

    private func addTitle() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(titleLabel)
        let constraints = NSLayoutConstraint.constraints(withVisualFormat: "|-0-[title]-0-|", options: [], metrics: [:], views: ["title": titleLabel]) + NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[title]-0-|", options: [], metrics: [:], views: ["title": titleLabel])
        NSLayoutConstraint.activate(constraints)
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 1
        titleLabel.text = title
        titleLabel.textColor = titleColor
        titleLabel.font = titleFont

        titleLabelOpen.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(titleLabelOpen)
        let constraintsDone = NSLayoutConstraint.constraints(withVisualFormat: "|-0-[title]-0-|", options: [], metrics: [:], views: ["title": titleLabelOpen]) + NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[title]-0-|", options: [], metrics: [:], views: ["title": titleLabelOpen])
        NSLayoutConstraint.activate(constraintsDone)

        titleLabelOpen.textAlignment = .center
        titleLabelOpen.numberOfLines = 1
        titleLabelOpen.text = titleOpen
        titleLabelOpen.textColor = titleColorDone
        titleLabelOpen.font = titleFont

        switch installState {
        case .open:
            titleLabel.isHidden = true
            titleLabelOpen.isHidden = false
        default:
            titleLabel.isHidden = false
            titleLabelOpen.isHidden = true
        }
    }

    private var installState: InstallStates = .wait {
        willSet(newValue) {
            if newValue != installState {
                switch newValue {
                case .open:
                    titleLabel.isHidden = true
                    titleLabelOpen.isHidden = false
                case .wait:
                    titleLabel.isHidden = false
                    titleLabelOpen.isHidden = true
                default:
                    break
                }
            }
        }
    }

    // 状态更新，开始动画
    private var animationState: AnimationStates = .none {
        willSet(newValue) {
            animationStateWillUpdate(to: newValue)
        }
    }

    private func animationStateWillUpdate(to newValue: AnimationStates) {
        switch newValue {
        case .borderToCircle:
            borderLine.path = pathForBorder().cgPath
            borderLine.strokeStart = 0
            borderLine.strokeEnd = 0
            borderLine.strokeColor = mainColor.cgColor

            downloadingLine.strokeStart = 0
            downloadingLine.strokeEnd = 0.85
            downloadingLine.strokeColor = mainColor.cgColor
        case .borderToCircleReverse:
            borderLine.strokeStart = 0
            borderLine.strokeEnd = 1
            borderLine.strokeColor = mainColor.cgColor

            downloadingLine.strokeStart = 0
            downloadingLine.strokeEnd = 0
            downloadingLine.strokeColor = mainColor.cgColor
        case .rotateToEnd:
            downloadingProgressLine.strokeStart = 0
            downloadingProgressLine.strokeEnd = 0
            downloadingLine.strokeStart = 0
            downloadingLine.strokeEnd = 1
        case .downloading:
            downloadingProgressLine.strokeColor = downloadingColor.cgColor
        case .downloadingReverse:
            downloadingProgressLine.strokeStart = 0
            downloadingProgressLine.strokeEnd = 0
            downloadingLine.strokeStart = 0
            downloadingLine.strokeEnd = 1
        case .done:
            borderLine.path = pathForBorder().reversing().cgPath
            borderLine.strokeStart = 0
            borderLine.strokeEnd = 1

            downloadingLine.strokeStart = 0
            downloadingLine.strokeEnd = 0
            downloadingProgressLine.strokeStart = 1
            downloadingProgressLine.strokeEnd = 1
        default:
            break
        }
    }

    private func getCenter() -> CGPoint {
        guard let center = self.superview?.convert(self.center, to: self) else {
            return CGPoint.zero
        }
        return center
    }

    private func getRaduis() -> CGFloat {
        let minSize = min(self.bounds.maxY, self.bounds.maxX)
        return (minSize / 2)
    }

    private func pathForCircle() -> UIBezierPath {
        let path = UIBezierPath()
        path.lineWidth = lineWidth
        path.addArc(withCenter: getCenter(), radius: getRaduis(), startAngle: CGFloat.pi * 1.5, endAngle: CGFloat.pi * 3.5, clockwise: true)
        return path
    }

    private enum Sides {
        case left
        case right
    }

    private func pathForBorder() -> UIBezierPath {
        func getCenter(for side: Sides) -> CGPoint {
            var center = self.getCenter()
            switch side {
            case .left:
                center.x -= (self.bounds.maxX / 2 - (getRaduis() + lineWidth / 2))
            case .right:
                center.x += (self.bounds.maxX / 2 - (getRaduis() + lineWidth / 2))
            }
            return center
        }

        let path = UIBezierPath()
        path.lineWidth = lineWidth
        let centerLeft = getCenter(for: .left)
        let centerRight = getCenter(for: .right)
        let radius = getRaduis()

        path.move(to: CGPoint(x: (centerLeft.x + centerRight.x)/2, y: centerLeft.y - radius))
        path.addLine(to: CGPoint(x: centerLeft.x, y: centerLeft.y - radius))
        path.addArc(withCenter: centerLeft, radius: radius, startAngle: CGFloat.pi * 1.5, endAngle: CGFloat.pi * 2.5, clockwise: false)
        path.addLine(to: CGPoint(x: centerRight.x, y: centerRight.y + radius))
        path.addArc(withCenter: centerRight, radius: radius, startAngle: CGFloat.pi * 2.5, endAngle: CGFloat.pi * 1.5, clockwise: false)
        path.addLine(to: CGPoint(x: (centerLeft.x + centerRight.x)/2, y: centerLeft.y - radius))
        path.close()

        return path
    }

    private func animateBackgroundTo(fadeIn: Bool) {
        layer.backgroundColor = fadeIn ? UIColor.white.cgColor : mainColor.cgColor
        let animationDuration = 0.1
        let bgAnimation = getAnimation(path: .backgroundColor, from: layer.presentation()!.backgroundColor!, to: fadeIn ? UIColor.white.cgColor : mainColor.cgColor, duration: animationDuration, timing: .linear)
        layer.removeAllAnimations()
        layer.add(bgAnimation, forKey: AnimationKeys.backgroundColorChange)
    }

    // 点击事件
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        switch installState {
        case .wait: fallthrough
        case .open:
            animateBackgroundTo(fadeIn: true)
        default:
            break
        }
    }

    override public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        switch installState {
        case .open:
            animateBackgroundTo(fadeIn: false)
            delegate?.openClick()
            break
        case .wait:
            animateBorderToCircle()
            delegate?.install()
            hideTitle(true)
        default:
            break
        }
    }

    public func setState(_ state: InstallStates) {
        switch state {
        case .open:
            installState = .open
            animationState = .done
        case .downloading:
            installState = .downloading
        default:
            installState = .wait
            animationState = .none
        }
    }

    // 下载进度
    public func downloadingProgressChanged(to newValue: CGFloat) {
        animateDownloading(value: max(0, min(1, newValue)))
    }

    private func hideTitle(_ isHidden: Bool) {
        UIView.transition(with: titleLabel, duration: 0.1, options: [.transitionCrossDissolve, .curveEaseOut], animations: { [weak self] in
            if let wSelf = self {
                wSelf.titleLabel.isHidden = isHidden
            }}, completion: nil)
    }

    private enum AnimationKeyPath: String {
        case backgroundColor
        case strokeEnd
        case strokeStart
        case strokeColor
        case transformRotation = "transform.rotation"
    }

    private enum TimitgKey: String {
        case easeOut
        case easeIn
        case linear
    }

    private let timingFunction =  [
        "easeOut": kCAMediaTimingFunctionEaseOut,
        "easeIn": kCAMediaTimingFunctionEaseIn,
        "linear": kCAMediaTimingFunctionLinear
    ]

    private func getAnimation(path key: AnimationKeyPath, from fromValue: Any, to toValue: Any, duration: Double, timing: TimitgKey) -> CABasicAnimation {
        let basicAnimation = CABasicAnimation(keyPath: key.rawValue)
        basicAnimation.fromValue = fromValue
        basicAnimation.toValue = toValue
        basicAnimation.timingFunction = CAMediaTimingFunction(name: timingFunction[timing.rawValue]!)
        basicAnimation.fillMode = kCAFillModeForwards
        basicAnimation.duration = duration

        return basicAnimation
    }

    private struct AnimationKeys {
        static let backgroundColorChange = "backgroundColorAnimation"
        static let borderStrokeEnd = "borderStrokeEndAnimation"
        static let downloadingLineStrokeEnd = "downloadingLineStrokeEndAnimation"
        static let circleTransformRotation = "transform.rotation"
        static let downloadindAnimation = "downloadindAnimation"
    }

    // 1. 圆角矩形变圆形
    private func animateBorderToCircle() {
        guard animationState == .none else {
            return
        }
        installState = .connecting
        animationState = .borderToCircle
        let animationDuration = 0.2
        let downloadingLineStrokeEndAnimation = getAnimation(path: .strokeEnd, from: 0, to: 0.85, duration: animationDuration, timing: .easeIn)
        let borderStrokeEndAnimation = getAnimation(path: .strokeEnd, from: 1, to: 0, duration: animationDuration, timing: .easeOut)
        CATransaction.begin()
        CATransaction.setCompletionBlock { [weak self] in
            if let wSelf = self {
                wSelf.animateCircleRotation()
            }
        }
        borderLine.removeAllAnimations()
        downloadingLine.removeAllAnimations()
        borderLine.add(borderStrokeEndAnimation, forKey: AnimationKeys.borderStrokeEnd)
        downloadingLine.add(downloadingLineStrokeEndAnimation, forKey: AnimationKeys.downloadingLineStrokeEnd)
        CATransaction.commit()
    }

    // 圆圈旋转
    private func animateCircleRotation() {
        guard animationState == .borderToCircle else {
            return
        }
        animationState = .circleRotation
        let circleRotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        circleRotateAnimation.fromValue = 0
        circleRotateAnimation.toValue = CGFloat.pi * 2
        circleRotateAnimation.duration = 1
        circleRotateAnimation.repeatCount = Float.greatestFiniteMagnitude
        CATransaction.begin()
        downloadingLine.removeAllAnimations()
        downloadingLine.add(circleRotateAnimation, forKey: AnimationKeys.circleTransformRotation)
        CATransaction.commit()
    }

    // 圆圈进度
    private func animateDownloading(value: CGFloat) {
        guard installState == .downloading else {
            return
        }
        downloadingProgressLine.strokeEnd = value
        downloadingProgressLine.strokeStart = 0
        downloadingLine.strokeStart = value
        let animationDuration = 0.1
        let animationStart = prevValue == 0 ? 0 : downloadingProgressLine.presentation()!.strokeEnd

        let downloadingLineAnimation = getAnimation(path: .strokeStart, from: animationStart, to: value, duration: animationDuration, timing: .linear)
        let downloadingAnimation = getAnimation(path: .strokeEnd, from: animationStart, to: value, duration: animationDuration, timing: .linear)
        prevValue = value
        CATransaction.begin()
        CATransaction.setCompletionBlock { [weak self] in
            if value >= 1.0 {
                self?.animateDownloadingEnd()
            }
        }
        downloadingLine.removeAllAnimations()
        downloadingLine.add(downloadingLineAnimation, forKey: AnimationKeys.downloadindAnimation)
        downloadingProgressLine.removeAllAnimations()
        downloadingProgressLine.add(downloadingAnimation, forKey: AnimationKeys.downloadindAnimation)
        CATransaction.commit()
    }

    private func animateDownloadingEnd() {
        guard installState == .downloading else {
            return
        }

        let animationDuration = 1.0
        let strokeEndBorderAnimation = getAnimation(path: .strokeEnd, from: 0, to: 1, duration: animationDuration, timing: .easeIn)
        let strokeEndAnimation = getAnimation(path: .strokeStart, from: 0, to: 1, duration: animationDuration, timing: .easeOut)
        let lineColorAnimation = getAnimation(path: .strokeColor, from: downloadingColor.cgColor, to: mainColor.cgColor, duration: animationDuration, timing: .easeOut)
        CATransaction.begin()
        CATransaction.setCompletionBlock { [weak self] in
            self?.animateBackgroundTo(fadeIn: false)
            self?.setState(.open)
        }
        borderLine.removeAllAnimations()
        downloadingLine.removeAllAnimations()
        borderLine.add(strokeEndBorderAnimation, forKey: AnimationKeys.borderStrokeEnd)
        downloadingProgressLine.add(strokeEndAnimation, forKey: AnimationKeys.downloadingLineStrokeEnd)
        downloadingProgressLine.add(lineColorAnimation, forKey: AnimationKeys.backgroundColorChange)
        CATransaction.commit()
    }
}

