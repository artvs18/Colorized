//
//  MainViewController.swift
//  Colorized
//
//  Created by Artemy Volkov on 10.10.2022.
//

import UIKit

protocol settingsViewControllerDelegate {
    func setColor(with color: UIColor!)
}

class MainViewController: UIViewController {

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let settingsVC = segue.destination as? SettingsViewController else { return }
        settingsVC.mainColor = view.backgroundColor
        settingsVC.delegate = self
    }
}

extension MainViewController: settingsViewControllerDelegate {
    func setColor(with color: UIColor!) {
        view.backgroundColor = color
    }
}
