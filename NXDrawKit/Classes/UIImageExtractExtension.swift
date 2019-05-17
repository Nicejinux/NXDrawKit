//
//  UIImageExtractExtension.swift
//  Pods
//
//  Created by Nicejinux on 2016. 8. 6..
//
//

import UIKit


public extension UIImage {
    @objc func asPNGData() -> Data? {
        return self.pngData()
    }
    
    @objc func asJPEGData(_ quality: CGFloat) -> Data? {
        return self.jpegData(compressionQuality: quality);
    }
    
    @objc func asPNGImage() -> UIImage? {
        if let data = self.asPNGData() {
            return UIImage(data: data)
        }
        
        return nil
    }
    
    @objc func asJPGImage(_ quality: CGFloat) -> UIImage? {
        if let data = self.asJPEGData(quality) {
            return UIImage(data: data)
        }
        
        return nil
    }
}
