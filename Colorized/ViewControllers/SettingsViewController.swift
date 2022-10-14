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
    var delegate: SettingsViewControllerDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        colorView.layer.cornerRadius = 15
        colorView.backgroundColor = mainColor
        
        setValue(for: redSlider, greenSlider, blueSlider)
        setValue(for: redLabelValue, greenLabelValue, blueLabelValue)
        setValue(for: redColorTF, greenColorTF, blueColorTF)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    @IBAction func sliderShifted(_ sender: UISlider) {
        switch sender {
        case redSlider:
            setValue(for: redLabelValue)
            setValue(for: redColorTF)
        case greenSlider:
            setValue(for: greenLabelValue)
            setValue(for: greenColorTF)
        default:
            setValue(for: blueLabelValue)
            setValue(for: blueColorTF)
        }
        setViewColor()
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
    
    private func setValue(for labels: UILabel...) {
        labels.forEach { label in
            switch label {
            case redLabelValue: label.text = string(from: redSlider)
            case greenLabelValue: label.text = string(from: greenSlider)
            default: label.text = string(from: blueSlider)
            }
        }
    }
    
    private func setValue(for sliders: UISlider...) {
        let ciColor = CIColor(color: mainColor)
        sliders.forEach { slider in
            switch slider {
            case redSlider: slider.value = Float(ciColor.red)
            case greenSlider: slider.value = Float(ciColor.green)
            default: slider.value = Float(ciColor.blue)
            }
        }
    }
    
    private func setValue(for textFields: UITextField...) {
        textFields.forEach { textField in
            switch textField {
            case redColorTF: textField.text = string(from: redSlider)
            case greenColorTF: textField.text = string(from: greenSlider)
            default: textField.text = string(from: blueSlider)
            }
        }
    }
    
    private func string(from slider: UISlider) -> String {
        String(format: "%.2f", slider.value)
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
}

extension SettingsViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let newValue = textField.text else {
            showAlert(
                with: "Wrong format!",
                and: "Please enter decimal value between 0 and 1",
                textField: textField
            )
            return
        }
        
        guard let colorValue = Float(newValue), (0...1).contains(colorValue) else {
            showAlert(
                with: "Wrong format!",
                and: "Please enter decimal value between 0 and 1",
                textField: textField
            )
            return
        }
        switch textField {
        case redColorTF:
            redSlider.setValue(colorValue, animated: true)
            setValue(for: redLabelValue)
        case greenColorTF:
            greenSlider.setValue(colorValue, animated: true)
            setValue(for: greenLabelValue)
        default:
            blueSlider.setValue(colorValue, animated: true)
            setValue(for: blueLabelValue)
        }
        
        setViewColor()
    }
    
    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        
        if string == "," {
            textField.text = textField.text! + "."
            return false
        }
        
        return true && updatedText.count <= 4
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let keyboardToolbar = UIToolbar()
        keyboardToolbar.sizeToFit()
        textField.inputAccessoryView = keyboardToolbar
        
        let doneButton = UIBarButtonItem(
            barButtonSystemItem: .done,
            target: textField,
            action: #selector(resignFirstResponder)
        )
        
        let flexBarButton = UIBarButtonItem(
            barButtonSystemItem: .flexibleSpace,
            target: nil,
            action: nil
        )
        
        keyboardToolbar.items = [flexBarButton, doneButton]
    }
}
