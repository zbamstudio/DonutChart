/*
 MIT License
 
 Copyright (c) [2017] [Emrah Ozer / Zbam Studio]
 */

import Foundation
import UIKit

enum OutlinePlacement: Double {

    static var all:[OutlinePlacement] = [.Inside, .Center, .Outside]

    case Inside = -1.0
    case Center = 0.0
    case Outside = 1.0
}


@IBDesignable
class DonutChart: UIView {

    fileprivate var outlineLayer: CAShapeLayer?
    fileprivate var progressLayer: CAShapeLayer?
    fileprivate var percentageText: UILabel?
    fileprivate var paragraphStyle: NSMutableParagraphStyle?
    fileprivate var attributedString: NSMutableAttributedString!
    fileprivate var _outlinePlacementInterfaceAdapter: String = "inside"
    
    override class var layerClass: AnyClass {
        return AnimationLayer.self
    }

    @IBInspectable
    var progressColor: UIColor = UIColor.black
    {
        didSet {

            progressLayer?.strokeColor = progressColor.cgColor
            self.setNeedsDisplay()
        }
    }

    @IBInspectable
    var outlineColor: UIColor = UIColor.black
    {
        didSet {

            outlineLayer?.strokeColor = outlineColor.cgColor
            self.setNeedsDisplay()
        }
    }

    @IBInspectable
    var textColor: UIColor = UIColor.black
    {
        didSet {

            percentageText?.textColor = textColor
            self.setNeedsDisplay()
        }
    }
    
    @IBInspectable
    var radius: Double = 100 {
        didSet {
            setFrameOfOutlineLayer()
            setFrameOfProgressLayer()
            setFrameOfTextField()
            self.setNeedsDisplay()
        }
    }

    @IBInspectable
    var thickness: Double = 10 {
        didSet {
            
            progressLayer?.lineWidth = CGFloat(thickness)
            setFrameOfOutlineLayer()
            setFrameOfProgressLayer()
            setFrameOfTextField()
            self.setNeedsDisplay()
        }
    }

    @IBInspectable
    var outlineWidth: Double = 1 {
        didSet {
            self.outlineLayer?.lineWidth = CGFloat(outlineWidth)
            self.setNeedsDisplay()
        }

    }
    
    var _localProgress: CGFloat = 0.0
    
    @IBInspectable

    var progress: CGFloat {
        set {

            if let layer = layer as? AnimationLayer {
                layer.progress = newValue
            }

            _localProgress = newValue
            updateProgress()

        }
        get {
            return _localProgress
        }
    }

    @IBInspectable var fontSize: CGFloat = 12 {
        didSet {
            createFonts()
            updateText()
            self.setNeedsDisplay()
        }
    }

    @IBInspectable var fontFamily: String = "Arial" {
        didSet {
            createFonts()
            updateText()
            self.setNeedsDisplay()
        }
    }

    @IBInspectable var percentageSignFontSize: CGFloat = 16 {
        didSet {
            createFonts()
            updateText()
            self.setNeedsDisplay()
        }
    }

    @IBInspectable var percentageSignFontFamily: String = "Arial" {
        didSet {
            createFonts()
            updateText()
            self.setNeedsDisplay()
        }
    }
    
    @IBInspectable var isPercentageSignVisible : Bool = true {
        didSet{
            updateText()
            self.setNeedsDisplay()
        }
    }
    
    @IBInspectable var outlinePlacementInterfaceAdapter: String
    {
        set
        {
            _outlinePlacementInterfaceAdapter = newValue
            switch _outlinePlacementInterfaceAdapter {
            case "inside":
                outlinePlacement = .Inside
            case "center":
                outlinePlacement = .Center
            case "outside":
                outlinePlacement = .Outside
            default:
                outlinePlacement = .Inside
            }
            setFrameOfOutlineLayer()
            setFrameOfProgressLayer()
            setFrameOfTextField()
            self.setNeedsDisplay()
        }
        get{
            return _outlinePlacementInterfaceAdapter
        }
    }
    
    
    var outlinePlacement: OutlinePlacement = .Inside {
        didSet {

            self.setNeedsDisplay()
        }
    }

    private var font: UIFont!
    private var percentageSignFont: UIFont!


    override init(frame: CGRect) {

        super.init(frame: frame)

        create()
    }

    required init?(coder aDecoder: NSCoder) {

        super.init(coder: aDecoder)
        create()

    }

    override func awakeFromNib() {
        super.awakeFromNib()
        updateProgress()
    }
    
    func create() {

        self.backgroundColor = UIColor.clear
        self.isOpaque = false


        createTextField()
        createParagraphStyle()
        createLayers()

        setFrameOfOutlineLayer()
        setFrameOfProgressLayer()
        setFrameOfTextField()
        createFonts()
        updateText()
        addSubview(percentageText!)

    }

    private func createTextField() {

        percentageText = UILabel()
        percentageText?.textAlignment = NSTextAlignment.center
        percentageText?.lineBreakMode = NSLineBreakMode.byWordWrapping

    }

    fileprivate func createParagraphStyle() {

        paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle?.lineHeightMultiple = 0.8
        paragraphStyle?.alignment = NSTextAlignment.center

    }


    fileprivate func createFonts() {

        font = UIFont(name: fontFamily, size: fontSize)
        percentageSignFont = UIFont(name: percentageSignFontFamily, size: percentageSignFontSize)

    }

    fileprivate func createLayers() {

        outlineLayer = CAShapeLayer()
        progressLayer = CAShapeLayer()

        self.layer.addSublayer(outlineLayer!)
        self.layer.addSublayer(progressLayer!)

        outlineLayer?.lineWidth = CGFloat(outlineWidth)
        outlineLayer?.fillColor = UIColor.clear.cgColor

        progressLayer?.lineWidth = CGFloat(thickness)
        progressLayer?.fillColor = UIColor.clear.cgColor

    }

    fileprivate func setFrameOfTextField() {

        var textFrame: CGRect

        let offset = thickness * outlinePlacement.rawValue
        let textFieldWidth = radius - offset

        textFrame = CGRect(x: Double(self.frame.width) / 2 - radius + textFieldWidth / 2 + offset/2,
                           y: Double(self.frame.height) / 2 - radius + textFieldWidth / 2 + offset/2,
                           width: textFieldWidth+offset,
                           height: textFieldWidth+offset)

        percentageText?.frame = textFrame
    }

    fileprivate func setFrameOfOutlineLayer() {

        let outlineCirclePositionOffset = thickness * outlinePlacement.rawValue;

        let rect = CGRect(x: Double(self.frame.width) / 2 - radius - outlineCirclePositionOffset / 2,
                y: Double(self.frame.height) / 2 - radius - outlineCirclePositionOffset / 2,
                width: radius * 2 + outlineCirclePositionOffset,
                height: radius * 2 + outlineCirclePositionOffset)

        outlineLayer?.path = UIBezierPath(roundedRect: rect, cornerRadius: CGFloat(radius)).cgPath

    }

    fileprivate func setFrameOfProgressLayer() {

        let rect = CGRect(x: Double(self.frame.width) / 2 - radius,
                y: Double(self.frame.height) / 2 - radius,
                width: (radius) * 2,
                height: (radius) * 2)

        progressLayer?.path = UIBezierPath(roundedRect: rect, cornerRadius: CGFloat(radius * 2)).cgPath

    }

    fileprivate func updateText() {

        let percentage = Int(ceil(_localProgress * 100.0))
        var percentageString = "\(percentage)"

        if(isPercentageSignVisible){
            percentageText?.numberOfLines = 0
            attributedString = NSMutableAttributedString(string: percentageString + "\n%")
            attributedString.addAttribute(NSFontAttributeName, value: font, range: NSRange(location: 0, length: percentageString.utf8.count))
            attributedString.addAttribute(NSFontAttributeName, value: percentageSignFont, range: NSRange(location: percentageString.utf8.count+1, length: 1))
            attributedString.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle!, range: NSRange(location: 0, length: attributedString.string.utf8.count))
            self.percentageText?.attributedText = self.attributedString ?? NSAttributedString(string: "")
        }else{
            percentageText?.numberOfLines = 1
            attributedString = NSMutableAttributedString(string: percentageString)
            attributedString.addAttribute(NSFontAttributeName, value: font, range: NSRange(location: 0, length: percentageString.utf8.count))
            attributedString.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle!, range: NSRange(location: 0, length: attributedString.string.utf8.count))
            self.percentageText?.attributedText = self.attributedString
        }
    }

    fileprivate func updateProgress() {

        progressLayer?.strokeEnd = CGFloat(_localProgress)
        updateText()
        self.setNeedsDisplay()
    }

    override func display(_ layer: CALayer) {
        
        if let pLayer = layer.presentation() as? AnimationLayer {
            progressLayer?.strokeEnd = CGFloat(pLayer.progress)
            updateText()
            _localProgress = pLayer.progress
        }
    }
    
}

