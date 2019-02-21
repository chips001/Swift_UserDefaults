//
//  UserDefaultsViewController.swift
//  Swift_UserDefaults
//
//  Created by 一木 英希 on 2019/02/08.
//  Copyright © 2019 一木 英希. All rights reserved.
//

import UIKit

class UserDefaultsViewController: UIViewController {
    
    var controllerType: ControllerType?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let controllerType = self.controllerType else { return }
        let userDefaults = UserDefaults.standard
        self.navigationItem.title = controllerType.viewParams.titleText
        self.saveButton.titleLabel?.adjustsFontSizeToFitWidth = true
        self.saveButton.setTitle(controllerType.viewParams.saveButtonTitle, for: .normal)
        self.viewChangeButton.titleLabel?.adjustsFontSizeToFitWidth = true
        self.viewChangeButton.setTitle(controllerType.viewParams.viewChangeButtonTitle, for: .normal)
        
        switch controllerType {
        case .standerdClass:
            if let value = userDefaults.string(forKey: "SaveText") {
                inputTextField.text = value
            }
        case .originalClass:
            if let storedData = userDefaults.object(forKey: "MyData") as? Data,
                let myData = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(storedData) as? MyData,
                let valueString = myData?.valueString {
                self.inputTextField.text = valueString
            }
        }
    }
    
    @IBAction func saveButtonHandler(_ sender: UIButton) {
        guard let controllerType = self.controllerType else { return }
        let userDefaults = UserDefaults.standard

        switch controllerType {
        case .standerdClass:
            userDefaults.set(self.inputTextField.text, forKey: "SaveText")
        
        case .originalClass:
            let myData = MyData()
            myData.valueString = self.inputTextField.text
            let archivedData = try? NSKeyedArchiver.archivedData(withRootObject: myData, requiringSecureCoding: false)
            userDefaults.set(archivedData, forKey: "MyData")
        }
        userDefaults.synchronize()
    }
    
    @IBAction func toOriginalButtonHandler(_ sender: UIButton) {
        guard let controllerType = self.controllerType else { return }
        switch controllerType {
        case .standerdClass:
            let controller = UserDefaultsViewController.instantiateFromStoryboard()
            controller.controllerType = .originalClass
            self.navigationController?.pushViewController(controller, animated: true)
        case .originalClass:
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var viewChangeButton: UIButton!
}

enum ControllerType {
    case standerdClass
    case originalClass
    
    struct ViewParams {
        let titleText: String
        let saveButtonTitle: String
        let viewChangeButtonTitle: String
    }
    
    var viewParams: ViewParams {
        switch self {
        case .standerdClass:
            return ViewParams(
                titleText: "通常クラスの保存",
                saveButtonTitle: "String型として保存",
                viewChangeButtonTitle: "独自クラスを保存する")
        case .originalClass:
            return ViewParams(
                titleText: "独自クラスの保存",
                saveButtonTitle: "MyData型として保存",
                viewChangeButtonTitle: "通常クラスを保存する")
        }
    }
}
