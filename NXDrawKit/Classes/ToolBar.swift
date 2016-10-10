//
//  ToolBar.swift
//  NXDrawKit
//
//  Created by Nicejinux on 7/13/16.
//  Copyright © 2016 Nicejinux. All rights reserved.
//

import UIKit

open class ToolBar: UIView
{
    open weak var undoButton: UIButton?
    open weak var redoButton: UIButton?
    open weak var saveButton: UIButton?
    open weak var loadButton: UIButton?
    open weak var clearButton: UIButton?
    
    fileprivate weak var lineView: UIView?

    // MARK: - Public Methods
    public init() {
        super.init(frame: CGRect.zero)
        self.initialize()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    fileprivate func initialize() {
        self.setupViews()
        self.setupLayout()
    }
    
    // MARK: - Private Methods
    fileprivate func setupViews() {
        self.backgroundColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1.0)
        
        let lineView = UIView()
        lineView.backgroundColor = UIColor(red: 0.18, green: 0.18, blue: 0.18, alpha: 1.0)
        self.addSubview(lineView)
        self.lineView = lineView
        self.lineView?.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
        
        var button: UIButton = self.button("Clear")
        self.addSubview(button)
        self.clearButton = button
        
        button = self.button(iconName: "icon_undo")
        self.addSubview(button)
        self.undoButton = button
        
        button = self.button(iconName: "icon_redo")
        self.addSubview(button)
        self.redoButton = button
        
        button = self.button("Save")
        self.addSubview(button)
        self.saveButton = button
        
        button = self.button(iconName: "icon_camera")
        self.addSubview(button)
        self.loadButton = button
    }
    
    fileprivate func setupLayout() {
        self.lineView?.frame = CGRect(x: 0, y: self.y - 1, width: self.width, height: 1)
        
        self.undoButton?.frame = CGRect(x: 15, y: 0, width: self.height * 0.5, height: self.height * 0.5)
        self.undoButton?.center = CGPoint(x: (self.undoButton?.center.x)!, y: self.height / 2.0)

        self.redoButton?.frame = CGRect(x: (self.undoButton?.frame)!.maxX + 20, y: 0, width: self.height * 0.5, height: self.height * 0.5)
        self.redoButton?.center = CGPoint(x: (self.redoButton?.center.x)!, y: self.height / 2.0)

        self.saveButton?.frame = CGRect(x: self.width - (self.width * 0.1) - 15, y: 0, width: self.width * 0.1, height: self.width * 0.1)
        self.saveButton?.center = CGPoint(x: (self.saveButton?.center.x)!, y: self.height / 2.0)

        self.clearButton?.frame = CGRect(x: (self.saveButton?.frame)!.minX - (self.width * 0.1) - 15, y: 0, width: self.width * 0.1, height: self.width * 0.1)
        self.clearButton?.center = CGPoint(x: (self.clearButton?.center.x)!, y: self.height / 2.0)

        self.loadButton?.frame = CGRect(x: 0, y: 0, width: self.width * 0.1, height: self.width * 0.1)
        self.loadButton?.center = CGPoint(x: self.width / 2.0, y: self.height / 2.0)
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        self.setupLayout()
    }
    
    fileprivate func button(_ title: String? = nil, iconName: String? = nil) -> UIButton {
        let button = UIButton()
        button.backgroundColor = UIColor.clear
        
        if title != nil {
            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15 * self.multiflierForDevice())
            button.setTitle(title, for: UIControlState())
            button.setTitleColor(UIColor.white, for: UIControlState())
            button.setTitleColor(UIColor.gray, for: .disabled)
        }

        if iconName != nil {
            let podBundle = Bundle(for: self.classForCoder)
            if let bundleURL = podBundle.url(forResource: "NXDrawKit", withExtension: "bundle") {
                if let bundle = Bundle(url: bundleURL) {
                    let image = UIImage(named: iconName!, in: bundle, compatibleWith: nil)
                    button.setImage(image, for: UIControlState())
                }
            }
        }
        
        button.isEnabled = false
        
        return button
    }
    
    fileprivate func multiflierForDevice() -> CGFloat {
        if UIScreen.main.bounds.size.width <= 320 {
            return 0.75
        } else if UIScreen.main.bounds.size.width > 375 {
            return 1.0
        } else {
            return 0.9
        }
    }
}
