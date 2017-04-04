/*
 MIT License
 
 Copyright (c) [2017] [Emrah Ozer / Zbam Studio]
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
 */

import Foundation
import UIKit

enum OutlinePosition : Double
{
    case Inside = -1.0
    case Center = 0.0
    case Outside = 1.0
}


@IBDesignable
class DonutChart : UIView
{
    fileprivate var outerCircleLayer : CAShapeLayer?
    fileprivate var innerCircleLayer : CAShapeLayer?
    fileprivate var percentageText : UILabel?
    fileprivate var paragraphStyle : NSMutableParagraphStyle?
    fileprivate var attributedString : NSMutableAttributedString!

    override class var layerClass: AnyClass {
        return AnimationLayer.self
    }
    
    @IBInspectable
    override var tintColor     : UIColor!
        {
        didSet{
            
            innerCircleLayer?.strokeColor = tintColor.cgColor
            outerCircleLayer?.strokeColor = tintColor.cgColor
            percentageText?.textColor     = tintColor
            setDisplayIsDirty()
        }
    }
    
    @IBInspectable
    var radius : Double = 100
    {
        didSet{
            createOuterCircleLayer()
            createInnerCircleLayer()
            createTextField()
            setDisplayIsDirty()
        }
    }
    
    @IBInspectable
    var thickness : Double = 10
    {
        didSet{
            createOuterCircleLayer()
            createInnerCircleLayer()
            createTextField()
            setDisplayIsDirty()
        }
    }
    
    @IBInspectable
    var outlineWidth : Double = 1
    {
        didSet{
            
            self.outerCircleLayer?.lineWidth = CGFloat(outlineWidth)
            setDisplayIsDirty()
        }
    }
    
    var outlineThicknessPosition : OutlinePosition = .Center
    {
        didSet {
            setDisplayIsDirty()
        }
    }
    
    @IBInspectable
    var progress : Double = 0.0
    {
        didSet
        {
            layerProgress = progress
            setDisplayIsDirty()
        }
    }
    
    @IBInspectable var fontSize: CGFloat = 12
        {
        didSet{
            setFontValues()
            updateText()
            setDisplayIsDirty()
        }
    }
    
    @IBInspectable var fontFamily: String = "Arial"
        {
        didSet{
            setFontValues()
            updateText()
            setDisplayIsDirty()
        }
    }
    
    @IBInspectable var percentageSignFontSize: CGFloat = 16
        {
        didSet{
            setFontValues()
            updateText()
            setDisplayIsDirty()
        }
    }
    
    @IBInspectable var percentageSignFontFamily: String = "Arial"
        {
        didSet{
            setFontValues()
            updateText()
            setDisplayIsDirty()
        }
    }
    
    var font : UIFont!
    var percentageSignFont : UIFont!
    
    fileprivate var layerProgress:Double
    {
        set
        {
            (self.layer as! AnimationLayer).progress = newValue;
        }
        get
        {
            return (self.layer as! AnimationLayer).progress
        }
        
    }
    
    override init( frame: CGRect)
    {
        super.init( frame: frame )
        
        setFontValues()
        create()
        (self.layer as! AnimationLayer).animationCallBack = setDisplayIsDirty
    }
    
    required init?( coder aDecoder: NSCoder )
    {
        super.init( coder: aDecoder )
        
        setFontValues()
        create()
        (self.layer as! AnimationLayer).animationCallBack = setDisplayIsDirty
    }
    
    fileprivate func setFontValues()
    {
        font = UIFont(name: fontFamily, size: fontSize )
        percentageSignFont = UIFont(name: percentageSignFontFamily, size: percentageSignFontSize )
        
        paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle?.lineHeightMultiple = 0.8
        paragraphStyle?.alignment = NSTextAlignment.center
    }
    
    func create()
    {
        
        self.backgroundColor = UIColor.clear
        self.isOpaque = false
        
        createLayers()
        
        createOuterCircleLayer()
        createInnerCircleLayer()
        createTextField()
        
        updateText( )
        addSubview( percentageText! )
        
        
    }
    
    fileprivate func createLayers()
    {
        outerCircleLayer = CAShapeLayer()
        innerCircleLayer =  CAShapeLayer()
        
        self.layer.addSublayer( outerCircleLayer! )
        self.layer.addSublayer( innerCircleLayer! )
    }
    
    fileprivate func createTextField()
    {
        var textFrame :CGRect
        
        let textFieldWidth = radius - ((outlineThicknessPosition == OutlinePosition.Inside) ? thickness/2 : 0)
        
        if percentageSignFont != nil
        {
            textFrame = CGRect( x: textFieldWidth/2, y: textFieldWidth/2+5, width: textFieldWidth, height: textFieldWidth )
            
        }else{
            
            textFrame = CGRect( x: textFieldWidth/2, y: textFieldWidth/2, width: textFieldWidth, height: textFieldWidth)
        }
        
        percentageText = UILabel( frame: textFrame )
        percentageText?.textAlignment = NSTextAlignment.center
        percentageText?.numberOfLines = 0
        percentageText?.lineBreakMode = NSLineBreakMode.byWordWrapping
        percentageText?.textColor     = tintColor
        
    }

    fileprivate func createOuterCircleLayer()
    {
        var outlineCirclePositionOffset = thickness * outlineThicknessPosition.rawValue;
        
        let rect  = CGRect( x: Double(self.frame.width)/2 - radius - outlineCirclePositionOffset/2,
                            y: Double(self.frame.height)/2 - radius - outlineCirclePositionOffset/2,
                            width: radius * 2 + outlineCirclePositionOffset,
                            height: radius * 2 + outlineCirclePositionOffset)
        
        outerCircleLayer?.path = UIBezierPath( roundedRect: rect, cornerRadius: CGFloat(radius) ).cgPath
        outerCircleLayer?.lineWidth = CGFloat(outlineWidth)
        outerCircleLayer?.strokeColor = tintColor.cgColor
        outerCircleLayer?.fillColor = UIColor.clear.cgColor
        
    }
    
    fileprivate  func createInnerCircleLayer()
    {

        let rect = CGRect( x: Double(self.frame.width)/2 - radius ,
                           y: Double(self.frame.height)/2 - radius,
                           width: ( radius   ) * 2,
                           height: ( radius  ) * 2 )
        
        innerCircleLayer?.path = UIBezierPath( roundedRect: rect, cornerRadius: CGFloat(radius * 2) ).cgPath
        innerCircleLayer?.lineWidth = CGFloat(thickness)
        innerCircleLayer?.strokeColor = tintColor.cgColor
        innerCircleLayer?.fillColor = UIColor.clear.cgColor
        innerCircleLayer?.strokeEnd = CGFloat(layerProgress)
        
        
    }
    
    fileprivate func updateText()
    {
        layerProgress = self.progress
        
        let percentage = Int( ( layerProgress * 100.0 ) )
        
        if let percentageFont = percentageSignFont, let paragraphStyle = paragraphStyle
        {
            var percentageString = "\(percentage)"
            attributedString = NSMutableAttributedString( string: percentageString+"\n%" )
            attributedString.addAttribute( NSFontAttributeName, value: percentageFont, range: NSRange(location: 0, length: percentageString.utf8.count ) )
            attributedString.addAttribute( NSFontAttributeName, value: percentageSignFont, range: NSRange(location: percentageString.utf8.count, length: 1))
            attributedString.addAttribute( NSParagraphStyleAttributeName, value: paragraphStyle, range: NSRange(location: 0, length: attributedString.string.utf8.count ) )
            percentageText?.attributedText = attributedString!
            
        }else{
            
            percentageText?.numberOfLines = 1
            percentageText?.font = font
            percentageText?.text = "\(percentage)"
            percentageText?.textColor = tintColor
        }
        
    }
    
    
    fileprivate func setDisplayIsDirty()
    {
        self.setNeedsDisplay()
    }
    
    override func setNeedsDisplay()
    {
        updateDrawing()
    }
    
    fileprivate func updateDrawing()
    {
        
        layerProgress = self.progress
        
        if let innerCircleLayer = self.innerCircleLayer
        {
            innerCircleLayer.strokeEnd = CGFloat(layerProgress)
            updateText()
        }
    }
    
}

public enum DonutChartAnimatableProperties : String
{
    case progress = "progress"
    case radius = "radius"
    case thickness = "thickness"
}
