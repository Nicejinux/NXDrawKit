//
//  Palette.swift
//  NXDrawKit
//
//  Created by Nicejinux on 2016. 7. 12..
//  Copyright © 2016년 Nicejinux. All rights reserved.
//

import UIKit
import SnapKit

@objc public protocol PaletteDelegate
{
    optional func didChangeBrushAlpha(alpha:CGFloat)
    optional func didChangeBrushWidth(width:CGFloat)
    optional func didChangeBrushColor(color:UIColor)
    
    optional func colorWithTag(tag: NSInteger) -> UIColor?
    optional func alphaWithTag(tag: NSInteger) -> CGFloat
    optional func widthWithTag(tag: NSInteger) -> CGFloat
}


public class Palette: UIView
{
    public weak var delegate: PaletteDelegate?
    private var brush: Brush = Brush()

    private let buttonDiameter = CGRectGetWidth(UIScreen.mainScreen().bounds) / 10.0
    private let buttonPadding = CGRectGetWidth(UIScreen.mainScreen().bounds) / 25.0
    private let columnCount = 4
    
    private var colorButtonList = [CircleButton]()
    private var alphaButtonList = [CircleButton]()
    private var widthButtonList = [CircleButton]()
    
    private var totalHeight: CGFloat = 0.0;
    
    private weak var colorPaletteView: UIView?
    private weak var alphaPaletteView: UIView?
    private weak var widthPaletteView: UIView?
    
    // MARK: - Public Methods
    public init() {
        super.init(frame: CGRectZero)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    

    // MARK: - Private Methods
    override public func intrinsicContentSize() -> CGSize {
        let size: CGSize = CGSizeMake(UIScreen().bounds.size.width, self.totalHeight)
        return size;
    }
    
    public func setup() {
        self.backgroundColor = UIColor(colorLiteralRed: 0.22, green: 0.22, blue: 0.21, alpha: 1.0)
        self.setupColorView()
        self.setupAlphaView()
        self.setupWidthView()
        self.setupDefaultValues()
    }
    
    private func setupColorView() {
        let view = UIView()
        self.addSubview(view)
        self.colorPaletteView = view
        
        var left: ConstraintItem = self.colorPaletteView!.snp_left
        var top: ConstraintItem = self.colorPaletteView!.snp_top
        var button: CircleButton?
        
        for index in 1...12 {
            let color: UIColor = self.color(index)
            button = CircleButton(diameter: self.buttonDiameter, color: color, opacity: 1.0)
            button?.addTarget(self, action:#selector(Palette.onClickColorPicker(_:)), forControlEvents: .TouchUpInside)
            self.colorPaletteView!.addSubview(button!)
            button?.snp_makeConstraints(closure: { (make) in
                make.left.equalTo(left).offset(self.buttonPadding)
                make.top.equalTo(top).offset(self.buttonPadding)
                make.size.equalTo(CGSizeMake(self.buttonDiameter, self.buttonDiameter))
            })

            if (index) % self.columnCount == 0 {
                left = self.colorPaletteView!.snp_left
                top = button!.snp_bottom
                self.totalHeight += self.buttonDiameter + self.buttonPadding
            } else {
                left = button!.snp_right
            }
            
            self.colorButtonList.append(button!)
        }
        
        self.totalHeight += self.buttonPadding;
        self.colorPaletteView?.snp_makeConstraints(closure: { (make) in
            make.top.left.equalTo(self)
            make.right.equalTo(button!.snp_right).offset(self.buttonPadding)
            make.height.equalTo(self.totalHeight)
        })
    }
    
    private func setupAlphaView() {
        let view = UIView()
        self.addSubview(view)
        self.alphaPaletteView = view
        
        var top: ConstraintItem = self.alphaPaletteView!.snp_top
        var button: CircleButton?

        for index in (1...3).reverse() {
            let opacity = self.opacity(index)
            button = CircleButton(diameter: buttonDiameter, color: UIColor.blackColor(), opacity: opacity)
            self.alphaPaletteView!.addSubview(button!)
            button?.addTarget(self, action: #selector(Palette.onClickAlphaPicker(_:)), forControlEvents: .TouchUpInside)
            button?.snp_makeConstraints(closure: { (make) in
                make.left.equalTo(self.alphaPaletteView!).offset(self.buttonPadding)
                make.top.equalTo(top).offset(self.buttonPadding)
                make.size.equalTo(CGSizeMake(self.buttonDiameter, self.buttonDiameter))
            })
            
            top = button!.snp_bottom
            self.alphaButtonList.append(button!)
        }
        
        self.alphaPaletteView?.snp_makeConstraints(closure: { (make) in
            make.left.equalTo(self.colorPaletteView!.snp_right).offset(self.buttonPadding)
            make.top.equalTo(self)
            make.right.equalTo(button!.snp_right).offset(self.buttonPadding)
            make.height.equalTo(self.colorPaletteView!)
        })
    }
    
    private func setupWidthView() {
        let view = UIView()
        self.addSubview(view)
        self.widthPaletteView = view
        
        var bottom: ConstraintItem = self.widthPaletteView!.snp_bottom
        var button: CircleButton?
        for index in (1...4).reverse() {
            let buttonDiameter = self.width(index)
            button = CircleButton(diameter: buttonDiameter, color: UIColor.blackColor(), opacity: 1)
            self.widthPaletteView!.addSubview(button!)
            button?.addTarget(self, action: #selector(Palette.onClickWidthPicker(_:)), forControlEvents: .TouchUpInside)
            button?.snp_makeConstraints(closure: { (make) in
                make.bottom.equalTo(bottom).offset(-self.buttonPadding)
                make.centerX.equalTo(self.widthPaletteView!)
                make.size.equalTo(CGSizeMake(buttonDiameter, buttonDiameter))
            })
            
            bottom = button!.snp_top
            self.widthButtonList.append(button!)
        }
        
        self.widthPaletteView?.snp_makeConstraints(closure: { (make) in
            make.left.equalTo(self.alphaPaletteView!.snp_right)
            make.top.equalTo(self)
            make.width.equalTo(self.alphaPaletteView!)
            make.height.equalTo(self.colorPaletteView!)
        })
    }
    
    private func setupDefaultValues() {
        var button: CircleButton = self.colorButtonList.first!
        button.selected = true
        self.brush.color = button.color!
        
        button = self.alphaButtonList.first!
        button.selected = true
        self.brush.alpha = button.opacity!
        
        button = self.widthButtonList.first!
        button.selected = true
        self.brush.width = button.diameter!
    }
    
    private func rect(index index: NSInteger, diameter: CGFloat, padding: CGFloat) -> CGRect {
        var rect: CGRect = CGRectZero
        let indexValue = CGFloat(index)
        let count = CGFloat(self.columnCount)
        rect.origin.x = ((indexValue % count) * diameter) + padding + ((indexValue % count) * padding)
        rect.origin.y = ((indexValue / count) * diameter) + padding + ((indexValue / count) * padding)
        rect.size = CGSizeMake(diameter, diameter)
    
        return rect
    }
    
    @objc private func onClickColorPicker(button: CircleButton) {
        self.brush.color = button.color!;
        let shouldEnable = !self.brush.color.isEqual(UIColor.clearColor())

        self.resetButtonSelected(self.colorButtonList, button: button)
        self.updateColorOfButtons(self.widthButtonList, color: button.color!)
        self.updateColorOfButtons(self.alphaButtonList, color: button.color!, enable: shouldEnable)
        
        self.delegate?.didChangeBrushColor?(self.brush.color)
    }

    @objc private func onClickAlphaPicker(button: CircleButton) {
        self.brush.alpha = button.opacity!
        self.resetButtonSelected(self.alphaButtonList, button: button)
        
        self.delegate?.didChangeBrushAlpha?(self.brush.alpha)
    }

    @objc private func onClickWidthPicker(button: CircleButton) {
        self.brush.width = button.diameter!;
        self.resetButtonSelected(self.widthButtonList, button: button)
        
        self.delegate?.didChangeBrushWidth?(self.brush.alpha)
    }
    
    private func resetButtonSelected(list: [CircleButton], button: CircleButton) {
        for aButton: CircleButton in list {
            aButton.selected = aButton.isEqual(button)
        }
    }
    
    private func updateColorOfButtons(list: [CircleButton], color: UIColor, enable: Bool = true) {
        for aButton: CircleButton in list {
            aButton.update(color)
            aButton.enabled = enable
        }
    }
    
    private func color(tag: NSInteger) -> UIColor {
        if let color = self.delegate?.colorWithTag?(tag)  {
            return color
        }

        return self.colorWithTag(tag)
    }
    
    private func colorWithTag(tag: NSInteger) -> UIColor {
        switch(tag) {
            case 1:
                return UIColor.blackColor()
            case 2:
                return UIColor.darkGrayColor()
            case 3:
                return UIColor.grayColor()
            case 4:
                return UIColor.whiteColor()
            case 5:
                return UIColor(red: 0.8, green: 0.2, blue: 0.2, alpha: 1.0)
            case 6:
                return UIColor.orangeColor()
            case 7:
                return UIColor.greenColor()
            case 8:
                return UIColor(red: 0.15, green: 0.47, blue: 0.23, alpha: 1.0)
            case 9:
                return UIColor(red: 0.2, green: 0.3, blue: 1.0, alpha: 1.0)
            case 10:
                return UIColor(red: 0.2, green: 0.8, blue: 1.0, alpha: 1.0)
            case 11:
                return UIColor(red: 0.62, green: 0.32, blue: 0.17, alpha: 1.0)
            case 12:
                return UIColor.yellowColor()
            default:
                return UIColor.blackColor()
        }
    }
    
    private func opacity(tag: NSInteger) -> CGFloat {
        if let opacity = self.delegate?.alphaWithTag?(tag) {
            if 0 > opacity || opacity > 1 {
                return CGFloat(tag) / 3.0
            }
            return opacity
        }

        return CGFloat(tag) / 3.0
    }

    private func width(tag: NSInteger) -> CGFloat {
        if let width = self.delegate?.widthWithTag?(tag) {
            if 0 > width  || width > self.buttonDiameter{
                return self.buttonDiameter * (CGFloat(tag) / 4.0)
            }
            return width
        }
        return self.buttonDiameter * (CGFloat(tag) / 4.0)
    }
    
    public func currentBrush() -> Brush {
        return self.brush
    }
}
