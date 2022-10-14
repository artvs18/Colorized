//
//  Extension + UIColor.swift
//  Colorized
//
//  Created by Artemy Volkov on 14.10.2022.
//

import UIKit

func colorToHex(_ color: UIColor) -> String {
    let ciColor = CIColor(color: color)
    
    let red = Float(ciColor.red)
    let green = Float(ciColor.green)
    let blue = Float(ciColor.blue)
    let alpha = Float(ciColor.alpha)
    
    let hexColor = String(
        format: "#%02lX%02lX%02lX%02lX",
        lroundf(red * 255),
        lroundf(green * 255),
        lroundf(blue * 255),
        lroundf(alpha * 255)
    )

    return hexColor
}

//func hexToRGB(_ hexColor: String) -> UIColor {
//
//}
