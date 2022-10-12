//
//  SettingsViewController.swift
//  Colorized
//
//  Created by Artemy Volkov on 23.09.2022.
//

import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet var colorView: UIView!
    
    @IBOutlet var redLabelValue: UILabel!
    @IBOutlet var greenLabelValue: UILabel!
    @IBOutlet var blueLabelValue: UILabel!
    
    @IBOutlet var redSlider: UISlider!
    @IBOutlet var greenSlider: UISlider!
    @IBOutlet var blueSlider: UISlider!
    
    @IBOutlet var redColorTF: UITextField!
    @IBOutlet var greenColorTF: UITextField!
    @IBOutlet var blueColorTF: UITextField!
    
    var mainColor: UIColor!
    var delegate: settingsViewControllerDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        colorView.layer.cornerRadius = 15
        setViewColor()
        setSlidersValue()
        setLabelValue()
        setTFValues()
        addDoneButton(for: redColorTF, greenColorTF, blueColorTF)
        redColorTF.delegate = self
        greenColorTF.delegate = self
        blueColorTF.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
   
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @IBAction func changeColorValueTF(_ sender: UITextField) {
    }
    
    @IBAction func sliderTapped(_ sender: UISlider) {
        setViewColor()
        setTFValues()
        switch sender {
        case redSlider:
            redLabelValue.text = string(from: sender)
        case greenSlider:
            greenLabelValue.text = string(from: sender)
        default:
            blueLabelValue.text = string(from: sender)
        }
    }
    
    @IBAction func doneButtonDidTapped() {
        delegate.setColor(with: colorView.backgroundColor)
        dismiss(animated: true)
    }
}

extension SettingsViewController {
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
    
    private func setSlidersValue() {
        redSlider.value = Float(mainColor.redValue)
        blueSlider.value = Float(mainColor.blueValue)
        greenSlider.value = Float(mainColor.greenValue)
    }
    
    private func string(from slider: UISlider) -> String {
        String(format: "%.2f", slider.value)
    }
    
    private func setTFValues() {
        redColorTF.text = string(from: redSlider)
        greenColorTF.text = string(from: greenSlider)
        blueColorTF.text = string(from: blueSlider)
    }
    
    private func addDoneButton(for textField: UITextField...) {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let flexibleSpace = UIBarButtonItem(
            barButtonSystemItem: .flexibleSpace,
            target: nil,
            action: nil
        )
        
        let doneButton = UIBarButtonItem(
            barButtonSystemItem: .done,
            target: nil,
            action: #selector(doneClicked)
        )
        
        toolBar.setItems([flexibleSpace, doneButton], animated: false)
        textField.forEach { $0.inputAccessoryView = toolBar }
    }
    
    @objc private func doneClicked() {
        view.endEditing(true)
    }
    
    private func showAlert(
        with title: String,
        and message: String,
        textField: UITextField? = nil
    ) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        let okAction =  UIAlertAction(title: "OK", style: .default) { _ in
            textField?.text = ""
        }
        alert.addAction(okAction)
        present(alert, animated: true)
    }
    
    private func converter(text: String) -> String {
        var newText: String = ""
        for character in text {
            if character == "," {
                newText.append(".")
            } else {
                newText.append(character)
            }
        }
        return newText
    }
}

extension SettingsViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let newValue = textField.text else { return }
        let convertedText = converter(text: newValue)
        guard let colorValue = Float(convertedText) else {
            showAlert(
                with: "Wrong format!",
                and: "Please enter decimal value",
                textField: textField
            )
            return
        }
        if colorValue >= 0 && colorValue <= 1 {
            switch textField {
            case redColorTF:
                redSlider.value = colorValue
                setViewColor()
                setLabelValue()
            case greenColorTF:
                greenSlider.value = colorValue
                setViewColor()
                setLabelValue()
            default:
                blueSlider.value = colorValue
                setViewColor()
                setLabelValue()
            }
        } else {
            showAlert(
                with: "Values out of range!",
                and: "Values should be between 0.0 and 1.0",
                textField: textField
            )
        }
        
        
    }
}


