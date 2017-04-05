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

import UIKit
import Darwin

class ViewController: UIViewController{

    @IBOutlet weak var animatedChart: DonutChart!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        animate(aChart:animatedChart)
    }
    
    func animate(aChart chart : DonutChart)
    {
        let animation = CABasicAnimation(keyPath: "progress")
        animation.toValue = 1.0
        animation.duration = 2
        animation.repeatDuration = 2
        animation.fillMode = kCAFillModeForwards
        animation.beginTime = CACurrentMediaTime()+1
        animation.repeatCount = .infinity
        animation.autoreverses = true
        animation.isRemovedOnCompletion = false
        chart.layer.add(animation, forKey: "progress")

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

