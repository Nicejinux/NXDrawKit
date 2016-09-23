//
//  ToolBar.swift
//  NXDrawKit
//
//  Created by Nicejinux on 7/13/16.
//  Copyright © 2016 Nicejinux. All rights reserved.
//

import UIKit
import SnapKit

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
        self.lineView?.snp.makeConstraints({ (make) in
            make.left.right.bottom.equalTo(self)
            make.height.equalTo(1)
        })
        
        self.undoButton?.snp.makeConstraints({ (make) in
            make.left.equalTo(self).offset(15)
            make.centerY.equalTo(self)
            make.width.equalTo(self).multipliedBy(0.05)
            make.height.equalTo(self.undoButton!.snp.width)
        })
        
        self.redoButton?.snp.makeConstraints({ (make) in
            make.left.equalTo(self.undoButton!.snp.right).offset(20)
            make.centerY.equalTo(self)
            make.width.equalTo(self).multipliedBy(0.05)
            make.height.equalTo(self.redoButton!.snp.width)
        })
        
        self.saveButton?.snp.makeConstraints({ (make) in
            make.right.equalTo(self).offset(-15)
            make.centerY.equalTo(self)
            make.width.equalTo(self).multipliedBy(0.1)
            make.height.equalTo(self.saveButton!.snp.width)
        })
        
        self.clearButton?.snp.makeConstraints({ (make) in
            make.right.equalTo((self.saveButton?.snp.left)!).offset(-15)
            make.centerY.equalTo(self)
            make.width.equalTo(self).multipliedBy(0.1)
            make.height.equalTo(self.clearButton!.snp.width)
        })

        self.loadButton?.snp.makeConstraints({ (make) in
            make.center.equalTo(self)
            make.width.equalTo(self).multipliedBy(0.1)
            make.height.equalTo(self.loadButton!.snp.width)
        })
    }
    
    fileprivate func button(_ title: String? = nil, iconName: String? = nil) -> UIButton {
        let button = UIButton()
        button.backgroundColor = UIColor.clear
        
        if title != nil {
            let scale = UIScreen.main.scale
            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12 + scale)
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
}
