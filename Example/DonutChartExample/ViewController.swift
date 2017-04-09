/*
MIT License

Copyright (c) [2017] [Emrah Ozer / Zbam Studio]

*/

import UIKit
import Darwin
import QuartzCore

class ViewController: UIViewController{

    @IBOutlet weak var animatedChart: DonutChart!
    
    
    override func viewDidAppear(_ animated: Bool){
        super.viewDidAppear(animated)
        animate(aChart:animatedChart)
    }
    
    func animate(aChart chart : DonutChart)
    {
        UIView.animate(withDuration: 8.0, animations: {

            CATransaction.begin()
            CATransaction.setAnimationDuration(8.0)
            chart.progress = 1.0
            chart.progressColor = UIColor.yellow
            chart.outlineColor = UIColor.black
            chart.textColor = UIColor.red
            chart.radius = 80
            chart.thickness = 15
            chart.outlineWidth = 5
            CATransaction.commit()
        })

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

