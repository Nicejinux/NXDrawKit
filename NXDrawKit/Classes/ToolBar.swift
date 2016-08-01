//
//  ToolBar.swift
//  NXDrawKit
//
//  Created by Nicejinux on 7/13/16.
//  Copyright © 2016 Nicejinux. All rights reserved.
//

import UIKit
import SnapKit

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
        self.lineView?.snp_makeConstraints(closure: { (make) in
            make.left.right.bottom.equalTo(self)
            make.height.equalTo(1)
        })
        
        self.undoButton?.snp_makeConstraints(closure: { (make) in
            make.left.equalTo(self).offset(15)
            make.centerY.equalTo(self)
            make.width.equalTo(self).multipliedBy(0.05)
            make.height.equalTo(self.undoButton!.snp_width)
        })
        
        self.redoButton?.snp_makeConstraints(closure: { (make) in
            make.left.equalTo(self.undoButton!.snp_right).offset(20)
            make.centerY.equalTo(self)
            make.width.equalTo(self).multipliedBy(0.05)
            make.height.equalTo(self.redoButton!.snp_width)
        })
        
        self.saveButton?.snp_makeConstraints(closure: { (make) in
            make.right.equalTo(self).offset(-15)
            make.centerY.equalTo(self)
            make.width.equalTo(self).multipliedBy(0.1)
            make.height.equalTo(self.saveButton!.snp_width)
        })
        
        self.clearButton?.snp_makeConstraints(closure: { (make) in
            make.right.equalTo((self.saveButton?.snp_left)!).offset(-15)
            make.centerY.equalTo(self)
            make.width.equalTo(self).multipliedBy(0.1)
            make.height.equalTo(self.clearButton!.snp_width)
        })

        self.loadButton?.snp_makeConstraints(closure: { (make) in
            make.center.equalTo(self)
            make.width.equalTo(self).multipliedBy(0.1)
            make.height.equalTo(self.loadButton!.snp_width)
        })
    }
    
    private func button(title: String? = nil, iconName: String? = nil) -> UIButton {
        let button = UIButton()
        button.backgroundColor = UIColor.clearColor()
        
        if title != nil {
            let scale = UIScreen.mainScreen().scale
            button.titleLabel?.font = UIFont.boldSystemFontOfSize(12 + scale)
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
}
