//
//  ToolBar.swift
//  NXDrawKit
//
//  Created by Nicejinux on 7/13/16.
//  Copyright © 2016 Nicejinux. All rights reserved.
//

import UIKit

public class ToolBar: UIView
{
    public weak var undoButton: UIButton?
    public weak var redoButton: UIButton?
    public weak var saveButton: UIButton?
    public weak var loadButton: UIButton?
    public weak var clearButton: UIButton?
    
    private weak var lineView: UIView?

    // MARK: - Public Methods
    public init() {
        super.init(frame: CGRectZero)
        self.initialize()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func initialize() {
        self.setupViews()
        self.setupLayout()
    }
    
    // MARK: - Private Methods
    private func setupViews() {
        self.backgroundColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1.0)
        
        let lineView = UIView()
        lineView.backgroundColor = UIColor(red: 0.18, green: 0.18, blue: 0.18, alpha: 1.0)
        self.addSubview(lineView)
        self.lineView = lineView
        self.lineView?.autoresizingMask = [.FlexibleWidth, .FlexibleTopMargin]
        
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
    
    private func setupLayout() {
        self.lineView?.frame = CGRectMake(0, self.y - 1, self.width, 1)
        
        self.undoButton?.frame = CGRectMake(15, 0, self.height * 0.5, self.height * 0.5)
        self.undoButton?.center = CGPointMake((self.undoButton?.center.x)!, self.height / 2.0)

        self.redoButton?.frame = CGRectMake(CGRectGetMaxX((self.undoButton?.frame)!) + 20, 0, self.height * 0.5, self.height * 0.5)
        self.redoButton?.center = CGPointMake((self.redoButton?.center.x)!, self.height / 2.0)

        self.saveButton?.frame = CGRectMake(self.width - (self.width * 0.1) - 15, 0, self.width * 0.1, self.width * 0.1)
        self.saveButton?.center = CGPointMake((self.saveButton?.center.x)!, self.height / 2.0)

        self.clearButton?.frame = CGRectMake(CGRectGetMinX((self.saveButton?.frame)!) - (self.width * 0.1) - 15, 0, self.width * 0.1, self.width * 0.1)
        self.clearButton?.center = CGPointMake((self.clearButton?.center.x)!, self.height / 2.0)

        self.loadButton?.frame = CGRectMake(0, 0, self.width * 0.1, self.width * 0.1)
        self.loadButton?.center = CGPointMake(self.width / 2.0, self.height / 2.0)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        self.setupLayout()
    }
    
    private func button(title: String? = nil, iconName: String? = nil) -> UIButton {
        let button = UIButton()
        button.backgroundColor = UIColor.clearColor()
        
        if title != nil {
            button.titleLabel?.font = UIFont.boldSystemFontOfSize(15 * self.multiflierForDevice())
            button.setTitle(title, forState: .Normal)
            button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
            button.setTitleColor(UIColor.grayColor(), forState: .Disabled)
        }

        if iconName != nil {
            let podBundle = NSBundle(forClass: self.classForCoder)
            if let bundleURL = podBundle.URLForResource("NXDrawKit", withExtension: "bundle") {
                if let bundle = NSBundle(URL: bundleURL) {
                    let image = UIImage(named: iconName!, inBundle: bundle, compatibleWithTraitCollection: nil)
                    button.setImage(image, forState: .Normal)
                }
            }
        }
        
        button.enabled = false
        
        return button
    }
    
    private func multiflierForDevice() -> CGFloat {
        if UIScreen.mainScreen().bounds.size.width <= 320 {
            return 0.75
        } else if UIScreen.mainScreen().bounds.size.width > 375 {
            return 1.0
        } else {
            return 0.9
        }
    }
}
