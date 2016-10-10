//
//  UIImageExtractExtension.swift
//  Pods
//
//  Created by Nicejinux on 2016. 8. 6..
//
//

import UIKit

public extension UIImage {
    public func asPNGData() -> Data? {
        return UIImagePNGRepresentation(self)
    }
    
    public func asJPEGData(_ quality: CGFloat) -> Data? {
        return UIImageJPEGRepresentation(self, quality);
    }
    
    public func asPNGImage() -> UIImage? {
        if let data = self.asPNGData() {
            return UIImage.init(data: data)
        }
        
        return nil
    }
    
    public func asJPGImage(_ quality: CGFloat) -> UIImage? {
        if let data = self.asJPEGData(quality) {
            return UIImage.init(data: data)
        }
        
        return nil
    }
}
