//
//  ViewController.swift
//  KTCustomPickerView
//
//  Created by Kartik.Patel.127 on 01/01/20.
//  Copyright © 2020 KTPatel. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UIPopoverPresentationControllerDelegate, KTCustomPickerViewDelegate {

    @IBOutlet weak var picker: KTCustomPickerView!
    var data = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupPickerData()
        setupPicker()
    }

    func setupPickerData() {
        for i in 1...10 {
            data.append("Option \(i)")
        }
    }
    
    func setupPicker() {
        picker.addTarget(self, action: #selector(openPicker), for: .touchUpInside)
        picker.setPickerView(delegate: self, datasource: self, placeHolder: "Select option")
    }

    @objc func openPicker() {
        picker.presentPicker(parentViewController: self, presentationControllerDelegate: self, delegate: self)
    }
    
    // MARK: UIPickerView delegate
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return data.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return data[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
    }
    // EndMARK: UIPickerView delegate
    
    // Mark: CustomPickerViewDelegate
    func doneTapped(sender: KTCustomPickerView) {
        picker.setSelectedValue(text: data[sender.getSelectedIndex()])
    }
    func cancelTapped(sender: KTCustomPickerView) {
        
    }
    // EndMark: CustomPickerViewDelegate
}

