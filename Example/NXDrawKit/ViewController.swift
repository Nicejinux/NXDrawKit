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
    
    fileprivate func initialize() {
        self.setupCanvas()
        self.setupPalette()
        self.setupToolBar()
    }
    
    fileprivate func setupPalette() {
        self.view.backgroundColor = UIColor.white
        
        let paletteView = Palette()
        paletteView.delegate = self
        paletteView.setup()
        self.view.addSubview(paletteView)
        self.paletteView = paletteView
        self.paletteView?.snp.makeConstraints({ (make) in
            make.left.right.bottom.equalTo(self.view)
        })
    }
    
    fileprivate func setupToolBar() {
        let toolBar = ToolBar()
        toolBar.undoButton?.addTarget(self, action: #selector(ViewController.onClickUndoButton), for: .touchUpInside)
        toolBar.redoButton?.addTarget(self, action: #selector(ViewController.onClickRedoButton), for: .touchUpInside)
        toolBar.loadButton?.addTarget(self, action: #selector(ViewController.onClickLoadButton), for: .touchUpInside)
        toolBar.saveButton?.addTarget(self, action: #selector(ViewController.onClickSaveButton), for: .touchUpInside)
        // default title is "Save"
        toolBar.saveButton?.setTitle("share", for: UIControlState())
        toolBar.clearButton?.addTarget(self, action: #selector(ViewController.onClickClearButton), for: .touchUpInside)
        toolBar.loadButton?.isEnabled = true
        self.view.addSubview(toolBar)
        self.toolBar = toolBar
        self.toolBar?.snp.makeConstraints({ (make) in
            make.left.right.equalTo(self.view)
            make.bottom.equalTo(self.paletteView!.snp.top)
            make.height.equalTo(self.paletteView!).multipliedBy(0.25)
        })
    }
    
    fileprivate func setupCanvas() {
//        let canvasView = Canvas(backgroundImage: UIImage.init(named: "frame")!) // You can init with custom background image
        let canvasView = Canvas()
        canvasView.delegate = self
        canvasView.layer.borderColor = UIColor(red: 0.22, green: 0.22, blue: 0.22, alpha: 0.8).cgColor
        canvasView.layer.borderWidth = 2.0
        canvasView.layer.cornerRadius = 5.0
        canvasView.clipsToBounds = true
        self.view.addSubview(canvasView)
        self.canvasView = canvasView
        self.canvasView?.snp.makeConstraints({ (make) in
            make.top.equalTo(self.view).offset(50)
            make.left.equalTo(self.view).offset(20)
            make.right.equalTo(self.view).offset(-20)
            make.height.equalTo(self.view.frame.width - 40)
        })
    }
    
    fileprivate func updateToolBarButtonStatus(_ canvas: Canvas) {
        self.toolBar?.undoButton?.isEnabled = canvas.canUndo()
        self.toolBar?.redoButton?.isEnabled = canvas.canRedo()
        self.toolBar?.saveButton?.isEnabled = canvas.canSave()
        self.toolBar?.clearButton?.isEnabled = canvas.canClear()
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
    fileprivate func showActionSheetForPhotoSelection() {
        let actionSheet = UIActionSheet(title: nil, delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: nil, otherButtonTitles: "Photo from Album", "Take a Photo")
        actionSheet.show(in: self.view)
    }
    
    fileprivate func showPhotoLibrary () {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.mediaTypes = [String(kUTTypeImage)]
        
        self.present(picker, animated: true, completion: nil)
    }
    
    fileprivate func showCamera() {
        let status = AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo)
        
        switch (status) {
        case .notDetermined:
            self.presentImagePickerController()
            break
        case .restricted, .denied:
            self.showAlertForImagePickerPermission()
            break
        case .authorized:
            self.presentImagePickerController()
            break
        }
    }
    
    fileprivate func showAlertForImagePickerPermission() {
        let message = "If you want to use camera, you should allow app to use.\nPlease check your permission"
        let alert = UIAlertView(title: "", message: message, delegate: self, cancelButtonTitle: "No", otherButtonTitles: "Allow")
        alert.show()
    }
    
    fileprivate func openSettings() {
        let url = URL(string: UIApplicationOpenSettingsURLString)
        UIApplication.shared.openURL(url!)
    }
    
    fileprivate func presentImagePickerController() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.sourceType = .camera
            picker.mediaTypes = [String(kUTTypeImage)]
            self.present(picker, animated: true, completion: nil)
        } else {
            let message = "This device doesn't support a camera"
            let alert = UIAlertView(title:"", message:message, delegate:nil, cancelButtonTitle:nil, otherButtonTitles:"Ok")
            alert.show()
        }
    }
    
    func image(_ image: UIImage, didFinishSavingWithError: NSError?, contextInfo:UnsafeRawPointer)       {
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
    
    func canvas(_ canvas: Canvas, didUpdateDrawing drawing: Drawing, mergedImage image: UIImage?) {
        self.updateToolBarButtonStatus(canvas)
    }
    
    func canvas(_ canvas: Canvas, didSaveDrawing drawing: Drawing, mergedImage image: UIImage?) {
        // you can save merged image
//        if let pngImage = image?.asPNGImage() {
//            UIImageWriteToSavedPhotosAlbum(pngImage, self, #selector(ViewController.image(_:didFinishSavingWithError:contextInfo:)), nil)
//        }
        
        // you can save strokeImage
//        if let pngImage = drawing.stroke?.asPNGImage() {
//            UIImageWriteToSavedPhotosAlbum(pngImage, self, #selector(ViewController.image(_:didFinishSavingWithError:contextInfo:)), nil)
//        }
        
//        self.updateToolBarButtonStatus(canvas)
        
        // you can share your image with UIActivityViewController
        if let pngImage = image?.asPNGImage() {
            let activityViewController = UIActivityViewController(activityItems: [pngImage], applicationActivities: nil)
            self.present(activityViewController, animated: true, completion: nil)
        }
    }
}


// MARK: - UIImagePickerControllerDelegate
extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    func imagePickerController(_ picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: NSDictionary!) {
        let selectedImage : UIImage = image
        picker.dismiss(animated: true, completion: { [weak self] in
            let cropper = RSKImageCropViewController(image:selectedImage, cropMode:.square)
            cropper.delegate = self
            self?.present(cropper, animated: true, completion: nil)
        })
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}


// MARK: - RSKImageCropViewControllerDelegate
extension ViewController: RSKImageCropViewControllerDelegate
{
    func imageCropViewControllerDidCancelCrop(_ controller: RSKImageCropViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func imageCropViewController(_ controller: RSKImageCropViewController, didCropImage croppedImage: UIImage, usingCropRect cropRect: CGRect) {
        self.canvasView?.update(croppedImage)
        controller.dismiss(animated: true, completion: nil)
    }
}


// MARK: - UIActionSheetDelegate
extension ViewController: UIActionSheetDelegate
{
    func actionSheet(_ actionSheet: UIActionSheet, clickedButtonAt buttonIndex: Int) {
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
    func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int) {
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
    func colorWithTag(_ tag: NSInteger) -> UIColor? {
        if tag == 4 {
            // if you return clearColor, it will be eraser
            return UIColor.clear
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



