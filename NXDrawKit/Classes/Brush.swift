//
//  Brush.swift
//  NXDrawKit
//
//  Created by Nicejinux on 7/12/16.
//  Copyright © 2016 Nicejinux. All rights reserved.
//

import UIKit

public class Brush: NSObject {
    public var color: UIColor = UIColor.blackColor() {
        willSet(colorValue) {
            color = colorValue
            isEraser = color.isEqual(UIColor.clearColor())
            blendMode = isEraser ? .Clear : .Normal
        }
    }
    public var width: CGFloat = 5.0
    public var alpha: CGFloat = 1.0
    
    internal var blendMode: CGBlendMode = .Normal
    internal var isEraser: Bool = false
}
