//
//  ViewController.swift
//  Colorized
//
//  Created by Artemy Volkov on 23.09.2022.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var colorView: UIView!
    
    @IBOutlet var redLabelValue: UILabel!
    @IBOutlet var greenLabelValue: UILabel!
    @IBOutlet var blueLabelValue: UILabel!
    
    @IBOutlet var redSlider: UISlider!
    @IBOutlet var greenSlider: UISlider!
    @IBOutlet var blueSlider: UISlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        colorView.layer.cornerRadius = 15
    }
    
    @IBAction func redSliderTapped() {
        redLabelValue.text = String(format: "%.2f", redSlider.value)
        setViewColor()
    }
    
    @IBAction func greenSliderTapped() {
        greenLabelValue.text = String(format: "%.2f", greenSlider.value)
        setViewColor()
    }
    
    @IBAction func blueSliderTapped() {
        blueLabelValue.text = String(format: "%.2f", blueSlider.value)
        setViewColor()
    }
    
    private func setViewColor() {
        colorView.backgroundColor = UIColor(
            red: CGFloat(redSlider.value),
            green: CGFloat(greenSlider.value),
            blue: CGFloat(blueSlider.value),
            alpha: 1.0
        )
    }
}
