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
    @objc optional func didChangeBrushAlpha(_ alpha:CGFloat)
    @objc optional func didChangeBrushWidth(_ width:CGFloat)
    @objc optional func didChangeBrushColor(_ color:UIColor)
    
    @objc optional func colorWithTag(_ tag: NSInteger) -> UIColor?
    @objc optional func alphaWithTag(_ tag: NSInteger) -> CGFloat
    @objc optional func widthWithTag(_ tag: NSInteger) -> CGFloat
}


open class Palette: UIView
{
    open weak var delegate: PaletteDelegate?
    fileprivate var brush: Brush = Brush()

    fileprivate let buttonDiameter = UIScreen.main.bounds.width / 10.0
    fileprivate let buttonPadding = UIScreen.main.bounds.width / 25.0
    fileprivate let columnCount = 4
    
    fileprivate var colorButtonList = [CircleButton]()
    fileprivate var alphaButtonList = [CircleButton]()
    fileprivate var widthButtonList = [CircleButton]()
    
    fileprivate var totalHeight: CGFloat = 0.0;
    
    fileprivate weak var colorPaletteView: UIView?
    fileprivate weak var alphaPaletteView: UIView?
    fileprivate weak var widthPaletteView: UIView?
    
    // MARK: - Public Methods
    public init() {
        super.init(frame: CGRect.zero)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    open func currentBrush() -> Brush {
        return self.brush
    }
    

    // MARK: - Private Methods
    override open var intrinsicContentSize : CGSize {
        let size: CGSize = CGSize(width: UIScreen().bounds.size.width, height: self.totalHeight)
        return size;
    }
    
    open func setup() {
        self.backgroundColor = UIColor(colorLiteralRed: 0.22, green: 0.22, blue: 0.21, alpha: 1.0)
        self.setupColorView()
        self.setupAlphaView()
        self.setupWidthView()
        self.setupDefaultValues()
    }
    
    fileprivate func setupColorView() {
        let view = UIView()
        self.addSubview(view)
        self.colorPaletteView = view
        
        var left: ConstraintItem = self.colorPaletteView!.snp.left
        var top: ConstraintItem = self.colorPaletteView!.snp.top
        var button: CircleButton?
        
        for index in 1...12 {
            let color: UIColor = self.color(index)
            button = CircleButton(diameter: self.buttonDiameter, color: color, opacity: 1.0)
            button?.addTarget(self, action:#selector(Palette.onClickColorPicker(_:)), for: .touchUpInside)
            self.colorPaletteView!.addSubview(button!)
            button?.snp.makeConstraints({ (make) in
                make.left.equalTo(left).offset(self.buttonPadding)
                make.top.equalTo(top).offset(self.buttonPadding)
                make.size.equalTo(CGSize(width:self.buttonDiameter, height:self.buttonDiameter))
            })

            if (index) % self.columnCount == 0 {
                left = self.colorPaletteView!.snp.left
                top = button!.snp.bottom
                self.totalHeight += self.buttonDiameter + self.buttonPadding
            } else {
                left = button!.snp.right
            }
            
            self.colorButtonList.append(button!)
        }
        
        self.totalHeight += self.buttonPadding;
        self.colorPaletteView?.snp.makeConstraints({ (make) in
            make.top.left.equalTo(self)
            make.right.equalTo(button!.snp.right).offset(self.buttonPadding)
            make.height.equalTo(self.totalHeight)
        })
    }
    
    fileprivate func setupAlphaView() {
        let view = UIView()
        self.addSubview(view)
        self.alphaPaletteView = view
        
        var top: ConstraintItem = self.alphaPaletteView!.snp.top
        var button: CircleButton?

        for index in (1...3).reversed() {
            let opacity = self.opacity(index)
            button = CircleButton(diameter: buttonDiameter, color: UIColor.black, opacity: opacity)
            self.alphaPaletteView!.addSubview(button!)
            button?.addTarget(self, action: #selector(Palette.onClickAlphaPicker(_:)), for: .touchUpInside)
            button?.snp.makeConstraints({ (make) in
                make.left.equalTo(self.alphaPaletteView!).offset(self.buttonPadding)
                make.top.equalTo(top).offset(self.buttonPadding)
                make.size.equalTo(CGSize(width:self.buttonDiameter, height:self.buttonDiameter))
            })
            
            top = button!.snp.bottom
            self.alphaButtonList.append(button!)
        }
        
        self.alphaPaletteView?.snp.makeConstraints({ (make) in
            make.left.equalTo(self.colorPaletteView!.snp.right).offset(self.buttonPadding)
            make.top.equalTo(self)
            make.right.equalTo(button!.snp.right).offset(self.buttonPadding)
            make.height.equalTo(self.colorPaletteView!)
        })
    }
    
    fileprivate func setupWidthView() {
        let view = UIView()
        self.addSubview(view)
        self.widthPaletteView = view
        
        var bottom: ConstraintItem = self.widthPaletteView!.snp.bottom
        var button: CircleButton?
        for index in (1...4).reversed() {
            let buttonDiameter = self.width(index)
            button = CircleButton(diameter: buttonDiameter, color: UIColor.black, opacity: 1)
            self.widthPaletteView!.addSubview(button!)
            button?.addTarget(self, action: #selector(Palette.onClickWidthPicker(_:)), for: .touchUpInside)
            button?.snp.makeConstraints({ (make) in
                make.bottom.equalTo(bottom).offset(-self.buttonPadding)
                make.centerX.equalTo(self.widthPaletteView!)
                make.size.equalTo(CGSize(width:buttonDiameter, height:buttonDiameter))
            })
            
            bottom = button!.snp.top
            self.widthButtonList.append(button!)
        }
        
        self.widthPaletteView?.snp.makeConstraints({ (make) in
            make.left.equalTo(self.alphaPaletteView!.snp.right)
            make.top.equalTo(self)
            make.width.equalTo(self.alphaPaletteView!)
            make.height.equalTo(self.colorPaletteView!)
        })
    }
    
    fileprivate func setupDefaultValues() {
        var button: CircleButton = self.colorButtonList.first!
        button.isSelected = true
        self.brush.color = button.color!
        
        button = self.alphaButtonList.first!
        button.isSelected = true
        self.brush.alpha = button.opacity!
        
        button = self.widthButtonList.first!
        button.isSelected = true
        self.brush.width = button.diameter!
    }
    
    fileprivate func rect(index: NSInteger, diameter: CGFloat, padding: CGFloat) -> CGRect {
        var rect: CGRect = CGRect.zero
        let indexValue = CGFloat(index)
        let count = CGFloat(self.columnCount)
        rect.origin.x = ((indexValue.truncatingRemainder(dividingBy: count)) * diameter) + padding + ((indexValue.truncatingRemainder(dividingBy: count)) * padding)
        rect.origin.y = ((indexValue / count) * diameter) + padding + ((indexValue / count) * padding)
        rect.size = CGSize(width: diameter, height: diameter)
    
        return rect
    }
    
    @objc fileprivate func onClickColorPicker(_ button: CircleButton) {
        self.brush.color = button.color!;
        let shouldEnable = !self.brush.color.isEqual(UIColor.clear)

        self.resetButtonSelected(self.colorButtonList, button: button)
        self.updateColorOfButtons(self.widthButtonList, color: button.color!)
        self.updateColorOfButtons(self.alphaButtonList, color: button.color!, enable: shouldEnable)
        
        self.delegate?.didChangeBrushColor?(self.brush.color)
    }

    @objc fileprivate func onClickAlphaPicker(_ button: CircleButton) {
        self.brush.alpha = button.opacity!
        self.resetButtonSelected(self.alphaButtonList, button: button)
        
        self.delegate?.didChangeBrushAlpha?(self.brush.alpha)
    }

    @objc fileprivate func onClickWidthPicker(_ button: CircleButton) {
        self.brush.width = button.diameter!;
        self.resetButtonSelected(self.widthButtonList, button: button)
        
        self.delegate?.didChangeBrushWidth?(self.brush.alpha)
    }
    
    fileprivate func resetButtonSelected(_ list: [CircleButton], button: CircleButton) {
        for aButton: CircleButton in list {
            aButton.isSelected = aButton.isEqual(button)
        }
    }
    
    fileprivate func updateColorOfButtons(_ list: [CircleButton], color: UIColor, enable: Bool = true) {
        for aButton: CircleButton in list {
            aButton.update(color)
            aButton.isEnabled = enable
        }
    }
    
    fileprivate func color(_ tag: NSInteger) -> UIColor {
        if let color = self.delegate?.colorWithTag?(tag)  {
            return color
        }

        return self.colorWithTag(tag)
    }
    
    fileprivate func colorWithTag(_ tag: NSInteger) -> UIColor {
        switch(tag) {
            case 1:
                return UIColor.black
            case 2:
                return UIColor.darkGray
            case 3:
                return UIColor.gray
            case 4:
                return UIColor.white
            case 5:
                return UIColor(red: 0.8, green: 0.2, blue: 0.2, alpha: 1.0)
            case 6:
                return UIColor.orange
            case 7:
                return UIColor.green
            case 8:
                return UIColor(red: 0.15, green: 0.47, blue: 0.23, alpha: 1.0)
            case 9:
                return UIColor(red: 0.2, green: 0.3, blue: 1.0, alpha: 1.0)
            case 10:
                return UIColor(red: 0.2, green: 0.8, blue: 1.0, alpha: 1.0)
            case 11:
                return UIColor(red: 0.62, green: 0.32, blue: 0.17, alpha: 1.0)
            case 12:
                return UIColor.yellow
            default:
                return UIColor.black
        }
    }
    
    fileprivate func opacity(_ tag: NSInteger) -> CGFloat {
        if let opacity = self.delegate?.alphaWithTag?(tag) {
            if 0 > opacity || opacity > 1 {
                return CGFloat(tag) / 3.0
            }
            return opacity
        }

        return CGFloat(tag) / 3.0
    }

    fileprivate func width(_ tag: NSInteger) -> CGFloat {
        if let width = self.delegate?.widthWithTag?(tag) {
            if 0 > width  || width > self.buttonDiameter{
                return self.buttonDiameter * (CGFloat(tag) / 4.0)
            }
            return width
        }
        return self.buttonDiameter * (CGFloat(tag) / 4.0)
    }
}
