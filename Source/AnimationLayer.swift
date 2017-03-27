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

import QuartzCore

class AnimationLayer: CALayer
{
    var progress: Double = 0
    var animationCallBack: (()->())?

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
