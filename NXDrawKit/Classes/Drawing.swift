//
//  Drawing.swift
//  NXDrawKit
//
//  Created by Nicejinux on 2016. 7. 22..
//  Copyright © 2016년 Nicejinux. All rights reserved.
//

import UIKit

public extension UIImage {
    public func asPNGData() -> NSData? {
        return UIImagePNGRepresentation(self)
    }
    
    public func asJPEGData(quality: CGFloat) -> NSData? {
        return UIImageJPEGRepresentation(self, quality);
    }
    
    public func asPNGImage() -> UIImage? {
        if let data = self.asPNGData() {
            return UIImage.init(data: data)
        }
        
        return nil
    }

    public func asJPGImage(quality: CGFloat) -> UIImage? {
        if let data = self.asJPEGData(quality) {
            return UIImage.init(data: data)
        }
        
        return nil
    }
}

public class Drawing: NSObject {
    public var stroke: UIImage?
    public var background: UIImage?
    
    public init(stroke: UIImage? = nil, background: UIImage? = nil) {
        self.stroke = stroke
        self.background = background
    }
}
