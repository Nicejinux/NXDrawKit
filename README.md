
<p align="center">
  <img src="images/logo.jpg"/>
</p>



[![Build Status](https://travis-ci.org/Nicejinux/NXDrawKit.svg?branch=master)](https://travis-ci.org/Nicejinux/NXDrawKit)
[![Version](https://img.shields.io/cocoapods/v/NXDrawKit.svg?style=flat)](http://cocoapods.org/pods/NXDrawKit)
[![License](https://img.shields.io/cocoapods/l/NXDrawKit.svg?style=flat)](http://cocoapods.org/pods/NXDrawKit)
[![Platform](https://img.shields.io/cocoapods/p/NXDrawKit.svg?style=flat)](http://cocoapods.org/pods/NXDrawKit)

#Purpose
It's just started for my personal app for iPhone.
Though, it can not be customized as much as you want, you can use [Smooth Freehand Drawing View](http://code.tutsplus.com/tutorials/ios-sdk_freehand-drawing--mobile-13164) easily.
I made `Palette` and `ToolBar` for using `Canvas`, so **you don't have to use** `Palette` and `ToolBar`.

**NXDrawKit** is a set of classes designed to use drawable view easily. 
This framework consists of 3 kinds of views.
 - `Canvas` providing redo, undo, clear, save and load image is a view  for drawing.
 - `Palette` calls delegate with color, alpha and width when user clicks the button.
 - `ToolBar` represents the features of `Canvas`, and can show the status of `Canvas`.



#Screenshot
<p align="center">
  <img src="images/screenShot.gif" border="black"/>
</p>



#Installation

##Using cocoapods:
```
pod 'NXDrawKit'
```

##Using Carthage:
```
github "nicejinux/NXDrawKit"
```


#Components
##Canvas 
### - Delegate
`Canvas` will call the delegate when user draw or save image.  
- Delegate provides user stroke image, background image and merged image. 
- User should provide the `Brush` to `Canvas` for drawing.

```swift
// optional
func canvas(canvas: Canvas, didUpdatePaper paper: Paper, mergedImage image: UIImage?)
func canvas(canvas: Canvas, didSavePaper paper: Paper, mergedImage image: UIImage?)

// required
func currentBrush() -> Brush?
```

### - Model
The '***Paper***' means '**The cloth of canvas**' but I don't know the name of that cloth.
I know it's so weird, but I have no idea for that name.
If you have a good idea, tell me.

```swift
public class Paper: NSObject {
    public var stroke: UIImage?
    public var background: UIImage?
    
    public init(stroke: UIImage? = nil, background: UIImage? = nil) {
        self.stroke = stroke
        self.background = background
    }
}

public class Brush: NSObject {
    public var color: UIColor = UIColor.blackColor()
    public var width: CGFloat = 5.0
    public var alpha: CGFloat = 1.0
}
```


### - Public Methods
 - User can set background image.
 - User can ***undo***, ***redo*** or ***clear*** the `Canvas`. (**Maximum history size is 50**)
 - User can ***save*** current stroke and background internally, then `Canvas` calls ***didSavePaper:*** delegate

```swift
func update(backgroundImage: UIImage?)
func undo()
func redo()
func clear()
func save() 
```

##Palette 
 - `Palette` has 12 buttons for color, 3 buttons for alpha and 4 buttons for width of brush.
 - **You can** customize color, value of alpha and width of brush with delegate, 
 - **You can't** customize number of buttons.

### - Delegate
 - `Palette` will call the delegate when user clicks the color, alpha or width button.
 - You can customize the color, alpha or width with delegate. (**all delegates are optional**)

```swift
func didChangeBrushColor(color: UIColor)
func didChangeBrushAlpha(alpha: CGFloat)
func didChangeBrushWidth(width: CGFloat)
```

 - ***tag*** can be ***1 ... 12*** 
 - If you return ***nil***, the color of tag will set with default color provided by **NXDrawKit**.

```swift
func colorWithTag(tag: NSInteger) -> UIColor?
```

 - ***tag*** can be ***1 ... 3***
 - If you return ***-1***, the alpha of tag will set with default alpha provided by **NXDrawKit**.

```swift
func alphaWithTag(tag: NSInteger) -> CGFloat
```

 - ***tag*** can be ***1 ... 4***
 - If you return ***-1***, the width of tag will set with default width provided by **NXDrawKit**.

```swift
func widthWithTag(tag: NSInteger) -> CGFloat

```


### - Public Method

```swift
func currentBrush() -> Brush
```

##ToolBar
### - Public Properties
 - All buttons are set with default values without **#selector**.
 - If you want to use buttons on the `ToolBar`, you have to add **#selector** for each buttons.
```swift
var undoButton: UIButton?
var redoButton: UIButton?
var saveButton: UIButton?
var loadButton: UIButton?
var clearButton: UIButton?
```


#Will be improved
1. There is no Eraser, so user can't erase stroke.
2. User can't remove background image after it's set.
3. `Palette` and `ToolBar` can't customize easily.
4. All the codes looks like ***ObjC***.



#Author
This is [Jinwook Jeon](http://Nicejinux.NET). 
I've been working as an iOS developer in Korea. 
This is my first Swift project, so there can be lots of weird things in this framework.
I'm waiting for your comments, suggestions, fixes, everything what you want to say.
Feel free to contact me.

 - email : nicejinux@gmail.com
 - facebook : http://facebook.com/Nicejinux
 - homepage : http://Nicejinux.NET


#MIT License

	Copyright (c) 2016 Jinwook Jeon. All rights reserved.

	Permission is hereby granted, free of charge, to any person obtaining a
	copy of this software and associated documentation files (the "Software"),
	to deal in the Software without restriction, including
	without limitation the rights to use, copy, modify, merge, publish,
	distribute, sublicense, and/or sell copies of the Software, and to
	permit persons to whom the Software is furnished to do so, subject to
	the following conditions:

	The above copyright notice and this permission notice shall be included
	in all copies or substantial portions of the Software.

	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
	OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
	MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
	IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
	CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
	TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
	SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
	


