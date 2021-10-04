//
//  UIView+ViewDrag.swift
//  YiViewDrag
//
//  Created by coderyi on 2021/10/4.
//

import Foundation

extension UIView {
    private struct VDAssociatedKeys {
        static var panGesture = "panGesture"
        static var cagingArea = "cagingArea"
        static var handle = "handle"
        static var shouldMoveAlongY = "shouldMoveAlongY"
        static var shouldMoveAlongX = "shouldMoveAlongX"
        static var draggingStartedBlock = "draggingStartedBlock"
        static var draggingMovedBlock = "draggingMovedBlock"
        static var draggingEndedBlock = "draggingEndedBlock"
    }
    
    var vd_panGesture: UIPanGestureRecognizer? {
        get {
            return objc_getAssociatedObject(self, &VDAssociatedKeys.panGesture) as? UIPanGestureRecognizer
        }
        set {
            objc_setAssociatedObject(self, &VDAssociatedKeys.panGesture, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    public var vd_cagingArea: CGRect {
        get {
            return objc_getAssociatedObject(self, &VDAssociatedKeys.cagingArea) as? CGRect ?? CGRect.zero
        }
        set {
            if newValue == CGRect.zero || newValue.contains(frame) {
                objc_setAssociatedObject(self, &VDAssociatedKeys.cagingArea, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }

    var vd_handle: CGRect {
        get {
            return objc_getAssociatedObject(self, &VDAssociatedKeys.handle) as? CGRect ?? CGRect.zero
        }
        set {
            let relativeFrame = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height)
            if relativeFrame.contains(newValue) {
                objc_setAssociatedObject(self, &VDAssociatedKeys.handle, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }

    var vd_shouldMoveAlongY: Bool {
        get {
            return objc_getAssociatedObject(self, &VDAssociatedKeys.shouldMoveAlongY) as? Bool ?? true
        }
        set {
            objc_setAssociatedObject(self, &VDAssociatedKeys.shouldMoveAlongY, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    var vd_shouldMoveAlongX: Bool {
        get {
            return objc_getAssociatedObject(self, &VDAssociatedKeys.shouldMoveAlongX) as? Bool ?? true
        }
        set {
            objc_setAssociatedObject(self, &VDAssociatedKeys.shouldMoveAlongX, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    var vd_draggingStartedBlock: ((UIView)->Void)? {
        get {
            return objc_getAssociatedObject(self, &VDAssociatedKeys.draggingStartedBlock) as? (UIView)->Void
        }
        set {
            objc_setAssociatedObject(self, &VDAssociatedKeys.draggingStartedBlock, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    var vd_draggingMovedBlock: ((UIView)->Void)? {
        get {
            return objc_getAssociatedObject(self, &VDAssociatedKeys.draggingMovedBlock) as? (UIView)->Void
        }
        set {
            objc_setAssociatedObject(self, &VDAssociatedKeys.draggingMovedBlock, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    public var vd_draggingEndedBlock: ((UIView)->Void)? {
        get {
            return objc_getAssociatedObject(self, &VDAssociatedKeys.draggingEndedBlock) as? (UIView)->Void
        }
        set {
            objc_setAssociatedObject(self, &VDAssociatedKeys.draggingEndedBlock, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    @objc func vd_handlePan(sender: UIPanGestureRecognizer) {
        let locationInView = sender.location(in: self)
        if !vd_handle.contains(locationInView) && sender.state == .began {
            return
        }
        vd_adjustAnchorPoint(gestureRecognizer: sender)
        if sender.state == .began, let draggingStartedBlock = vd_draggingStartedBlock {
            draggingStartedBlock(self)
        }
        if sender.state == .changed, let draggingMovedBlock = vd_draggingMovedBlock {
            draggingMovedBlock(self)
        }
        if sender.state == .ended, let draggingEndedBlock = vd_draggingEndedBlock {
            draggingEndedBlock(self)
        }
        
        let translation = sender.translation(in: superview)
        var newXOrigin = frame.minX + (vd_shouldMoveAlongX ? translation.x : 0)
        var newYOrigin = frame.minY + (vd_shouldMoveAlongY ? translation.y : 0)
        
        let cagingAreaOriginX = vd_cagingArea.minX
        let cagingAreaOriginY = vd_cagingArea.minY
        let cagingAreaRightSide = cagingAreaOriginX + vd_cagingArea.width
        let cagingAreaBottomSide = cagingAreaOriginY + vd_cagingArea.height
        if vd_cagingArea != .zero {
            if newXOrigin <= cagingAreaOriginX || (newXOrigin + frame.size.width) >= cagingAreaRightSide {
                newXOrigin = frame.minX
            }
            if newYOrigin <= cagingAreaOriginY || (newYOrigin + frame.size.height) >= cagingAreaBottomSide {
                newYOrigin = frame.minY
            }
        }
        frame = CGRect(x: newXOrigin, y: newYOrigin, width: frame.width, height: frame.height)
        sender.setTranslation(CGPoint(x: 0, y: 0), in: superview)
    }
    
    func vd_adjustAnchorPoint(gestureRecognizer: UIGestureRecognizer) {
        if gestureRecognizer.state == .began {
            let locationInView = gestureRecognizer.location(in: self)
            let locationInSuperView = gestureRecognizer.location(in: superview)
            layer.anchorPoint = CGPoint(x: locationInView.x / bounds.size.width, y: locationInView.y / bounds.size.height)
            center = locationInSuperView
        }
    }
    
    public func vd_enableDrag() {
        vd_panGesture = UIPanGestureRecognizer(target: self, action: #selector(vd_handlePan(sender:)))
        vd_panGesture?.maximumNumberOfTouches = 1
        vd_panGesture?.minimumNumberOfTouches = 1
        vd_panGesture?.cancelsTouchesInView = false
        vd_handle = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height)
        if let panGesture = vd_panGesture {
            addGestureRecognizer(panGesture)
        }
    }
}
