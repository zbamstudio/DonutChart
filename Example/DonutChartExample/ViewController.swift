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

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var collectionView: UICollectionView!
    fileprivate let itemCount = 20;

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.reloadData()
    }

    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemCount;
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "donutChartCell", for: indexPath)

        let cellBounds = cell.contentView.bounds;
        
        let chart = DonutChart(frame:CGRect(x: 0, y: 0, width: cellBounds.width, height: cellBounds.height))
        chart.tintColor            = UIColor.red
        chart.maxInnerRadius       = 10
        chart.minInnerRadius       = 5
        chart.outerLineWidth       = 0.5
        chart.progress             = 0.0
        chart.font                 = UIFont(name: "Arial", size: 21)
        chart.percentageSignFont   = UIFont(name: "Arial", size: 10)
        chart.create()

        let animation = CABasicAnimation(keyPath: "progress")
        animation.toValue = 1.0
        animation.duration = 2.0
        animation.fillMode = kCAFillModeForwards;
        chart.layer.add(animation, forKey: "progress")

        cell.contentView.addSubview(chart)

        return cell
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

