//
//  PasswordField.swift
//  PasswordTextField
//
//  Created by Ben Gohlke on 6/26/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

enum Strength: String {
    case weak = "Too Weak"
    case medium = "Could Be Stronger"
    case strong = "Strong Password"
}

class PasswordField: UIControl {
    
    // Public API - these properties are used to fetch the final password and strength values
    private (set) var password: String = ""
    private (set) var passwordStrength: Strength = .weak
    
    private let standardMargin: CGFloat = 8.0
    private let textFieldContainerHeight: CGFloat = 50.0
    private let textFieldMargin: CGFloat = 6.0
    private let colorViewSize: CGSize = CGSize(width: 60.0, height: 5.0)
    
    private let labelTextColor = UIColor(hue: 233.0/360.0, saturation: 16/100.0, brightness: 41/100.0, alpha: 1)
    private let labelFont = UIFont.systemFont(ofSize: 14.0, weight: .semibold)
    
    private let textFieldBorderColor = UIColor(hue: 208/360.0, saturation: 80/100.0, brightness: 94/100.0, alpha: 1)
    private let bgColor = UIColor(hue: 0, saturation: 0, brightness: 97/100.0, alpha: 1)
    
    // States of the password strength indicators
    private let unusedColor = UIColor(hue: 210/360.0, saturation: 5/100.0, brightness: 86/100.0, alpha: 1)
    private let weakColor = UIColor(hue: 0/360, saturation: 60/100.0, brightness: 90/100.0, alpha: 1)
    private let mediumColor = UIColor(hue: 39/360.0, saturation: 60/100.0, brightness: 90/100.0, alpha: 1)
    private let strongColor = UIColor(hue: 132/360.0, saturation: 60/100.0, brightness: 75/100.0, alpha: 1)
    
    private var titleLabel: UILabel = UILabel()
    private var textField: UITextField = UITextField()
    private var showHideButton: UIButton = UIButton()
    private var weakView: UIView = UIView()
    private var mediumView: UIView = UIView()
    private var strongView: UIView = UIView()
    private var strengthDescriptionLabel: UILabel = UILabel()
    private var passwordStrengthStackView = UIStackView()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
        textField.delegate = self
    }
    
    func setup() {
        // MARK: - Add Subviews -
        addSubview(textField)
        addSubview(titleLabel)
        addSubview(passwordStrengthStackView)
        addSubview(strengthDescriptionLabel)
        
        // MARK: - Translates Autoresizing Mask Into Constraints -
        showHideButton.translatesAutoresizingMaskIntoConstraints = false
        
        // MARK: - Title Label -
        titleLabel.anchor(top: self.safeAreaLayoutGuide.topAnchor, leading: self.safeAreaLayoutGuide.leadingAnchor, trailing: nil, bottom: nil, padding: .init(top: standardMargin, left: standardMargin, bottom: 0, right: 0), size: .zero)
        titleLabel.text = "ENTER PASSWORD"
        titleLabel.font = labelFont
        titleLabel.textColor = labelTextColor
        
        // MARK: - Text Field -
        textField.anchor(top: titleLabel.bottomAnchor, leading: self.safeAreaLayoutGuide.leadingAnchor, trailing: self.safeAreaLayoutGuide.trailingAnchor, bottom: nil, padding: .init(top: standardMargin, left: 0, bottom: 0, right: 0), size: CGSize(width: .zero, height: textFieldContainerHeight))
        
        textField.layer.cornerRadius = standardMargin
        textField.layer.borderWidth = 2.0
        textField.layer.borderColor = textFieldBorderColor.cgColor
        textField.placeholder = "Enter a strong password"
        textField.borderStyle = .roundedRect
        textField.backgroundColor = bgColor
        textField.isSecureTextEntry = true
        textField.rightView = showHideButton
        textField.rightViewMode = .always
        
        // MARK: - Show Hide Button -
        
        showHideButton.setImage(UIImage(named: "eyes-closed"), for: .normal)
        showHideButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -2.0 * standardMargin, bottom: 0, right: 0)
        showHideButton.addTarget(self, action: #selector(showHideButtonTapped), for: .touchUpInside)
        
        weakView.backgroundColor = unusedColor
        mediumView.backgroundColor = unusedColor
        strongView.backgroundColor = unusedColor
        
        weakView.anchor(top: nil, leading: nil, trailing: nil, bottom: nil, padding: .zero, size: CGSize(width: colorViewSize.width, height: colorViewSize.height))
        mediumView.anchor(top: nil, leading: nil, trailing: nil, bottom: nil, padding: .zero, size: CGSize(width: colorViewSize.width, height: colorViewSize.height))
        strongView.anchor(top: nil, leading: nil, trailing: nil, bottom: nil, padding: .zero, size: CGSize(width: colorViewSize.width, height: colorViewSize.height))
        
        strengthDescriptionLabel.text = "weak password"
        strengthDescriptionLabel.font = labelFont
        
        passwordStrengthStackView.axis = .horizontal
        passwordStrengthStackView.distribution = .equalSpacing
        
        passwordStrengthStackView.addArrangedSubview(weakView)
        passwordStrengthStackView.addArrangedSubview(mediumView)
        passwordStrengthStackView.addArrangedSubview(strongView)
        
        passwordStrengthStackView.anchor(top: textField.bottomAnchor, leading: textField.leadingAnchor, trailing: nil, bottom: nil, padding: .init(top: standardMargin * 1.5, left: textFieldMargin - 2, bottom: 0, right: 0), size: CGSize(width: colorViewSize.width * 3 + standardMargin, height: colorViewSize.height))
        
        strengthDescriptionLabel.anchor(top: textField.bottomAnchor, leading: passwordStrengthStackView.trailingAnchor, trailing: nil, bottom: nil, padding: .init(top: textFieldMargin, left: standardMargin, bottom: 0, right: 0), size: .zero)
    }
    
    @objc func showHideButtonTapped() {
        textField.isSecureTextEntry.toggle()
        if textField.isSecureTextEntry {
            showHideButton.setImage(UIImage(named: "eyes-closed"), for: .normal)
        } else {
            showHideButton.setImage(UIImage(named: "eyes-open"), for: .normal)
        }
    }
    
    func passwordStrength(newPassword: String) {
        switch newPassword.count {
        case 0:
            strengthDescriptionLabel.text = Strength.weak.rawValue
            weakView.backgroundColor = unusedColor
            mediumView.backgroundColor = unusedColor
            strongView.backgroundColor = unusedColor
            passwordStrength = .weak
            password = newPassword
        case 1...9:
            strengthDescriptionLabel.text = Strength.weak.rawValue
            weakView.backgroundColor = weakColor
            mediumView.backgroundColor = unusedColor
            strongView.backgroundColor = unusedColor
            passwordStrength = .weak
            password = newPassword
        case 10...19:
            strengthDescriptionLabel.text = Strength.medium.rawValue
            weakView.backgroundColor = weakColor
            mediumView.backgroundColor = mediumColor
            strongView.backgroundColor = unusedColor
            passwordStrength = .medium
            password = newPassword
        case 20...50:
            strengthDescriptionLabel.text = Strength.strong.rawValue
            weakView.backgroundColor = weakColor
            mediumView.backgroundColor = mediumColor
            strongView.backgroundColor = strongColor
            passwordStrength = .strong
            password = newPassword
        default:
            strengthDescriptionLabel.text = "Password Too Long"
        }
        
        if newPassword .count == 1 {
            weakView.performFlare()
        } else if newPassword.count == 10 {
            mediumView.performFlare()
        } else if newPassword.count == 20 {
            strongView.performFlare()
        } else if newPassword.count == 51 {
            weakView.performFlare()
            mediumView.performFlare()
            strongView.performFlare()
        }
    }
}

extension PasswordField: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let oldText = textField.text!
        let stringRange = Range(range, in: oldText)!
        let newText = oldText.replacingCharacters(in: stringRange, with: string)
        // TODO: send new text to the determine strength method
        passwordStrength(newPassword: newText)
        return true
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let newPassword = textField.text {
            password = newPassword
            sendActions(for: .valueChanged)
        }
        weakView.performFlare()
        mediumView.performFlare()
        strongView.performFlare()
        textField.resignFirstResponder()
        return true
    }
}

extension UIView {
    func performFlare() {
        func flare() {
            transform = CGAffineTransform(scaleX: 1, y: 1.8)
        }
        func unflare() {
            transform = .identity
        }
        
        UIView.animate(withDuration: 0.3, animations: {
            flare()
        }) { _ in
            UIView.animate(withDuration: 0.1, animations: {
                unflare()
            })
        }
    }
}

