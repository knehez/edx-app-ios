//
//  IconMessageView.swift
//  edX
//
//  Created by Akiva Leffert on 5/12/15.
//  Copyright (c) 2015 edX. All rights reserved.
//

import Foundation
import UIKit

private let IconMessageSize : CGFloat = 80.0
private let IconMessageRotatedSize : CGFloat = IconMessageSize * 1.75
private let IconMessageTextWidth : CGFloat = 240.0
private let IconMessageMargin : CGFloat = 15.0
private let MessageButtonMargin : CGFloat = 15.0
private let BottomButtonHorizontalMargin : CGFloat = 12.0
private let BottomButtonVerticalMargin : CGFloat = 6.0


class IconMessageView : UIView {
    private var hasBottomButton = false
    
    private let styles : OEXStyles?
    
    private var buttonFontStyle : OEXTextStyle {
        return OEXTextStyle(weight :.Normal, size : .Base, color : styles?.neutralDark())
    }
    private let shouldRotateIcon : Bool
    
    private let iconView : UIImageView
    private let messageView : UILabel
    private var bottomButton : UIButton
    
    private let container : UIView
    
    init(icon : Icon? = nil, message : String? = nil, buttonTitle : String? = nil, styles : OEXStyles?, shouldRotateIcon : Bool = false) {
        self.styles = styles
        
        self.shouldRotateIcon = shouldRotateIcon
        
        container = UIView(frame: CGRectZero)
        iconView = UIImageView(frame: CGRectZero)
        messageView = UILabel(frame : CGRectZero)
        bottomButton = UIButton.buttonWithType(.System) as! UIButton
        super.init(frame: CGRectZero)
        
        self.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        setupViews(icon : icon, message : message, buttonTitle : buttonTitle)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var message : String? {
        get {
            return messageView.text
        }
        set {
            messageView.attributedText = newValue.map { messageStyle.attributedStringWithText($0) }
        }
    }
    
    var attributedMessage : NSAttributedString? {
        get {
            return messageView.attributedText
        }
        set {
            messageView.attributedText = newValue
        }
    }
    
    var accessibilityMessage : String? {
        get {
            return messageView.accessibilityLabel
        }
        set {
            messageView.accessibilityLabel = newValue
        }
    }
    
    var icon : Icon? {
        didSet {
            if self.shouldRotateIcon {
                rotateImageViewClockwise(iconView)
                iconView.image = icon?.imageWithFontSize(IconMessageRotatedSize)
            }
            else {
                iconView.image = icon?.imageWithFontSize(IconMessageSize)
            }
            
        }
    }
    
    var buttonTitle : String? {
        get {
            return bottomButton.titleLabel?.text
        }
        set {
            if let title = newValue {
                let attributedTitle = buttonFontStyle.withWeight(.SemiBold).attributedStringWithText(title)
                bottomButton.setAttributedTitle(attributedTitle, forState: .Normal)
                addButtonBorder()
            }
            else {
                bottomButton.setAttributedTitle(nil, forState: .Normal)
            }
            
        }
    }
    
    var messageStyle : OEXTextStyle  {
        let style = OEXMutableTextStyle(weight: .SemiBold, size: .Small, color : styles?.neutralDark())
        style.alignment = .Center
        
        return style
    }
    
    private func setupViews(#icon : Icon?, message : String?, buttonTitle : String?) {
        self.icon = icon
        self.message = message
        self.buttonTitle = buttonTitle
        
        iconView.tintColor = styles?.neutralLight()
        
        messageView.numberOfLines = 0
        
        bottomButton.contentEdgeInsets = UIEdgeInsets(top: BottomButtonVerticalMargin, left: BottomButtonHorizontalMargin, bottom: BottomButtonVerticalMargin, right: BottomButtonHorizontalMargin)
        
        addSubview(container)
        container.addSubview(iconView)
        container.addSubview(messageView)
        container.addSubview(bottomButton)

    }
    
    override func updateConstraints() {
        container.snp_makeConstraints { (make) -> Void in
            make.center.equalTo(self)
            make.leading.greaterThanOrEqualTo(self)
            make.top.greaterThanOrEqualTo(self)
            make.trailing.lessThanOrEqualTo(self)
            make.bottom.lessThanOrEqualTo(self)
        }
        
        iconView.snp_updateConstraints { (make) -> Void in
            make.leading.equalTo(container)
            make.trailing.equalTo(container)
            make.top.equalTo(container)
        }
        
        if shouldRotateIcon {
            iconView.center = CGPointMake(iconView.frame.size.width/2, iconView.frame.size.height/2);
        }
        
        messageView.snp_updateConstraints { (make) -> Void in
            make.top.equalTo(self.iconView.snp_bottom).offset(IconMessageMargin)
            make.centerX.equalTo(container)
            make.width.equalTo(IconMessageTextWidth)
            if !hasBottomButton {
                make.bottom.equalTo(container)
            }
        }
        
        if hasBottomButton {
            bottomButton.snp_makeConstraints { (make) -> Void in
                make.top.equalTo(self.messageView.snp_bottom).offset(MessageButtonMargin)
                make.centerX.equalTo(container)
                make.bottom.equalTo(container)
            }
        }
        super.updateConstraints()
    }
    
    func showNoConnectionError() {
        self.message = OEXLocalizedString("NETWORK_NOT_AVAILABLE_MESSAGE_TROUBLE", nil)
        self.icon = .InternetError
    }
    
    func addButtonAction(action : UIButton -> Void) {
        self.bottomButton.oex_addAction({button in action( button as! UIButton) }, forEvents: .TouchUpInside)
    }
    
    func addButtonBorder() {
        hasBottomButton = true
        setNeedsUpdateConstraints()
        var bottomButtonLayer = bottomButton.layer
        bottomButtonLayer.cornerRadius = 4.0
        bottomButtonLayer.borderWidth = 1.0
        bottomButtonLayer.borderColor = styles?.neutralLight().CGColor
    }
    
    func rotateImageViewClockwise(imageView : UIImageView) {
        imageView.transform = CGAffineTransformMakeRotation(CGFloat(M_PI_2))
    }
}