//
//  KTCustomPickerView.swift
//  KTCustomPickerView
//
//  Created by Kartik Patel on 01/01/20.
//  Copyright © 2020 KTPatel. All rights reserved.
//

import Foundation
import UIKit

extension NSObject {
    var isPad: Bool {
        return UIDevice.current.userInterfaceIdiom == .pad
    }
}

protocol KTCustomPickerViewDelegate {
    func doneTapped(sender: KTCustomPickerView)
    func cancelTapped(sender: KTCustomPickerView)
}

class KTCustomPickerView : UIControl {
    
    private var delegate: KTCustomPickerViewDelegate? = nil
    private var parentViewController : UIViewController!
    private var alertController : UIAlertController!
    
    private lazy var pickerView = UIPickerView.init()
    private lazy var pickerButton: UIButton = {
        let btn = UIButton.init(type: .system)
        btn.setImage(UIImage(named: "down-arrow"), for: .normal)
        btn.tintColor = .darkGray
        btn.titleLabel?.adjustsFontSizeToFitWidth = true
        btn.setTitleColor(UIColor.gray, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        btn.layer.borderColor = UIColor.gray.cgColor
        btn.layer.borderWidth = 1
        btn.layer.cornerRadius = 5
        btn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)
        btn.imageEdgeInsets = UIEdgeInsets(top: 5, left: (bounds.width - 20), bottom: 5, right: 5)
        btn.contentHorizontalAlignment = .left
        return btn
    }()
    
    func setPickerView(delegate: UIPickerViewDelegate, datasource: UIPickerViewDataSource, placeHolder: String? = nil) {
        if let placeHolder = placeHolder {
            self.pickerButton.setTitle(placeHolder, for: .normal)
        }
        self.pickerView.delegate = delegate
        self.pickerView.dataSource = datasource
    }

    override func addTarget(_ target: Any?, action: Selector, for controlEvents: UIControl.Event) {
        self.pickerButton.addTarget(target, action: action, for: controlEvents)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setupView()
        
        pickerButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)
        if pickerButton.imageView != nil {
            pickerButton.imageEdgeInsets = UIEdgeInsets(top: 5, left: (bounds.width - 20), bottom: 5, right: 5)
        }
    }
    
    private func setupView() {
        self.addSubview(pickerButton)
        
        pickerButton.translatesAutoresizingMaskIntoConstraints = false
        let horizontalConstraint = NSLayoutConstraint(item: pickerButton, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1, constant: 0)
        let verticalConstraint = NSLayoutConstraint(item: pickerButton, attribute: NSLayoutConstraint.Attribute.centerY, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.centerY, multiplier: 1, constant: 0)
        let widthConstraint = NSLayoutConstraint(item: pickerButton, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.width, multiplier: 1, constant: 0)
        let heightConstraint = NSLayoutConstraint(item: pickerButton, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.height, multiplier: 1, constant: 0)
        self.addConstraints([horizontalConstraint, verticalConstraint, widthConstraint, heightConstraint])
    }
    
    func setSelectedValue(text: String) {
        self.pickerButton.setTitle(text, for: .normal)
    }

    func getSelectedIndex() -> Int {
        return self.pickerView.selectedRow(inComponent: 0)
    }
    
    func presentPicker(parentViewController: UIViewController, presentationControllerDelegate : UIPopoverPresentationControllerDelegate, delegate: KTCustomPickerViewDelegate) {
        
        self.delegate = delegate
        self.parentViewController = parentViewController
        
        if isPad {
            presentPickerForIPad(parentViewController: parentViewController, presentationControllerDelegate: presentationControllerDelegate, delegate: delegate)
        } else {
            presentPickerForIPhone(parentViewController: parentViewController, presentationControllerDelegate: presentationControllerDelegate, delegate: delegate)
        }
    }
    
    private func presentPickerForIPad(parentViewController: UIViewController, presentationControllerDelegate : UIPopoverPresentationControllerDelegate, delegate: KTCustomPickerViewDelegate) {
        
        pickerView.frame = CGRect(x: 0, y: 0,width: parentViewController.view.frame.width / 2, height: parentViewController.view.frame.height / 2)
        
        let doneBarButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(pickDoneForIPad_Tapped))
        doneBarButton.tintColor = UIColor.orange
        
        let cancelBarButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(pickCancelForIPad_Tapped))
        cancelBarButton.tintColor = UIColor.blue
        
        let viewForPop = UIViewController()
        viewForPop.navigationItem.rightBarButtonItem = doneBarButton
        viewForPop.navigationItem.leftBarButtonItem = cancelBarButton
        viewForPop.view.addSubview(self.pickerView)
        viewForPop.view.backgroundColor = .white
        
        let nav = UINavigationController(rootViewController: viewForPop)
        nav.modalPresentationStyle = .formSheet
        
        let popover = nav.popoverPresentationController
        viewForPop.preferredContentSize = CGSize(width: parentViewController.view.frame.width / 2, height: parentViewController.view.frame.height / 2)
        popover?.delegate = presentationControllerDelegate
        popover?.sourceView = pickerButton
        popover?.sourceRect = CGRect(x: pickerButton.frame.origin.x, y: pickerButton.frame.maxY * 2 , width: 0, height: 0)
        parentViewController.present(nav, animated: true, completion: nil)
    }
    
    private func presentPickerForIPhone(parentViewController: UIViewController, presentationControllerDelegate : UIPopoverPresentationControllerDelegate, delegate: KTCustomPickerViewDelegate) {
        
        pickerView.frame = CGRect(x: 0, y: 45,width: parentViewController.view.frame.size.width-16, height: 170)
        
        let title = ""
        let message = "\n\n\n\n\n\n\n\n\n\n"
        
        alertController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        alertController.isModalInPopover = true
        alertController.view.addSubview(pickerView)
        
        let toolFrame = CGRect(x: 17, y: 5, width: parentViewController.view.frame.width, height: 45)
        let toolView: UIView = UIView(frame: toolFrame)
        
        let buttonCancel: UIButton = UIButton(frame:  CGRect(x: 0, y: 7, width: 60, height: 30))
        buttonCancel.setTitle("Cancel", for: .normal)
        buttonCancel.setTitleColor(.blue, for: .normal)
        buttonCancel.titleLabel?.lineBreakMode = .byTruncatingTail
        buttonCancel.addTarget(self, action: #selector(pickCancelForIPhone_Tapped), for: .touchUpInside)
        toolView.addSubview(buttonCancel)
        
        let buttonDone: UIButton = UIButton(frame: CGRect(x: parentViewController.view.frame.size.width-115,y: 7, width: 60, height: 30));
        buttonDone.setTitle("Done", for: .normal)
        buttonDone.setTitleColor(.orange, for: .normal)
        buttonDone.titleLabel?.lineBreakMode = .byTruncatingTail
        buttonDone.addTarget(self, action: #selector(pickDoneForIPhone_Tapped), for: .touchUpInside)
        toolView.addSubview(buttonDone)
        
        alertController.view.addSubview(toolView)
        parentViewController.present(alertController, animated: true, completion: nil)
    }
    
    @objc private func pickDoneForIPad_Tapped() {
        parentViewController.dismiss(animated: true, completion: nil)
        delegate?.doneTapped(sender: self)
    }
    
    @objc private func pickCancelForIPad_Tapped() {
        parentViewController.dismiss(animated: true, completion: nil)
        delegate?.cancelTapped(sender: self)
    }
    
    @objc private func pickDoneForIPhone_Tapped() {
        alertController.dismiss(animated: true, completion: nil)
        delegate?.doneTapped(sender: self)
    }
    
    @objc private func pickCancelForIPhone_Tapped() {
        alertController.dismiss(animated: true, completion: nil)
        delegate?.cancelTapped(sender: self)
    }
    
}
