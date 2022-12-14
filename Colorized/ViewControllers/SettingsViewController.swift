//
//  SettingsViewController.swift
//  Colorized
//
//  Created by Artemy Volkov on 23.09.2022.
//

import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet var colorView: UIView!
    
    @IBOutlet var redSlider: UISlider!
    @IBOutlet var greenSlider: UISlider!
    @IBOutlet var blueSlider: UISlider!
    @IBOutlet var alphaSlider: UISlider!
    
    @IBOutlet var redTF: UITextField!
    @IBOutlet var greenTF: UITextField!
    @IBOutlet var blueTF: UITextField!
    @IBOutlet var alphaTF: UITextField!
    
    @IBOutlet var hexTF: UITextField!
    
    var mainColor: UIColor!
    var delegate: SettingsViewControllerDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        colorView.layer.cornerRadius = 44
        colorView.backgroundColor = mainColor
        
        hexTF.text = colorToHex(mainColor)
        
        setValue(for: redSlider, greenSlider, blueSlider, alphaSlider)
        setValue(for: redTF, greenTF, blueTF, alphaTF)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    @IBAction func sliderShifted(_ sender: UISlider) {
        switch sender {
        case redSlider:
            setValue(for: redTF)
        case greenSlider:
            setValue(for: greenTF)
        case blueSlider:
            setValue(for: blueTF)
        default:
            setValue(for: alphaTF)
        }
        setViewColor()
        setHexTextView()
    }
    
    @IBAction func doneButtonDidTapped() {
        delegate.setColor(with: colorView.backgroundColor ?? .white)
        dismiss(animated: true)
    }
}

extension SettingsViewController {
    private func setViewColor() {
        colorView.backgroundColor = UIColor(
            red: CGFloat(redSlider.value),
            green: CGFloat(greenSlider.value),
            blue: CGFloat(blueSlider.value),
            alpha: CGFloat(alphaSlider.value)
        )
    }
    
    private func setHexTextView() {
        hexTF.text = colorToHex(
            UIColor(
                red: CGFloat(redSlider.value),
                green: CGFloat(greenSlider.value),
                blue: CGFloat(blueSlider.value),
                alpha: CGFloat(alphaSlider.value)
            )
        )
    }
    
    private func setValue(for sliders: UISlider...) {
        let ciColor = CIColor(color: mainColor)
        sliders.forEach { slider in
            switch slider {
            case redSlider: slider.value = Float(ciColor.red)
            case greenSlider: slider.value = Float(ciColor.green)
            case blueSlider: slider.value = Float(ciColor.blue)
            default: slider.value = Float(ciColor.alpha)
            }
        }
    }
    
    private func setValue(for textFields: UITextField...) {
        textFields.forEach { textField in
            switch textField {
            case redTF: textField.text = string(from: redSlider)
            case greenTF: textField.text = string(from: greenSlider)
            case blueTF: textField.text = string(from: blueSlider)
            default: textField.text = string(from: alphaSlider)
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
        if textField != hexTF {
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
            case redTF:
                redSlider.setValue(colorValue, animated: true)
            case greenTF:
                greenSlider.setValue(colorValue, animated: true)
            case blueTF:
                blueSlider.setValue(colorValue, animated: true)
            default:
                alphaSlider.setValue(colorValue, animated: true)
            }
            
            setViewColor()
            setHexTextView()
        }
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
            return false && updatedText.count <= 4
          }
          
        return updatedText.count <= 4
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let keyboardToolbar = UIToolbar()
        keyboardToolbar.sizeToFit()
        
        if textField != hexTF {
            textField.inputAccessoryView = keyboardToolbar
        }
        
        
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == hexTF {
           return textField.resignFirstResponder()
        }
        return false
    }
}
