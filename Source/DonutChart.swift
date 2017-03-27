
import Foundation
import UIKit

class DonutChart : UIView
{
    fileprivate var outerCircleLayer : CAShapeLayer!
    fileprivate var innerCircleLayer : CAShapeLayer!
    fileprivate var percentageText : UILabel!
    fileprivate var paragraphStyle : NSMutableParagraphStyle!
    fileprivate var radius : CGFloat!
    fileprivate var attributedString : NSMutableAttributedString!
    
    override class var layerClass: AnyClass {
        return AnimationLayer.self
    }
    
    override var tintColor      : UIColor!
        {
        didSet{
            
            if let circleLayer = outerCircleLayer
            {
                circleLayer.strokeColor = tintColor.cgColor
                innerCircleLayer.strokeColor = tintColor.cgColor
                self.setNeedsDisplay()
            }
        }
    }
    
    var outerLineWidth : CGFloat!
        {
        didSet
        {
            if let circleLayer = outerCircleLayer
            {
                circleLayer.lineWidth = outerLineWidth
                self.setNeedsDisplay()
            }
        }
    }
    
    var maxInnerRadius : CGFloat!
        {
        didSet
        {
            updateDrawing()
        }
        
    }
    
    var minInnerRadius : CGFloat!
        {
        didSet
        {
            updateDrawing()
        }
    }
    
    var progress : Double
        {
        didSet
        {
            layerProgress = self.progress
            updateDrawing()
        }
    }
    
    var font : UIFont!
    var percentageSignFont      : UIFont?
    
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
        progress = 0
        super.init( frame: frame )
        
        // set initial values
        radius = frame.size.width / 2
        minInnerRadius = radius * 0.1
        maxInnerRadius = radius * 0.7
        outerLineWidth = 1.0
        tintColor = UIColor.white
        font = UIFont.systemFont( ofSize: radius/4 )
        
        paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 0.8
        paragraphStyle.alignment = NSTextAlignment.center
        (self.layer as! AnimationLayer).animationCallBack = updateDrawing
        
        
    }
    
    required init?( coder aDecoder: NSCoder )
    {
        
        self.progress = 0
        super.init( coder: aDecoder )
        (self.layer as! AnimationLayer).animationCallBack = updateDrawing
    }
    
    func create()
    {
        let percentage = Int( ( layerProgress * 100.0 ) )
        
        self.backgroundColor = UIColor.clear
        self.isOpaque = false
        
        createOuterCircleLayer()
        createInnerCircleLayer(progress : layerProgress)
        
        var textFrame :CGRect
        
        if percentageSignFont != nil
        {
            
            textFrame = CGRect( x: maxInnerRadius/2, y: maxInnerRadius/2+5, width: self.frame.size.width-maxInnerRadius, height: self.frame.size.height-maxInnerRadius )
            
        }else{
            
            textFrame = CGRect( x: maxInnerRadius/2, y: maxInnerRadius/2, width: self.frame.size.width-maxInnerRadius, height: self.frame.size.height-maxInnerRadius )
        }
        
        percentageText = UILabel( frame: textFrame )
        percentageText.textAlignment = NSTextAlignment.center
        percentageText.numberOfLines = 0
        percentageText.lineBreakMode = NSLineBreakMode.byWordWrapping
        percentageText.textColor     = tintColor
        
        updateText( percentage )
        addSubview( percentageText )
    }
    
    fileprivate func createOuterCircleLayer()
    {
        outerCircleLayer = CAShapeLayer()
        let rect  = CGRect( x: 0, y: 0, width: radius*2, height: radius*2 )
        outerCircleLayer.path = UIBezierPath( roundedRect: rect, cornerRadius: radius*2 ).cgPath
        outerCircleLayer.lineWidth = outerLineWidth
        outerCircleLayer.strokeColor = tintColor.cgColor
        outerCircleLayer.fillColor = UIColor.clear.cgColor
        
        self.layer.addSublayer( outerCircleLayer )
        
    }
    fileprivate  func createInnerCircleLayer(progress: Double)
    {
        innerCircleLayer = CAShapeLayer()
        
        let returnValue :( UIBezierPath,CGFloat ) = createInnerPath(progress:progress)
        innerCircleLayer.path = returnValue.0.cgPath
        
        innerCircleLayer.lineWidth = returnValue.1
        innerCircleLayer.strokeColor = tintColor.cgColor
        innerCircleLayer.fillColor = UIColor.clear.cgColor
        innerCircleLayer.strokeEnd = CGFloat(progress)
        
        self.layer.addSublayer( innerCircleLayer )
        
    }
    
    fileprivate func createInnerPath(progress : Double )-> (bezier: UIBezierPath, lineWidth: CGFloat)
    {
        let lineWidth = minInnerRadius + ( (maxInnerRadius - minInnerRadius ) * CGFloat(progress) )
        let rect = CGRect( x: lineWidth/2, y: lineWidth/2, width: ( radius-lineWidth / 2 ) * 2, height: ( radius-lineWidth / 2 ) * 2 )
        return  ( UIBezierPath( roundedRect: rect, cornerRadius: radius * 2 ), lineWidth )
    }
    
    fileprivate func updateText(_ percentage: Int)
    {
        if let percentageFont  = percentageSignFont
        {
            var percentageString = "\(percentage)"
            attributedString = NSMutableAttributedString( string: percentageString+"\n%" )
            
            attributedString.addAttribute( NSFontAttributeName, value: font, range: NSRange(location: 0, length: percentageString.utf8.count ) )
            attributedString.addAttribute( NSFontAttributeName, value: percentageFont, range: NSRange(location: percentageString.utf8.count, length: 1))
            attributedString.addAttribute( NSParagraphStyleAttributeName, value: paragraphStyle, range: NSRange(location: 0, length: attributedString.string.utf8.count ) )
            percentageText.attributedText = attributedString!
            
            
        }else{
            
            percentageText.numberOfLines = 1
            percentageText.font = font
            percentageText.text = "\(percentage)"
        }
    }
    
    fileprivate func updateDrawing()
    {
        if let innerCircleLayer = self.innerCircleLayer{
            let returnValue :( bezier: UIBezierPath,lineWidth: CGFloat )  = createInnerPath(progress : layerProgress)
            innerCircleLayer.path = returnValue.bezier.cgPath
            innerCircleLayer.lineWidth = returnValue.lineWidth
            innerCircleLayer.strokeEnd = CGFloat(layerProgress)
            let percentage = Int(round((layerProgress * 100)))
            updateText(percentage)
            self.setNeedsDisplay()
        }
        
    }
    
    
    
    
    
}
