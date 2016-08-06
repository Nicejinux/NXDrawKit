//
//  ViewController.swift
//  NXDrawKit
//
//  Created by Nicejinux on 2016. 7. 12..
//  Copyright © 2016년 Nicejinux. All rights reserved.
//

import UIKit
import SnapKit
import NXDrawKit
import RSKImageCropper
import AVFoundation
import MobileCoreServices

class ViewController: UIViewController
{
    weak var canvasView: Canvas?
    weak var paletteView: Palette?
    weak var toolBar: ToolBar?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialize()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func initialize() {
        self.setupCanvas()
        self.setupPalette()
        self.setupToolBar()
    }
    
    private func setupPalette() {
        self.view.backgroundColor = UIColor.whiteColor()
        
        let paletteView = Palette()
        paletteView.delegate = self
        paletteView.setup()
        self.view.addSubview(paletteView)
        self.paletteView = paletteView
        self.paletteView?.snp_makeConstraints(closure: { (make) in
            make.left.right.bottom.equalTo(self.view)
        })
    }
    
    private func setupToolBar() {
        let toolBar = ToolBar()
        toolBar.undoButton?.addTarget(self, action: #selector(ViewController.onClickUndoButton), forControlEvents: .TouchUpInside)
        toolBar.redoButton?.addTarget(self, action: #selector(ViewController.onClickRedoButton), forControlEvents: .TouchUpInside)
        toolBar.loadButton?.addTarget(self, action: #selector(ViewController.onClickLoadButton), forControlEvents: .TouchUpInside)
        toolBar.saveButton?.addTarget(self, action: #selector(ViewController.onClickSaveButton), forControlEvents: .TouchUpInside)
        // default title is "Save"
        toolBar.saveButton?.setTitle("share", forState: .Normal)
        toolBar.clearButton?.addTarget(self, action: #selector(ViewController.onClickClearButton), forControlEvents: .TouchUpInside)
        toolBar.loadButton?.enabled = true
        self.view.addSubview(toolBar)
        self.toolBar = toolBar
        self.toolBar?.snp_makeConstraints(closure: { (make) in
            make.left.right.equalTo(self.view)
            make.bottom.equalTo(self.paletteView!.snp_top)
            make.height.equalTo(self.paletteView!).multipliedBy(0.25)
        })
    }
    
    private func setupCanvas() {
//        let canvasView = Canvas(backgroundImage: UIImage.init(named: "frame")!) // You can init with custom background image
        let canvasView = Canvas()
        canvasView.delegate = self
        canvasView.layer.borderColor = UIColor(red: 0.22, green: 0.22, blue: 0.22, alpha: 0.8).CGColor
        canvasView.layer.borderWidth = 2.0
        canvasView.layer.cornerRadius = 5.0
        canvasView.clipsToBounds = true
        self.view.addSubview(canvasView)
        self.canvasView = canvasView
        self.canvasView?.snp_makeConstraints(closure: { (make) in
            make.top.equalTo(self.view).offset(50)
            make.left.equalTo(self.view).offset(20)
            make.right.equalTo(self.view).offset(-20)
            make.height.equalTo(CGRectGetWidth(self.view.frame) - 40)
        })
    }
    
    private func updateToolBarButtonStatus(canvas: Canvas) {
        self.toolBar?.undoButton?.enabled = canvas.canUndo()
        self.toolBar?.redoButton?.enabled = canvas.canRedo()
        self.toolBar?.saveButton?.enabled = canvas.canSave()
        self.toolBar?.clearButton?.enabled = canvas.canClear()
    }
    
    func onClickUndoButton() {
        self.canvasView?.undo()
    }

    func onClickRedoButton() {
        self.canvasView?.redo()
    }

    func onClickLoadButton() {
        self.showActionSheetForPhotoSelection()
    }

    func onClickSaveButton() {
        self.canvasView?.save()
    }

    func onClickClearButton() {
        self.canvasView?.clear()
    }

    
    // MARK: - Image and Photo selection
    private func showActionSheetForPhotoSelection() {
        let actionSheet = UIActionSheet(title: nil, delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: nil, otherButtonTitles: "Photo from Album", "Take a Photo")
        actionSheet.showInView(self.view)
    }
    
    private func showPhotoLibrary () {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .PhotoLibrary
        picker.mediaTypes = [String(kUTTypeImage)]
        
        self.presentViewController(picker, animated: true, completion: nil)
    }
    
    private func showCamera() {
        let status = AVCaptureDevice.authorizationStatusForMediaType(AVMediaTypeVideo)
        
        switch (status) {
        case .NotDetermined:
            self.presentImagePickerController()
            break
        case .Restricted, .Denied:
            self.showAlertForImagePickerPermission()
            break
        case .Authorized:
            self.presentImagePickerController()
            break
        }
    }
    
    private func showAlertForImagePickerPermission() {
        let message = "If you want to use camera, you should allow app to use.\nPlease check your permission"
        let alert = UIAlertView(title: "", message: message, delegate: self, cancelButtonTitle: "No", otherButtonTitles: "Allow")
        alert.show()
    }
    
    private func openSettings() {
        let url = NSURL(string: UIApplicationOpenSettingsURLString)
        UIApplication.sharedApplication().openURL(url!)
    }
    
    private func presentImagePickerController() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.sourceType = .Camera
            picker.mediaTypes = [String(kUTTypeImage)]
            self.presentViewController(picker, animated: true, completion: nil)
        } else {
            let message = "This device doesn't support a camera"
            let alert = UIAlertView(title:"", message:message, delegate:nil, cancelButtonTitle:nil, otherButtonTitles:"Ok")
            alert.show()
        }
    }
    
    func image(image: UIImage, didFinishSavingWithError: NSError?, contextInfo:UnsafePointer<Void>)       {
        if didFinishSavingWithError != nil {
            let message = "Saving failed"
            let alert = UIAlertView(title:"", message:message, delegate:nil, cancelButtonTitle:nil, otherButtonTitles:"Ok")
            alert.show()
        } else {
            let message = "Saved successfuly"
            let alert = UIAlertView(title:"", message:message, delegate:nil, cancelButtonTitle:nil, otherButtonTitles:"Ok")
            alert.show()
        }
    }
}


// MARK: - CanvasDelegate
extension ViewController: CanvasDelegate
{
    func brush() -> Brush? {
        return self.paletteView?.currentBrush()
    }
    
    func canvas(canvas: Canvas, didUpdateDrawing drawing: Drawing, mergedImage image: UIImage?) {
        self.updateToolBarButtonStatus(canvas)
    }
    
    func canvas(canvas: Canvas, didSaveDrawing drawing: Drawing, mergedImage image: UIImage?) {
        // you can save strokeAndBackgroundMergedImage
//        if let pngImage = image?.asPNGImage() {
//            UIImageWriteToSavedPhotosAlbum(pngImage, self, #selector(ViewController.image(_:didFinishSavingWithError:contextInfo:)), nil)
//        }
        
        // you can save strokeImage only
//        if let pngImage = drawing.stroke?.asPNGImage() {
//            UIImageWriteToSavedPhotosAlbum(pngImage, self, #selector(ViewController.image(_:didFinishSavingWithError:contextInfo:)), nil)
//        }
        
//        self.updateToolBarButtonStatus(canvas)
        
        // you can share your image with UIActivityViewController
        if let pngImage = image?.asPNGImage() {
            let activityViewController = UIActivityViewController(activityItems: [pngImage], applicationActivities: nil)
            self.presentViewController(activityViewController, animated: true, completion: nil)
        }
    }
}


// MARK: - UIImagePickerControllerDelegate
extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: NSDictionary!) {
        let selectedImage : UIImage = image
        picker.dismissViewControllerAnimated(true, completion: { [weak self] in
            let cropper = RSKImageCropViewController(image:selectedImage, cropMode:.Square)
            cropper.delegate = self
            self?.presentViewController(cropper, animated: true, completion: nil)
        })
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
}


// MARK: - RSKImageCropViewControllerDelegate
extension ViewController: RSKImageCropViewControllerDelegate
{
    func imageCropViewControllerDidCancelCrop(controller: RSKImageCropViewController) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imageCropViewController(controller: RSKImageCropViewController, didCropImage croppedImage: UIImage, usingCropRect cropRect: CGRect) {
        self.canvasView?.update(croppedImage)
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
}


// MARK: - UIActionSheetDelegate
extension ViewController: UIActionSheetDelegate
{
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        if (actionSheet.cancelButtonIndex == buttonIndex) {
            return
        }
        
        if buttonIndex == 1 {
            self.showPhotoLibrary()
        } else if buttonIndex == 2 {
            self.showCamera()
        }
    }
}


// MARK: - UIAlertViewDelegate
extension ViewController: UIAlertViewDelegate
{
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        if (alertView.cancelButtonIndex == buttonIndex) {
            return
        } else {
            self.openSettings()
        }
    }
}


// MARK: - PaletteDelegate
extension ViewController: PaletteDelegate
{
//    func didChangeBrushColor(color: UIColor) {
//
//    }
//
//    func didChangeBrushAlpha(alpha: CGFloat) {
//
//    }
//
//    func didChangeBrushWidth(width: CGFloat) {
//
//    }
    

    // tag can be 1 ... 12
    func colorWithTag(tag: NSInteger) -> UIColor? {
        if tag == 4 {
            // if you return clearColor, it will be eraser
            return UIColor.clearColor()
        }
        return nil
    }
    
    // tag can be 1 ... 4
//    func widthWithTag(tag: NSInteger) -> CGFloat {
//        if tag == 1 {
//            return 5.0
//        }
//        return -1
//    }

    // tag can be 1 ... 3
//    func alphaWithTag(tag: NSInteger) -> CGFloat {
//        return -1
//    }
}



