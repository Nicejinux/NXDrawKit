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

open class Constraint {
    
    internal let sourceLocation: (String, UInt)
    internal let label: String?
    
    fileprivate let from: ConstraintItem
    fileprivate let to: ConstraintItem
    fileprivate let relation: ConstraintRelation
    fileprivate let multiplier: ConstraintMultiplierTarget
    fileprivate var constant: ConstraintConstantTarget {
        didSet {
            self.updateConstantAndPriorityIfNeeded()
        }
    }
    fileprivate var priority: ConstraintPriorityTarget {
        didSet {
          self.updateConstantAndPriorityIfNeeded()
        }
    }
    fileprivate var layoutConstraints: [LayoutConstraint]
    
    // MARK: Initialization
    
    internal init(from: ConstraintItem,
                  to: ConstraintItem,
                  relation: ConstraintRelation,
                  sourceLocation: (String, UInt),
                  label: String?,
                  multiplier: ConstraintMultiplierTarget,
                  constant: ConstraintConstantTarget,
                  priority: ConstraintPriorityTarget) {
        self.from = from
        self.to = to
        self.relation = relation
        self.sourceLocation = sourceLocation
        self.label = label
        self.multiplier = multiplier
        self.constant = constant
        self.priority = priority
        self.layoutConstraints = []
        
        // get attributes
        let layoutFromAttributes = self.from.attributes.layoutAttributes
        let layoutToAttributes = self.to.attributes.layoutAttributes
        
        // get layout from
        let layoutFrom: ConstraintView = self.from.view!
        
        // get relation
        let layoutRelation = self.relation.layoutRelation
        
        for layoutFromAttribute in layoutFromAttributes {
            // get layout to attribute
            let layoutToAttribute: NSLayoutAttribute
            #if os(iOS) || os(tvOS)
                if layoutToAttributes.count > 0 {
                    if self.from.attributes == .edges && self.to.attributes == .margins {
                        switch layoutFromAttribute {
                        case .left:
                            layoutToAttribute = .leftMargin
                        case .right:
                            layoutToAttribute = .rightMargin
                        case .top:
                            layoutToAttribute = .topMargin
                        case .bottom:
                            layoutToAttribute = .bottomMargin
                        default:
                            fatalError()
                        }
                    } else if self.from.attributes == .margins && self.to.attributes == .edges {
                        switch layoutFromAttribute {
                        case .leftMargin:
                            layoutToAttribute = .left
                        case .rightMargin:
                            layoutToAttribute = .right
                        case .topMargin:
                            layoutToAttribute = .top
                        case .bottomMargin:
                            layoutToAttribute = .bottom
                        default:
                            fatalError()
                        }
                    } else if self.from.attributes == self.to.attributes {
                        layoutToAttribute = layoutFromAttribute
                    } else {
                        layoutToAttribute = layoutToAttributes[0]
                    }
                } else {
                    layoutToAttribute = layoutFromAttribute
                }
            #else
                if self.from.attributes == self.to.attributes {
                    layoutToAttribute = layoutFromAttribute
                } else if layoutToAttributes.count > 0 {
                    layoutToAttribute = layoutToAttributes[0]
                } else {
                    layoutToAttribute = layoutFromAttribute
                }
            #endif
            
            // get layout constant
            let layoutConstant: CGFloat = self.constant.constraintConstantTargetValueFor(layoutToAttribute)
            
            // get layout to
            var layoutTo: AnyObject? = self.to.target
            
            // use superview if possible
            if layoutTo == nil && layoutToAttribute != .width && layoutToAttribute != .height {
                layoutTo = layoutFrom.superview
            }
            
            // create layout constraint
            let layoutConstraint = LayoutConstraint(
                item: layoutFrom,
                attribute: layoutFromAttribute,
                relatedBy: layoutRelation,
                toItem: layoutTo,
                attribute: layoutToAttribute,
                multiplier: self.multiplier.constraintMultiplierTargetValue,
                constant: layoutConstant
            )
            
            // set label
            layoutConstraint.label = self.label
            
            // set priority
            layoutConstraint.priority = self.priority.constraintPriorityTargetValue
            
            // set constraint
            layoutConstraint.constraint = self
            
            // append
            self.layoutConstraints.append(layoutConstraint)
        }
    }
    
    // MARK: Public
    
    @available(*, deprecated:3.0, message:"Use activate().")
    open func install() {
        self.activate()
    }
    
    @available(*, deprecated:3.0, message:"Use deactivate().")
    open func uninstall() {
        self.deactivate()
    }
    
    open func activate() {
        self.activateIfNeeded()
    }
    
    open func deactivate() {
        self.deactivateIfNeeded()
    }
    
    @discardableResult
    open func update(_ offset: ConstraintOffsetTarget) -> Constraint {
        self.constant = offset.constraintOffsetTargetValue
        return self
    }
    
    @discardableResult
    open func update(_ inset: ConstraintInsetTarget) -> Constraint {
        self.constant = inset.constraintInsetTargetValue
        return self
    }
    
    @discardableResult
    open func update(_ priority: ConstraintPriorityTarget) -> Constraint {
        self.priority = priority.constraintPriorityTargetValue
        return self
    }
    
    @available(*, deprecated:3.0, message:"Use update(offset: ConstraintOffsetTarget) instead.")
    open func updateOffset(_ amount: ConstraintOffsetTarget) -> Void { self.update(amount) }
    
    @available(*, deprecated:3.0, message:"Use update(inset: ConstraintInsetTarget) instead.")
    open func updateInsets(_ amount: ConstraintInsetTarget) -> Void { self.update(amount) }
    
    @available(*, deprecated:3.0, message:"Use update(priority: ConstraintPriorityTarget) instead.")
    open func updatePriority(_ amount: ConstraintPriorityTarget) -> Void { self.update(amount) }
    
    @available(*, obsoleted:3.0, message:"Use update(priority: ConstraintPriorityTarget) instead.")
    open func updatePriorityRequired() -> Void {}
    
    @available(*, obsoleted:3.0, message:"Use update(priority: ConstraintPriorityTarget) instead.")
    open func updatePriorityHigh() -> Void { fatalError("Must be implemented by Concrete subclass.") }
    
    @available(*, obsoleted:3.0, message:"Use update(priority: ConstraintPriorityTarget) instead.")
    open func updatePriorityMedium() -> Void { fatalError("Must be implemented by Concrete subclass.") }
    
    @available(*, obsoleted:3.0, message:"Use update(priority: ConstraintPriorityTarget) instead.")
    open func updatePriorityLow() -> Void { fatalError("Must be implemented by Concrete subclass.") }
    
    // MARK: Internal
    
    internal func updateConstantAndPriorityIfNeeded() {
        for layoutConstraint in self.layoutConstraints {
            let attribute = (layoutConstraint.secondAttribute == .notAnAttribute) ? layoutConstraint.firstAttribute : layoutConstraint.secondAttribute
            layoutConstraint.constant = self.constant.constraintConstantTargetValueFor(attribute)
            layoutConstraint.priority = self.priority.constraintPriorityTargetValue
        }
    }
    
    internal func activateIfNeeded(_ updatingExisting: Bool = false) {
        guard let view = self.from.view else {
            print("WARNING: SnapKit failed to get from view from constraint. Activate will be a no-op.")
            return
        }
        let layoutConstraints = self.layoutConstraints
        let existingLayoutConstraints = view.snp.constraints.map({ $0.layoutConstraints }).reduce([]) { $0 + $1 }
        
        if updatingExisting {
            for layoutConstraint in layoutConstraints {
                let existingLayoutConstraint = existingLayoutConstraints.first { $0 == layoutConstraint }
                guard let updateLayoutConstraint = existingLayoutConstraint else {
                    fatalError("Updated constraint could not find existing matching constraint to update: \(layoutConstraint)")
                }
                
                let updateLayoutAttribute = (updateLayoutConstraint.secondAttribute == .notAnAttribute) ? updateLayoutConstraint.firstAttribute : updateLayoutConstraint.secondAttribute
                updateLayoutConstraint.constant = self.constant.constraintConstantTargetValueFor(updateLayoutAttribute)
            }
        } else {
            NSLayoutConstraint.activate(layoutConstraints)
            view.snp.add([self])
        }
    }
    
    internal func deactivateIfNeeded() {
        guard let view = self.from.view else {
            print("WARNING: SnapKit failed to get from view from constraint. Deactivate will be a no-op.")
            return
        }
        let layoutConstraints = self.layoutConstraints
        NSLayoutConstraint.deactivate(layoutConstraints)
        view.snp.remove([self])
    }
}
