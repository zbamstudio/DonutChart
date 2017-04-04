//
//  DonutChartViewCell.swift
//  DonutChartExample
//
//  Created by Emrah Ozer on 04/04/2017.
//  Copyright © 2017 Emrah Ozer. All rights reserved.
//

import Foundation
import UIKit
import Darwin

class DonutChartViewCell : UICollectionViewCell
{
    
    @IBOutlet weak var chart: DonutChart!

    override func awakeFromNib() {
        super.awakeFromNib()

        let duration = Double(arc4random_uniform(2)+1)
        let animation = CABasicAnimation(keyPath: "progress")
        animation.fromValue = 0.0
        animation.toValue = 1.0
        animation.duration = duration
        animation.repeatDuration = duration
        animation.fillMode = kCAFillModeForwards
        animation.beginTime = CACurrentMediaTime() + Double(arc4random_uniform(3))
        animation.repeatCount = .infinity
        animation.autoreverses = true
        animation.isRemovedOnCompletion = false
        chart.layer.add(animation, forKey: "progress")

    }


}
