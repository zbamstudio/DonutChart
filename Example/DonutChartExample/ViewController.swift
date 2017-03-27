//
//  ViewController.swift
//  DonutChartExample
//
//  Created by Emrah Ozer on 27/03/2017.
//  Copyright © 2017 Emrah Ozer. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let chart = DonutChart(frame:CGRect(x: 100, y: 100, width: 100, height: 100))
        chart.tintColor            = UIColor.red
        chart.maxInnerRadius       = 10
        chart.minInnerRadius       = 5
        chart.outerLineWidth       = 0.5
        chart.progress             = 0.2
        chart.font                 = UIFont(name: "Arial", size: 21)
        chart.percentageSignFont   = UIFont(name: "Arial", size: 10)
        chart.create()
        view.addSubview(chart)
        
        let animation = CABasicAnimation(keyPath: "progress")
        animation.toValue = 1.0
        animation.duration = 1.0
        animation.fillMode = kCAFillModeForwards;
        chart.layer.add(animation, forKey: "progress")
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

