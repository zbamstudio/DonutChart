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
import ChameleonFramework

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var collectionView: UICollectionView!
    
    let fontNameArray : [String] = ["Arial", "AmericanTypewriter", "AppleSDGothicNeo-Bold","Arial-BoldItalicMT","Avenir-Black","AvenirNext-Medium","DINAlternate-Bold"]
    
    fileprivate let itemCount = 20;

    override func viewDidLoad() {
        super.viewDidLoad()
        let color = UIColor.flatBlack
        collectionView.backgroundColor = color
        self.view.backgroundColor = color
        collectionView.reloadData()
    }

    open func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemCount;
    }

    open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "donutChartCell", for: indexPath)
       
        let fontName = fontNameArray.random()
        let radius = Double(arc4random_uniform(30)) + 25
        let fontSize = CGFloat(arc4random_uniform(UInt32(radius/2)) + 5)
        
        let donutChartViewCell = cell as! DonutChartViewCell
        donutChartViewCell.chart.tintColor = RandomFlatColorWithShade(.light)
        donutChartViewCell.chart.outlineThicknessPosition = OutlinePosition.all.random()
        donutChartViewCell.chart.radius = radius
        donutChartViewCell.chart.thickness = Double(arc4random_uniform(UInt32(radius/5))) + 3
        donutChartViewCell.chart.progress = Double(arc4random_uniform(8)) / 10.0 + 0.2
    
        donutChartViewCell.chart.fontFamily = fontName
        donutChartViewCell.chart.fontSize = fontSize
        donutChartViewCell.chart.percentageSignFontFamily = fontName
        donutChartViewCell.chart.percentageSignFontSize = fontSize - 5

        let animation = CABasicAnimation(keyPath: "progress")
        animation.toValue = 1.0
        animation.duration = 2.0
        animation.fillMode = kCAFillModeForwards
        
        
        donutChartViewCell.chart.layer.add(animation, forKey: "progress")

        return cell
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

