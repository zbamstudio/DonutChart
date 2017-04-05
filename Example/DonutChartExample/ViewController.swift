/*
MIT License

Copyright (c) [2017] [Emrah Ozer / Zbam Studio]

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

