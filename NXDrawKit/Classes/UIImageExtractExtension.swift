//
//  UIImageExtractExtension.swift
//  Pods
//
//  Created by Nicejinux on 2016. 8. 6..
//
//

import UIKit


public extension UIImage {
    @objc public func asPNGData() -> Data? {
        return self.pngData()
    }
    
    @objc public func asJPEGData(_ quality: CGFloat) -> Data? {
        return self.jpegData(compressionQuality: quality);
    }
    
    @objc public func asPNGImage() -> UIImage? {
        if let data = self.asPNGData() {
            return UIImage(data: data)
        }
        
        return nil
    }
    
    @objc public func asJPGImage(_ quality: CGFloat) -> UIImage? {
        if let data = self.asJPEGData(quality) {
            return UIImage(data: data)
        }
        
        return nil
    }
}
