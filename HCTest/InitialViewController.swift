//
//  ViewController.swift
//  HCTest
//
//  Created by 이채원 on 2018. 5. 29..
//  Copyright © 2018년 david. All rights reserved.
//

import UIKit
import Alamofire

class InitialViewController: UIViewController {

    @IBOutlet var termTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        
        self.termTextField.inputView = pickerView
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowViewSegue" {
            let toVC = segue.destination as! ShowViewController
            
            // this value never be nil
            toVC.slideTerm = Int(self.termTextField.text!)
        }
    }

    
    
    @IBAction func didStartShowButtonPressed(_ sender: Any) {
        if self.termTextField.text == "" {
            presentAlert(target: self, title: "Please select slide term")
        } else {
            self.performSegue(withIdentifier: "ShowViewSegue", sender: nil)
        }
    }
}

extension InitialViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 10
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(row + 1)
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.termTextField.text = String(row + 1)
    }
}
