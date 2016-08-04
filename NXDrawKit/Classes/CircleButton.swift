//
//  CircleButton.swift
//  NXDrawKit
//
//  Created by Nicejinux on 2016. 7. 12..
//  Copyright © 2016년 Nicejinux. All rights reserved.
//

import UIKit

class CircleButton: UIButton
{
    var color: UIColor!
    var opacity: CGFloat!
    var diameter: CGFloat!
    override var selected: Bool {
        willSet(selectedValue) {
            super.selected = selectedValue
            let isBright = self.color.isEqual(UIColor.whiteColor()) || self.color.isEqual(UIColor.clearColor())
            let selectedColor = !self.enabled ? UIColor.clearColor() : isBright ? UIColor.grayColor() : UIColor.whiteColor()
            self.layer.borderColor = self.selected ? selectedColor.CGColor : self.color?.CGColor
        }
    }
    
    override var enabled: Bool {
        willSet(enabledValue) {
            super.enabled = enabledValue
            
            // if button is disabled, selected color should be changed to clear color
            let selected = self.selected
            self.selected = selected
        }
    }
    
    // MARK: - Public Methods
    init(diameter: CGFloat, color: UIColor, opacity: CGFloat) {
        super.init(frame: CGRect.init(x: 0, y: 0, width: diameter, height: diameter))
        self.initialize(diameter, color: color, opacity: opacity)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    internal func update(color: UIColor) {
        self.color = color
        self.selected = super.selected
        self.backgroundColor = color.colorWithAlphaComponent(self.opacity!)
    }

    // MARK: - Private Methods
    private func initialize(diameter: CGFloat, color: UIColor, opacity: CGFloat) {
        self.color = color
        self.opacity = opacity
        self.diameter = diameter
        
        self.layer.cornerRadius = diameter / 2.0
        self.layer.borderColor = color.CGColor
        self.layer.borderWidth = (diameter > 3) ? 3.0 : diameter / 3.0
        self.backgroundColor = color.colorWithAlphaComponent(opacity)
        
        if self.color.isEqual(UIColor.clearColor()) {
            self.setBackgroundImage(self.image("icon_eraser"), forState: .Normal)
        }
    }
    
    private func image(name: String) -> UIImage? {
        let podBundle = NSBundle(forClass: self.classForCoder)
        if let bundleURL = podBundle.URLForResource("NXDrawKit", withExtension: "bundle") {
            if let bundle = NSBundle(URL: bundleURL) {
                let image = UIImage(named: name, inBundle: bundle, compatibleWithTraitCollection: nil)
                return image
            }
        }
        return nil
    }
    
}
