//
//  Canvas.swift
//  NXDrawKit
//
//  Created by Nicejinux on 7/14/16.
//  Copyright © 2016 Nicejinux. All rights reserved.
//

import UIKit

@objc public protocol CanvasDelegate
{
    optional func canvas(canvas: Canvas, didUpdateDrawing drawing: Drawing, mergedImage image: UIImage?)
    optional func canvas(canvas: Canvas, didSaveDrawing drawing: Drawing, mergedImage image: UIImage?)
    
    func brush() -> Brush?
}


public class Canvas: UIView, UITableViewDelegate
{
    public weak var delegate: CanvasDelegate?
    
    private var canvasId: String?
    
    private var mainImageView = UIImageView()
    private var tempImageView = UIImageView()
    private var backgroundImageView = UIImageView()
    
    private var brush = Brush()
    private let session = Session()
    private var drawing = Drawing()
    private let path = UIBezierPath()
    private let scale = UIScreen.mainScreen().scale

    private var saved = false
    private var pointMoved = false
    private var pointIndex = 0
    private var points = [CGPoint?](count: 5, repeatedValue: CGPointZero)
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public init(canvasId: String? = nil, backgroundImage image: UIImage? = nil) {
        super.init(frame: CGRectZero)
        self.path.lineCapStyle = .Round
        self.canvasId = canvasId
        self.backgroundImageView.image = image
        self.initialize()
    }
    
    private func initialize() {
        self.backgroundColor = UIColor.whiteColor()
        
        self.addSubview(self.backgroundImageView)
        self.backgroundImageView.contentMode = .ScaleAspectFit
        self.backgroundImageView.snp_makeConstraints(closure: { (make) in
            make.edges.equalTo(self)
        })
        
        self.addSubview(self.mainImageView)
        self.mainImageView.snp_makeConstraints(closure: { (make) in
            make.edges.equalTo(self)
        })

        self.addSubview(self.tempImageView)
        self.tempImageView.snp_makeConstraints(closure: { (make) in
            make.edges.equalTo(self)
        })
    }
    
    // MARK: - Private Methods
    private func compare(image1: UIImage?, isEqualTo image2: UIImage?) -> Bool {
        if (image1 == nil && image2 == nil) {
            return true
        } else if (image1 == nil || image2 == nil) {
            return false
        }
        
        let data1 = UIImagePNGRepresentation(image1!)
        let data2 = UIImagePNGRepresentation(image2!)

        if (data1 == nil || data2 == nil) {
            return false
        }

        return data1!.isEqual(data2)
    }
    
    private func currentDrawing() -> Drawing {
        return Drawing(stroke: self.mainImageView.image, background: self.backgroundImageView.image)
    }
    
    private func updateByLastSession() {
        let lastSession = self.session.lastSession()
        self.mainImageView.image = lastSession?.stroke
        self.backgroundImageView.image = lastSession?.background
    }
    
    private func didUpdateCanvas() {
        let mergedImage = self.mergePathsAndImages()
        let currentPaper = self.currentDrawing()
        self.delegate?.canvas?(self, didUpdateDrawing: currentPaper, mergedImage: mergedImage)
    }
    
    private func didSaveCanvas() {
        let mergedImage = self.mergePathsAndImages()
        self.delegate?.canvas?(self, didSaveDrawing: self.drawing, mergedImage: mergedImage)
    }
    
    private func isStrokeEqual() -> Bool {
        return self.compare(self.drawing.stroke, isEqualTo: self.mainImageView.image)
    }
    
    private func isBackgroundEqual() -> Bool {
        return self.compare(self.drawing.background, isEqualTo: self.backgroundImageView.image)
    }

    private func mergePathsAndImages() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.frame.size, false, 0)
        
        if self.backgroundImageView.image != nil {
            let rect = self.centeredBackgroundImageRect()
            self.backgroundImageView.image?.drawInRect(rect)       // draw background image
        }
        
        self.mainImageView.image?.drawInRect(self.bounds)  // draw stroke

        let mergedImage = UIGraphicsGetImageFromCurrentImageContext()  // merge
        
        UIGraphicsEndImageContext()
        
        return mergedImage
    }
    
    
    // MARK: - Override Methods
    public override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.saved = false
        self.pointMoved = false
        self.pointIndex = 0
        self.brush = (self.delegate?.brush())!
        
        let touch = touches.first!
        self.points[0] = touch.locationInView(self)
    }
    
    public override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /*
         * Smooth Freehand Drawing on iOS
         * http://code.tutsplus.com/tutorials/ios-sdk_freehand-drawing--mobile-13164
         *
         */

        let touch = touches.first!
        let currentPoint = touch.locationInView(self)
        self.pointMoved = true
        self.pointIndex += 1
        self.points[self.pointIndex] = currentPoint
        
        if self.pointIndex == 4 {
            // move the endpoint to the middle of the line joining the second control point of the first Bezier segment
            // and the first control point of the second Bezier segment
            self.points[3] = CGPointMake((self.points[2]!.x + self.points[4]!.x)/2.0, (self.points[2]!.y + self.points[4]!.y) / 2.0)

            // add a cubic Bezier from pt[0] to pt[3], with control points pt[1] and pt[2]
            self.path.moveToPoint(self.points[0]!)
            self.path.addCurveToPoint(self.points[3]!, controlPoint1: self.points[1]!, controlPoint2: self.points[2]!)
            
            // replace points and get ready to handle the next segment
            self.points[0] = self.points[3]
            self.points[1] = self.points[4]
            self.pointIndex = 1
        }
        
        self.strokePath()
    }
    
    public override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        self.touchesEnded(touches!, withEvent: event)
    }
    
    public override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if !self.pointMoved {   // touchesBegan -> touchesEnded : just touched
            self.path.moveToPoint(self.points[0]!)
            self.path.addLineToPoint(self.points[0]!)
            self.strokePath()
        }
        
        self.mergePaths()      // merge all paths
        self.didUpdateCanvas()
        
        self.path.removeAllPoints()
        self.pointIndex = 0
    }
    
    private func strokePath() {
        UIGraphicsBeginImageContextWithOptions(self.frame.size, false, 0)
        
        self.brush.color.colorWithAlphaComponent(self.brush.alpha).setStroke()
        self.path.lineWidth = (self.brush.width / self.scale)
        self.path.stroke()
        
        self.tempImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
    }
    
    private func mergePaths() {
        UIGraphicsBeginImageContextWithOptions(self.frame.size, false, 0)
        
        self.mainImageView.image?.drawInRect(self.bounds)
        self.tempImageView.image?.drawInRect(self.bounds)
        
        self.mainImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        self.session.append(self.currentPaper())
        self.tempImageView.image = nil
        
        UIGraphicsEndImageContext()
    }
    
    private func centeredBackgroundImageRect() -> CGRect {
        if CGSizeEqualToSize(self.frame.size, (self.backgroundImageView.image?.size)!) {
            return self.frame
        }
        
        let selfWidth = CGRectGetWidth(self.frame)
        let selfHeight = CGRectGetHeight(self.frame)
        let imageWidth = self.backgroundImageView.image?.size.width
        let imageHeight = self.backgroundImageView.image?.size.height
        
        let widthRatio = selfWidth / imageWidth!
        let heightRatio = selfHeight / imageHeight!
        let scale = min(widthRatio, heightRatio)
        let resizedWidth = scale * imageWidth!
        let resizedHeight = scale * imageHeight!
        
        var rect = CGRectZero
        rect.size = CGSizeMake(resizedWidth, resizedHeight)
        
        if selfWidth > resizedWidth {
            rect.origin.x = (selfWidth - resizedWidth) / 2
        }
        
        if selfHeight > resizedHeight {
            rect.origin.y = (selfHeight - resizedHeight) / 2
        }
        
        return rect
    }
    
    
    // MARK: - Public Methods
    public func update(backgroundImage: UIImage?) {
        self.backgroundImageView.image = backgroundImage
        self.session.append(self.currentDrawing())
        self.saved = self.canSave()
        self.didUpdateCanvas()
    }
    
    public func undo() {
        self.session.undo()
        self.updateByLastSession()
        self.saved = self.canSave()
        self.didUpdateCanvas()
    }

    public func redo() {
        self.session.redo()
        self.updateByLastSession()
        self.saved = self.canSave()
        self.didUpdateCanvas()
    }
    
    public func clear() {
        self.session.clear()
        self.updateByLastSession()
        self.saved = true
        self.didUpdateCanvas()
    }
    
    public func save() {
        self.drawing.stroke = self.mainImageView.image?.copy() as? UIImage
        self.drawing.background = self.backgroundImageView.image
        self.saved = true
        self.didSaveCanvas()
    }
    
    public func canUndo() -> Bool {
        return self.session.canUndo()
    }

    public func canRedo() -> Bool {
        return self.session.canRedo()
    }

    public func canClear() -> Bool {
        return self.session.canReset()
    }

    public func canSave() -> Bool {
        return !(self.isStrokeEqual() && self.isBackgroundEqual())
    }
}
