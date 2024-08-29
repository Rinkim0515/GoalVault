//
//  PlanCustomTextField.swift
//  Smssme
//
//  Created by 임혜정 on 8/28/24.
//

import UIKit

// MARK: - bottomBorder 커스텀 텍스트필드
class AmountTextField {
    static func createTextField(placeholder: String, keyboard: UIKeyboardType) -> CustomTextField {
        let textField = CustomTextField()
        textField.textColor = UIColor.black
        textField.borderStyle = .none
        textField.keyboardType = keyboard
        textField.clipsToBounds = false
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "입력완료", style: .done, target: textField, action: #selector(textField.dismissKeyboard)) //분리를 위해 delegate 패턴을 쓸것인가..?
        toolbar.setItems([doneButton], animated: true)
        textField.inputAccessoryView = toolbar
        
        let currencyLabel = UILabel()
        currencyLabel.text = "원"
        currencyLabel.font = textField.font
        currencyLabel.textColor = .black
        currencyLabel.sizeToFit()
        
        textField.rightView = currencyLabel
        textField.rightViewMode = .always
        
        return textField
    }
}

class CustomTextField: UITextField {
    private let bottomBorder = CALayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupBottomBorder()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupBottomBorder()
    }
    
    private func setupBottomBorder() {
        layer.addSublayer(bottomBorder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateBottomBorder()
    }
    
    private func updateBottomBorder() {
        bottomBorder.frame = CGRect(x: 0.0, y: self.frame.height - 1, width: self.frame.width, height: 1.0)
        bottomBorder.backgroundColor = UIColor.black.cgColor
    }
    
    @objc func dismissKeyboard() { //분리를 위해 delegate 패턴을 쓸것인가..?
        resignFirstResponder()
    }
}

func createDatePicker() -> UIDatePicker {
    let picker = UIDatePicker()
    picker.datePickerMode = .date
    picker.preferredDatePickerStyle = .wheels
    picker.locale = Locale(identifier: "ko_KR")
    return picker
}