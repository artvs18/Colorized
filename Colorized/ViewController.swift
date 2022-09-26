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
        setViewColor()
        setLabelValue()
    }
    
    
    @IBAction func sliderTapped(_ sender: UISlider) {
        setViewColor()
        switch sender {
        case redSlider:
            redLabelValue.text = string(from: sender)
        case greenSlider:
            greenLabelValue.text = string(from: sender)
        default:
            blueLabelValue.text = string(from: sender)
        }
    }
    
    private func setViewColor() {
        colorView.backgroundColor = UIColor(
            red: CGFloat(redSlider.value),
            green: CGFloat(greenSlider.value),
            blue: CGFloat(blueSlider.value),
            alpha: 1
        )
    }
    
    private func setLabelValue() {
        redLabelValue.text = string(from: redSlider)
        greenLabelValue.text = string(from: greenSlider)
        blueLabelValue.text = string(from: blueSlider)
    }
    
    private func string(from slider: UISlider) -> String {
        String(format: "%.2f", slider.value)
    }
}
