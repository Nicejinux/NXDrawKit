//
//  Palette.swift
//  NXDrawKit
//
//  Created by Nicejinux on 2016. 7. 12..
//  Copyright © 2016년 Nicejinux. All rights reserved.
//

import UIKit

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
    
    public func currentBrush() -> Brush {
        return self.brush
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
    
    public func paletteHeight() -> CGFloat {
        return self.totalHeight
    }
    
    private func setupColorView() {
        let view = UIView()
        self.addSubview(view)
        self.colorPaletteView = view
        
        var button: CircleButton?
        for index in 1...12 {
            let color: UIColor = self.color(index)
            button = CircleButton(diameter: self.buttonDiameter, color: color, opacity: 1.0)
            button?.frame = self.colorButtonRect(index: index, diameter: self.buttonDiameter, padding: self.buttonPadding)
            button?.addTarget(self, action:#selector(Palette.onClickColorPicker(_:)), forControlEvents: .TouchUpInside)
            self.colorPaletteView!.addSubview(button!)
            self.colorButtonList.append(button!)
        }
        
        self.totalHeight = CGRectGetMaxY(button!.frame) + self.buttonPadding;
        self.colorPaletteView?.frame = CGRectMake(0, 0, CGRectGetMaxX(button!.frame) + self.buttonPadding, self.totalHeight)
    }
    
    private func colorButtonRect(index index: NSInteger, diameter: CGFloat, padding: CGFloat) -> CGRect {
        var rect: CGRect = CGRectZero
        let indexValue = index - 1
        let count = self.columnCount
        rect.origin.x = (CGFloat(indexValue % count) * diameter) + padding + (CGFloat(indexValue % count) * padding)
        rect.origin.y = (CGFloat(indexValue / count) * diameter) + padding + (CGFloat(indexValue / count) * padding)
        rect.size = CGSizeMake(diameter, diameter)
        
        return rect
    }
    
    private func setupAlphaView() {
        let view = UIView()
        self.addSubview(view)
        self.alphaPaletteView = view
        
        var button: CircleButton?
        for index in (1...3).reverse() {
            let opacity = self.opacity(index)
            button = CircleButton(diameter: buttonDiameter, color: UIColor.blackColor(), opacity: opacity)
            button?.frame = self.alphaButtonRect(index: index, diameter: self.buttonDiameter, padding: self.buttonPadding)
            self.alphaPaletteView!.addSubview(button!)
            button?.addTarget(self, action: #selector(Palette.onClickAlphaPicker(_:)), forControlEvents: .TouchUpInside)
            self.alphaButtonList.append(button!)
        }
        
        let startX = CGRectGetMaxX((self.colorPaletteView?.frame)!)
        self.alphaPaletteView?.frame = CGRectMake(startX, 0, CGRectGetMaxX(button!.frame) + self.buttonPadding, self.totalHeight)
    }
    
    private func alphaButtonRect(index index: NSInteger, diameter: CGFloat, padding: CGFloat) -> CGRect {
        var rect: CGRect = CGRectZero
        let indexValue = index - 1
        rect.origin.x = padding
        rect.origin.y = CGFloat(indexValue) * diameter + padding + (CGFloat(indexValue) * padding)
        rect.size = CGSizeMake(diameter, diameter)
        
        return rect
    }
    
    private func setupWidthView() {
        let view = UIView()
        self.addSubview(view)
        self.widthPaletteView = view
        
        var button: CircleButton?
        var lastY: CGFloat = 4
        for index in 1...4 {
            let buttonDiameter = self.brushWidth(index)
            button = CircleButton(diameter: buttonDiameter, color: UIColor.blackColor(), opacity: 1)
            button?.frame = self.widthButtonRect(buttonDiameter, padding: self.buttonPadding, lastY: lastY)
            self.widthPaletteView!.addSubview(button!)
            button?.addTarget(self, action: #selector(Palette.onClickWidthPicker(_:)), forControlEvents: .TouchUpInside)

            lastY = CGRectGetMaxY((button?.frame)!)
            self.widthButtonList.append(button!)
        }
        
        let startX = CGRectGetMaxX((self.alphaPaletteView?.frame)!)
        self.widthPaletteView?.frame = CGRectMake(startX, 0, CGRectGetMaxX(button!.frame) + self.buttonPadding, self.totalHeight)
    }
    
    private func widthButtonRect(diameter: CGFloat, padding: CGFloat, lastY: CGFloat) -> CGRect {
        var rect: CGRect = CGRectZero
        rect.origin.x = padding + ((self.buttonDiameter - diameter) / 2)
        rect.origin.y = lastY + padding
        rect.size = CGSizeMake(diameter, diameter)
        
        return rect
    }

    private func setupDefaultValues() {
        var button: CircleButton = self.colorButtonList.first!
        button.selected = true
        self.brush.color = button.color!
        
        button = self.alphaButtonList.first!
        button.selected = true
        self.brush.alpha = button.opacity!
        
        button = self.widthButtonList.last!
        button.selected = true
        self.brush.width = button.diameter!
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

    private func brushWidth(tag: NSInteger) -> CGFloat {
        if let width = self.delegate?.widthWithTag?(tag) {
            if 0 > width || width > self.buttonDiameter {
                return self.buttonDiameter * (CGFloat(tag) / 4.0)
            }
            return width
        }
        return self.buttonDiameter * (CGFloat(tag) / 4.0)
    }
}
