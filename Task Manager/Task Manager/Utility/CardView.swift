//
//  CardView.swift
//  Task Manager
//
//  Created by Mahfuz on 27/6/24.
//

import Foundation
import UIKit

@IBDesignable

class CardView: UIView {
    
    @IBInspectable var shadowOffsetWidth: Int = 0
    @IBInspectable var shadowOffsetHeight: Int = 3
    
    @IBInspectable var shadowCornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = shadowCornerRadius
        }
    }
    
    @IBInspectable var shadowColor: UIColor? {
        didSet {
            layer.shadowColor = shadowColor?.cgColor
        }
    }
    
    @IBInspectable var shadowOpacity: Float = 0.0 {
        didSet {
            layer.shadowOpacity = shadowOpacity
        }
    }
    
    
    override func layoutSubviews() {
        let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: shadowCornerRadius)
        layer.masksToBounds = false
        layer.shadowColor = shadowColor == nil ? UIColor.clear.cgColor : shadowColor!.cgColor
        layer.shadowOpacity = shadowOpacity
        layer.shadowOffset = CGSize(width: shadowOffsetWidth, height: shadowOffsetHeight);
        layer.shadowPath = shadowPath.cgPath
    }
}
