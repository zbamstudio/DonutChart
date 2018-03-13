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

    fileprivate var _progress: CGFloat = 0.0

    @IBInspectable
    var progress: CGFloat
    {
        set {
            if let layer = layer as? AnimationLayer {
                layer.progress = newValue
            }

            _progress = newValue
            updateProgress()
        }
        get {
            return _progress
        }
    }

    fileprivate var _progressColor: UIColor = UIColor.black

    @IBInspectable
    var progressColor: UIColor
    {
        set {
            if let layer = layer as? AnimationLayer {
                layer.progressColor = newValue.cgColor
            }
            _progressColor = newValue
            progressLayer?.strokeColor = _progressColor.cgColor
            self.setNeedsDisplay()
        }
        get
        {
            return _progressColor
        }
    }

    fileprivate var _outlineColor: UIColor = UIColor.black

    @IBInspectable
    var outlineColor: UIColor
    {
        set {
            if let layer = layer as? AnimationLayer {
                layer.outlineColor = newValue.cgColor
            }
            _outlineColor = newValue
            outlineLayer?.strokeColor = _outlineColor.cgColor
            self.setNeedsDisplay()
        }
        get
        {
            return _outlineColor
        }
    }

    fileprivate var _textColor: UIColor = UIColor.black

    @IBInspectable
    var textColor: UIColor
    {
        set {
            if let layer = layer as? AnimationLayer {
                layer.textColor = newValue.cgColor
            }
            _textColor = newValue
            percentageText?.textColor = _textColor
            self.setNeedsDisplay()
        }
        get
        {
            return _textColor
        }
    }

    fileprivate var _radius: Double = 100.0

    @IBInspectable
    var radius: Double {
        set {
            if let layer = layer as? AnimationLayer {
                layer.radius = CGFloat(newValue)
            }
            _radius = newValue
            setFrameOfOutlineLayer()
            setFrameOfProgressLayer()
            setFrameOfTextField()
            self.setNeedsDisplay()
        }
        get
        {
            return _radius
        }
    }

    fileprivate var _thickness : Double = 10

    @IBInspectable
    var thickness: Double{
        set {
            if let layer = layer as? AnimationLayer {
                layer.thickness = CGFloat(newValue)
            }
            _thickness = newValue
            progressLayer?.lineWidth = CGFloat(_thickness)
            setFrameOfOutlineLayer()
            setFrameOfProgressLayer()
            setFrameOfTextField()
            self.setNeedsDisplay()
        }
        get
        {
            return _thickness
        }
    }

    fileprivate var _outlineWidth : Double = 1

    @IBInspectable
    var outlineWidth: Double
    {
        set {
            if let layer = layer as? AnimationLayer {
                layer.outlineWidth = CGFloat(newValue)
            }
            _outlineWidth = newValue
            self.outlineLayer?.lineWidth = CGFloat(outlineWidth)
            self.setNeedsDisplay()
        }
        get
        {
            return _outlineWidth
        }

    }

    @IBInspectable var fontSize: CGFloat = 12
    {
        didSet
        {
            updateFontProperty()
        }
    }

    @IBInspectable var fontFamily: String = "Arial"
    {
        didSet
        {
            updateFontProperty()
        }
    }

    @IBInspectable var percentageSignFontSize: CGFloat = 16
    {
        didSet
        {
            updateFontProperty()
        }
    }

    @IBInspectable var percentageSignFontFamily: String = "Arial"
    {
        didSet
        {
            updateFontProperty()
        }
    }

    @IBInspectable var isPercentageSignVisible : Bool = true
    {
        didSet
        {
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

    var outlinePlacement: OutlinePlacement = .Inside
    {
        didSet
        {
            self.setNeedsDisplay()
        }
    }

    private var font: UIFont!
    private var percentageSignFont: UIFont!

    override init(frame: CGRect)
    {
        super.init(frame: frame)
        create()
    }

    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        create()
    }

    override func awakeFromNib()
    {
        super.awakeFromNib()
        updateProgress()
    }

    func create()
    {
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

    private func createTextField()
    {
        percentageText = UILabel()
        percentageText?.textAlignment = NSTextAlignment.center
        percentageText?.lineBreakMode = NSLineBreakMode.byWordWrapping
    }

    fileprivate func createParagraphStyle()
    {
        paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle?.lineHeightMultiple = 0.8
        paragraphStyle?.alignment = NSTextAlignment.center
    }

    fileprivate func createFonts()
    {
        font = UIFont(name: fontFamily, size: fontSize)
        percentageSignFont = UIFont(name: percentageSignFontFamily, size: percentageSignFontSize)
    }

    fileprivate func createLayers()
    {
        outlineLayer = CAShapeLayer()
        progressLayer = CAShapeLayer()

        self.layer.addSublayer(outlineLayer!)
        self.layer.addSublayer(progressLayer!)

        outlineLayer?.lineWidth = CGFloat(outlineWidth)
        outlineLayer?.fillColor = UIColor.clear.cgColor

        progressLayer?.lineWidth = CGFloat(thickness)
        progressLayer?.fillColor = UIColor.clear.cgColor
    }

    fileprivate func setFrameOfTextField()
    {
        var textFrame: CGRect
        let offset = thickness * outlinePlacement.rawValue
        let textFieldWidth = _radius * 1.5 - offset

        textFrame = CGRect(x: Double(self.frame.width) / 2 - textFieldWidth / 2 + offset/2,
                y: Double(self.frame.height) / 2 - textFieldWidth / 2 + offset/2,
                width: textFieldWidth,
                height: textFieldWidth)

        percentageText?.frame = textFrame
    }

    fileprivate func setFrameOfOutlineLayer()
    {
        let outlineCirclePositionOffset = thickness * outlinePlacement.rawValue;
        let rect = CGRect(x: Double(self.frame.width) / 2 - _radius - outlineCirclePositionOffset / 2,
                y: Double(self.frame.height) / 2 - _radius - outlineCirclePositionOffset / 2,
                width: _radius * 2 + outlineCirclePositionOffset,
                height: _radius * 2 + outlineCirclePositionOffset)

        outlineLayer?.path = UIBezierPath(roundedRect: rect, cornerRadius: CGFloat(radius)).cgPath
    }

    fileprivate func setFrameOfProgressLayer()
    {
        let rect = CGRect(x: Double(self.frame.width) / 2 - _radius,
                y: Double(self.frame.height) / 2 - _radius,
                width: _radius * 2,
                height: _radius * 2)

        progressLayer?.path = UIBezierPath(roundedRect: rect, cornerRadius: CGFloat(radius * 2)).cgPath
    }

    fileprivate func updateText()
    {
        let percentage = Int(ceil(_progress * 100.0))
        var percentageString = "\(percentage)"

        if(isPercentageSignVisible)
        {
            percentageText?.numberOfLines = 0
            createAttributedStringForVisiblePercentageSign(percentageString: percentageString)

        }else
        {
            percentageText?.numberOfLines = 1
            createAttributedStringWithoutPercentageSign(percentageString: percentageString)
        }

        self.percentageText?.attributedText = self.attributedString ?? NSAttributedString(string: "")
    }

    fileprivate func createAttributedStringWithoutPercentageSign(percentageString: String) {
        attributedString = NSMutableAttributedString(string: percentageString)
        attributedString.addAttribute(NSFontAttributeName, value: font, range: NSRange(location: 0, length: percentageString.utf8.count))
        attributedString.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle!, range: NSRange(location: 0, length: attributedString.string.utf8.count))
    }

    fileprivate func createAttributedStringForVisiblePercentageSign(percentageString: String) {
        attributedString = NSMutableAttributedString(string: percentageString + "\n%")
        attributedString.addAttribute(NSFontAttributeName, value: font, range: NSRange(location: 0, length: percentageString.utf8.count))
        attributedString.addAttribute(NSFontAttributeName, value: percentageSignFont, range: NSRange(location: percentageString.utf8.count+1, length: 1))
        attributedString.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle!, range: NSRange(location: 0, length: attributedString.string.utf8.count))
    }

    fileprivate func updateProgress()
    {
        progressLayer?.strokeEnd = CGFloat(_progress)
        updateText()
        self.setNeedsDisplay()
    }

    fileprivate func updateFontProperty() {
        createFonts()
        updateText()
        self.setNeedsDisplay()
    }

    override func display(_ layer: CALayer)
    {
        if let pLayer = layer.presentation() as? AnimationLayer
        {
            progressLayer?.strokeEnd = CGFloat(pLayer.progress)
            progressLayer?.strokeColor = pLayer.progressColor
            outlineLayer?.strokeColor = pLayer.outlineColor
            progressLayer?.lineWidth = pLayer.thickness
            percentageText?.textColor = UIColor(cgColor: pLayer.textColor)
            outlineLayer?.lineWidth = pLayer.outlineWidth

            if(Double(pLayer.radius) != _radius || Double(pLayer.thickness) != _thickness)
            {
                _radius = Double(pLayer.radius)
                _thickness = Double(pLayer.thickness)
                setFrameOfTextField()
                setFrameOfOutlineLayer()
                setFrameOfProgressLayer()
            }

            updateText()

            _progress = pLayer.progress
            _progressColor = UIColor(cgColor: pLayer.progressColor)
            _outlineColor = UIColor(cgColor: pLayer.outlineColor)
            _textColor = UIColor(cgColor: pLayer.textColor)
            _thickness = Double(pLayer.thickness)
            _outlineWidth = Double(pLayer.outlineWidth)
        }
    }
}

