//
//  SnapKit
//
//  Copyright (c) 2011-Present SnapKit Team - https://github.com/SnapKit
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

#if os(iOS) || os(tvOS)
    import UIKit
#else
    import AppKit
#endif


open class ConstraintMakerExtendable: ConstraintMakerRelatable {
    
    open var left: ConstraintMakerExtendable {
        self.description.attributes += .left
        return self
    }
    
    open var top: ConstraintMakerExtendable {
        self.description.attributes += .top
        return self
    }
    
    open var bottom: ConstraintMakerExtendable {
        self.description.attributes += .bottom
        return self
    }
    
    open var right: ConstraintMakerExtendable {
        self.description.attributes += .right
        return self
    }
    
    open var leading: ConstraintMakerExtendable {
        self.description.attributes += .leading
        return self
    }
    
    open var trailing: ConstraintMakerExtendable {
        self.description.attributes += .trailing
        return self
    }
    
    open var width: ConstraintMakerExtendable {
        self.description.attributes += .width
        return self
    }
    
    open var height: ConstraintMakerExtendable {
        self.description.attributes += .height
        return self
    }
    
    open var centerX: ConstraintMakerExtendable {
        self.description.attributes += .centerX
        return self
    }
    
    open var centerY: ConstraintMakerExtendable {
        self.description.attributes += .centerY
        return self
    }
    
    @available(*, deprecated:3.0, message:"Use lastBaseline instead")
    open var baseline: ConstraintMakerExtendable {
        self.description.attributes += .lastBaseline
        return self
    }
    
    open var lastBaseline: ConstraintMakerExtendable {
        self.description.attributes += .lastBaseline
        return self
    }
    
    @available(iOS 8.0, OSX 10.11, *)
    open var firstBaseline: ConstraintMakerExtendable {
        self.description.attributes += .firstBaseline
        return self
    }
    
    @available(iOS 8.0, *)
    open var leftMargin: ConstraintMakerExtendable {
        self.description.attributes += .leftMargin
        return self
    }
    
    @available(iOS 8.0, *)
    open var rightMargin: ConstraintMakerExtendable {
        self.description.attributes += .rightMargin
        return self
    }
    
    @available(iOS 8.0, *)
    open var bottomMargin: ConstraintMakerExtendable {
        self.description.attributes += .bottomMargin
        return self
    }
    
    @available(iOS 8.0, *)
    open var leadingMargin: ConstraintMakerExtendable {
        self.description.attributes += .leadingMargin
        return self
    }
    
    @available(iOS 8.0, *)
    open var trailingMargin: ConstraintMakerExtendable {
        self.description.attributes += .trailingMargin
        return self
    }
    
    @available(iOS 8.0, *)
    open var centerXWithinMargins: ConstraintMakerExtendable {
        self.description.attributes += .centerXWithinMargins
        return self
    }
    
    @available(iOS 8.0, *)
    open var centerYWithinMargins: ConstraintMakerExtendable {
        self.description.attributes += .centerYWithinMargins
        return self
    }
    
    open var edges: ConstraintMakerExtendable {
        self.description.attributes += .edges
        return self
    }
    open var size: ConstraintMakerExtendable {
        self.description.attributes += .size
        return self
    }
    
    @available(iOS 8.0, *)
    open var margins: ConstraintMakerExtendable {
        self.description.attributes += .margins
        return self
    }
    
    @available(iOS 8.0, *)
    open var centerWithinMargins: ConstraintMakerExtendable {
        self.description.attributes += .centerWithinMargins
        return self
    }
    
}
