//
//  Drawing.swift
//  NXDrawKit
//
//  Created by Nicejinux on 2016. 7. 22..
//  Copyright © 2016년 Nicejinux. All rights reserved.
//

import UIKit


open class Drawing: NSObject {
    @objc open var stroke: UIImage?
    @objc open var background: UIImage?
    
    @objc public init(stroke: UIImage? = nil, background: UIImage? = nil) {
        self.stroke = stroke
        self.background = background
    }
}
