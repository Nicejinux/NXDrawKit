//
//  UIImageExtractExtension.swift
//  Pods
//
//  Created by Nicejinux on 2016. 8. 6..
//
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
