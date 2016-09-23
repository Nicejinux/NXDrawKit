//
//  Brush.swift
//  NXDrawKit
//
//  Created by Nicejinux on 7/12/16.
//  Copyright © 2016 Nicejinux. All rights reserved.
//

import UIKit

open class Brush: NSObject {
    open var color: UIColor = UIColor.black {
        willSet(colorValue) {
            color = colorValue
            isEraser = color.isEqual(UIColor.clear)
            blendMode = isEraser ? .clear : .normal
        }
    }
    open var width: CGFloat = 5.0
    open var alpha: CGFloat = 1.0
    
    internal var blendMode: CGBlendMode = .normal
    internal var isEraser: Bool = false
}
