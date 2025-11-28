//
//  UIView.swift
//  HttpRequest
//
//  Created by Mauro Juárez Zavaleta on 27/11/25.
//

import UIKit
extension UIView {
    func elevate(elevation: CGFloat = 10) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowOffset = CGSize(width: 0, height: elevation/2)
        layer.shadowRadius = elevation
    }
}
