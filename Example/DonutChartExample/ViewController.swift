/*
MIT License

Copyright (c) [2017] [Emrah Ozer / Zbam Studio]

*/

import UIKit
import Darwin

class ViewController: UIViewController{

    @IBOutlet weak var animatedChart: DonutChart!
    
    
    override func viewDidAppear(_ animated: Bool){
        super.viewDidAppear(animated)
        animate(aChart:animatedChart)
    }
    
    func animate(aChart chart : DonutChart)
    {
        UIView.animate(withDuration: 2.0, animations: {
            chart.progress = 1.0
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

