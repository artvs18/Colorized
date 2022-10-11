//
//  Extension + UIColor.swift
//  Colorized
//
//  Created by Artemy Volkov on 11.10.2022.
//

import UIKit

extension UIColor {
    var redValue: CGFloat { return CIColor(color: self).red }
    var greenValue: CGFloat { return CIColor(color: self).green }
    var blueValue: CGFloat { return CIColor(color: self).blue }
}
