/*
MIT License

Copyright (c) [2017] [Emrah Ozer / Zbam Studio]
*/

import QuartzCore

class AnimationLayer: CALayer
{

    @NSManaged var progress: CGFloat

    override init() {
        super.init()
    }
    
    override init(layer: Any) {
        super.init(layer: layer)
        if let layer = layer as? AnimationLayer {
            progress = layer.progress
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    fileprivate class func isCustomAnimKey(_ key: String) -> Bool {
        var keys = ["progress"]
        return try keys.contains(key)
    }
    
    override class func needsDisplay(forKey key: String) -> Bool {
        if self.isCustomAnimKey(key) {
            return true
        }
        return super.needsDisplay(forKey: key)
    }
    
    override func action(forKey event: String) -> CAAction? {
        if AnimationLayer.isCustomAnimKey(event) {
            if let animation = super.action(forKey: "backgroundColor") as? CABasicAnimation {
                animation.keyPath = event
                if let pLayer = presentation() {
                    animation.fromValue = pLayer.progress
                }
                animation.toValue = nil
                return animation
            }
            setNeedsDisplay()
            return nil
        }
        return super.action(forKey: event)
    }
    
}

