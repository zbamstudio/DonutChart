# DonutChart
An animatable donut chart view written in swift 3.

# Features

* Fully customizable through interface builder

![alt tag](https://raw.githubusercontent.com/zbamstudio/DonutChart/master/ReadmeAssets/donutChartInterfaceDesign.gif)

* Progress of the chart can be animated with CABasicAnimation or UIView.animate
```Swift

     UIView.animate(withDuration: 2.0, animations: {
         chart.progress = 1.0
     })
```
* Can achieve large variety of look & feel

![alt tag](https://raw.githubusercontent.com/zbamstudio/DonutChart/master/ReadmeAssets/example.png)
