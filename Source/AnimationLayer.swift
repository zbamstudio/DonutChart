/*
MIT License

Copyright (c) [2017] [Emrah Ozer / Zbam Studio]
*/

import QuartzCore

class AnimationLayer: CALayer
{
    var animationCallBack : (()->())?
    var progress: Double = 0

    override init() {
        super.init()
    }
    
    override init(layer: Any) {
        
        progress = (layer is AnimationLayer) ? (layer as! AnimationLayer).progress : 0
        super.init(layer: layer)
    }
    
    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
    }
    
    override class func needsDisplay(forKey key: String) -> Bool {

        if(key == "progress"){
            return true
        }
        return super.needsDisplay(forKey: key)
    }
    
    override func display() {

        if let presentation = self.presentation(){
            self.progress = presentation.progress
            animationCallBack?()
        }
    }
    
}

