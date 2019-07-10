//
//  KCFloatingActionButtonItem.swift
//  KCFloatingActionButton-Sample
//
//  Created by LeeSunhyoup on 2015. 10. 5..
//  Copyright © 2015년 kciter. All rights reserved.
//

import UIKit

@objc public enum FloatyItemLabelPositionType: Int {
    case left
    case right
}

/**
 Floating Action Button Object's item.
 */
open class FloatyItem: UIView {

    // MARK: - Properties

    var contentInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
    
    /**
     This object's button size.
     */
    @objc open var sizeWidth: CGFloat = 175 {
        didSet {
            self.frame = CGRect(x: 0, y: 0, width: sizeWidth, height: size)
            titleLabel.frame = CGRect(x: contentInsets.left, y: 0, width: self.frame.width - contentInsets.left - contentInsets.right, height: size)
            //titleLabel.frame.origin.y = self.frame.height/2-titleLabel.frame.size.height/2
            self.setNeedsDisplay()
        }
    }
        
    @objc open var size: CGFloat = 33 {
        didSet {
            self.frame = CGRect(x: 0, y: 0, width: sizeWidth, height: size)
            titleLabel.frame = CGRect(x: contentInsets.left, y: 0, width: self.frame.width - contentInsets.left - contentInsets.right, height: size)
            //titleLabel.frame.origin.y = self.frame.height/2-titleLabel.frame.size.height/2
            self.setNeedsDisplay()
        }
    }

    /**
     Title label color.
     */
    @objc open var titleColor: UIColor = UIColor.black {
        didSet {
            titleLabel.textColor = titleColor
        }
    }

    /**
     Enable/disable shadow.
     */
    @objc open var hasShadow: Bool = true
    
    /**
     Title Shadow color.
     */
    @objc open var titleShadowColor: UIColor = UIColor.black

    /**
     If you touch up inside button, it execute handler.
     */
    @objc open var handler: ((FloatyItem) -> Void)? = nil

    /**
     Reference to parent
     */
    open weak var actionButton: Floaty?

    /**
     If you keeping touch inside button, button overlaid with tint layer.
     */
    fileprivate var tintLayer: CAShapeLayer = CAShapeLayer()
    
    /**
     Item's title label position.
     deafult is left
     */
    @objc open var titleLabelPosition: FloatyItemLabelPositionType = .left {
        didSet {
            if(titleLabelPosition == .left) {
                //titleLabel.frame.origin.x = -titleLabel.frame.size.width
                titleLabel.frame = CGRect(x: contentInsets.left, y: 0, width: self.frame.width - contentInsets.left - contentInsets.right, height: size)
            } else { //titleLabel will be on right
                titleLabel.frame = CGRect(x: contentInsets.left, y: 0, width: self.frame.width - contentInsets.left - contentInsets.right, height: size)
            }
        }
    }

    /**
     Item's title label.
     */
    var _titleLabel: UILabel? = nil
    @objc open var titleLabel: UILabel {
        get {
            if _titleLabel == nil {
                _titleLabel = UILabel()
                _titleLabel?.textColor = titleColor
                _titleLabel?.font = FloatyManager.defaultInstance().font
                _titleLabel?.textAlignment = .center
                _titleLabel?.numberOfLines = 1
                _titleLabel?.adjustsFontSizeToFitWidth = true
                _titleLabel?.minimumScaleFactor = 0.5
                addSubview(_titleLabel!)
            }
            return _titleLabel!
        }
    }

    /**
     Item's title.
     */
    @objc open var title: String? = nil {
        didSet {
            titleLabel.text = title
            titleLabel.sizeToFit()
            if(titleLabelPosition == .left) {
                //titleLabel.frame.origin.x = -titleLabel.frame.size.width
                titleLabel.frame = CGRect(x: contentInsets.left, y: 0, width: self.frame.width - contentInsets.left - contentInsets.right, height: size)
            } else { //titleLabel will be on right
                titleLabel.frame = CGRect(x: contentInsets.left, y: 0, width: self.frame.width - contentInsets.left - contentInsets.right, height: size)
            }
            
            //titleLabel.frame.origin.y = self.size/2-titleLabel.frame.size.height/2
            
            if FloatyManager.defaultInstance().rtlMode {
                titleLabel.transform = CGAffineTransform(scaleX: -1.0, y: 1.0);
            } else {
                titleLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0);
            }
        }
    }

    // MARK: - Initialize

    /**
     Initialize with default property.
     */
    public init() {
        super.init(frame: CGRect(x: 0, y: 0, width: size, height: size))
        backgroundColor = UIColor.white
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    /**
     Set size, frame and draw layers.
     */
    open override func draw(_ rect: CGRect) {
        super.draw(rect)

        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
        self.layer.cornerRadius = 2.0
        self.layer.masksToBounds = true
        setShadow()

        if _titleLabel != nil {
            bringSubviewToFront(_titleLabel!)
        }
    }

    fileprivate func createTintLayer() {
        //        tintLayer.frame = CGRectMake(frame.size.width - size, 0, size, size)
        let castParent : Floaty = superview as! Floaty
        tintLayer.frame = CGRect(x: castParent.itemSize/2 - (size/2), y: 0, width: size, height: size)
        tintLayer.backgroundColor = UIColor.white.withAlphaComponent(0.2).cgColor
        tintLayer.cornerRadius = size/2
        layer.addSublayer(tintLayer)
    }

    fileprivate func setShadow() {
        if !hasShadow {
            return
        }
        
        titleLabel.layer.shadowOffset = CGSize(width: 1, height: 1)
        titleLabel.layer.shadowRadius = 2
        titleLabel.layer.shadowColor = titleShadowColor.cgColor
        titleLabel.layer.shadowOpacity = 0.4
    }

    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touches.count == 1 {
            let touch = touches.first
            if touch?.tapCount == 1 {
                if touch?.location(in: self) == nil { return }
                createTintLayer()
            }
        }
    }

    open override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touches.count == 1 {
            let touch = touches.first
            if touch?.tapCount == 1 {
                if touch?.location(in: self) == nil { return }
                createTintLayer()
            }
        }
    }

    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        tintLayer.removeFromSuperlayer()
        if touches.count == 1 {
            let touch = touches.first
            if touch?.tapCount == 1 {
                if touch?.location(in: self) == nil { return }
                if actionButton != nil && actionButton!.autoCloseOnTap {
                    actionButton!.close()
                }
                handler?(self)
            }
        }
    }
}

func + (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x + right.x, y: left.y + right.y)
}
