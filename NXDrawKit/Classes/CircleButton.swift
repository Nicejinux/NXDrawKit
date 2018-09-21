//
//  CircleButton.swift
//  NXDrawKit
//
//  Created by Nicejinux on 2016. 7. 12..
//  Copyright © 2016년 Nicejinux. All rights reserved.
//

import UIKit


class CircleButton: UIButton {
    @objc var color: UIColor!
    var opacity: CGFloat!
    var diameter: CGFloat!
    override var isSelected: Bool {
        willSet(selectedValue) {
            super.isSelected = selectedValue
            let isBright = self.color.isEqual(UIColor.white) || self.color.isEqual(UIColor.clear)
            let selectedColor = !self.isEnabled ? UIColor.clear : isBright ? UIColor.gray : UIColor.white
            self.layer.borderColor = self.isSelected ? selectedColor.cgColor : self.color?.cgColor
        }
    }
    
    override var isEnabled: Bool {
        willSet(enabledValue) {
            super.isEnabled = enabledValue
            
            // if button is disabled, selected color should be changed to clear color
            let selected = self.isSelected
            self.isSelected = selected
        }
    }
    
    
    // MARK: - Initializer
    @objc init(diameter: CGFloat, color: UIColor, opacity: CGFloat) {
        super.init(frame: CGRect.init(x: 0, y: 0, width: diameter, height: diameter))
        self.initialize(diameter, color: color, opacity: opacity)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    private func initialize(_ diameter: CGFloat, color: UIColor, opacity: CGFloat) {
        self.color = color
        self.opacity = opacity
        self.diameter = diameter
        
        self.layer.cornerRadius = diameter / 2.0
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = (diameter > 3) ? 3.0 : diameter / 3.0
        self.backgroundColor = color.withAlphaComponent(opacity)
        
        if self.color.isEqual(UIColor.clear) {
            self.setBackgroundImage(self.image("icon_eraser"), for: UIControl.State())
        }
    }
    

    // MARK: - Internal Methods
    @objc internal func update(_ color: UIColor) {
        self.color = color
        self.isSelected = super.isSelected
        self.backgroundColor = color.withAlphaComponent(self.opacity!)
    }
    

    // MARK: - Private Methods
    private func image(_ name: String) -> UIImage? {
        let podBundle = Bundle(for: self.classForCoder)
        if let bundleURL = podBundle.url(forResource: "NXDrawKit", withExtension: "bundle") {
            if let bundle = Bundle(url: bundleURL) {
                let image = UIImage(named: name, in: bundle, compatibleWith: nil)
                return image
            }
        }
        return nil
    }
}
