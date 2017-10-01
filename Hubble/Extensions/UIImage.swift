//
//  UIImage.swift
//  Hubble
//
//  Created by vimrus on 2017/10/1.
//  Copyright © 2017年 Hubble. All rights reserved.
//

import UIKit

extension UIImage {

    public func makeImageCornerRadius(radius: CGFloat) -> UIImage {
        let rect = CGRect(origin: CGPoint(x: 0,y: 0), size: self.size)

        UIGraphicsBeginImageContextWithOptions(self.size, false, UIScreen.main.scale)

        let path = UIBezierPath(roundedRect: rect, cornerRadius: radius)
        UIGraphicsGetCurrentContext()!.addPath(path.cgPath)

        UIGraphicsGetCurrentContext()?.clip()

        draw(in: rect)

        let image = UIGraphicsGetImageFromCurrentImageContext()

        UIGraphicsEndImageContext()

        return image!
    }

    public func makeImageCircle() -> UIImage {
        let size = self.size
        let width = size.width
        let height = size.height

        let radius = width >= height ? width : height

        let image = makeImageCornerRadius(radius: radius)

        return image
    }

    func imageResize(sizeChange:CGSize)-> UIImage{

        let hasAlpha = true
        let scale: CGFloat = 0.0 // Use scale factor of main screen

        UIGraphicsBeginImageContextWithOptions(sizeChange, !hasAlpha, scale)
        self.draw(in: CGRect(origin: CGPoint.zero, size: sizeChange))

        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        return scaledImage!
    }
}

extension UIImageView {
    public convenience init(frame: CGRect, image: UIImage, radius: CGFloat) {
        self.init(frame: frame)

        let image = image.makeImageCornerRadius(radius: radius)
        self.image = image
    }

    public convenience init(frame: CGRect, image: UIImage, cricle: Bool) {
        self.init(frame: frame)

        if cricle {
            let image = image.makeImageCircle()
            self.image = image
        } else {
            self.image = image
        }
    }
}
