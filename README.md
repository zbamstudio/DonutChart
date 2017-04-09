# DonutChart
An animatable donut chart view written in swift 3.

# Features

* Fully customizable through interface builder

![alt tag](https://raw.githubusercontent.com/zbamstudio/DonutChart/master/ReadmeAssets/donutChartInterfaceDesign.gif)

* Progress of the chart can be animated with CABasicAnimation or UIView.animate. Most of the properties can be animated easily.

```Swift

       let animationDuration = 8.0
       UIView.animate(withDuration: animationDuration , animations: {

                 CATransaction.begin()
                 CATransaction.setAnimationDuration(animationDuration)
                 chart.progress = 1.0
                 chart.progressColor = UIColor.yellow
                 chart.outlineColor = UIColor.black
                 chart.textColor = UIColor.red
                 chart.radius = 80
                 chart.thickness = 15
                 chart.outlineWidth = 5
                 CATransaction.commit()
         })

```
* Can achieve large variety of look & feel

![alt tag](https://raw.githubusercontent.com/zbamstudio/DonutChart/master/ReadmeAssets/example.png)
