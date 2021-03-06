//
//  LoginController.swift
//  BuyGoggles
//
//  Created by Eddie Char on 1/18/21.
//

import UIKit
import Firebase
import SwiftUI

class LoginController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginErrorLabel: UILabel!
    @IBOutlet weak var peekPasswordButton: UIButton!
    
    var loadingView = UIHostingController(rootView: LoadingView())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let email = UserDefaults.standard.string(forKey: "loginEmail")
        let password = UserDefaults.standard.string(forKey: "loginPassword")
        let attributedEmailPlaceholder = NSAttributedString(string: "Email address",
                                                            attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        let attributedPasswordPlaceholder = NSAttributedString(string: "Password",
                                                               attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])

        loginErrorLabel.alpha = 0
        loadingView.view.alpha = 0
        loadingView.view.backgroundColor = .clear
        loadingView.view.translatesAutoresizingMaskIntoConstraints = false
        
        emailField.delegate = self
        passwordField.delegate = self
        emailField.text = email
        passwordField.text = password
        emailField.attributedPlaceholder = attributedEmailPlaceholder
        passwordField.attributedPlaceholder = attributedPasswordPlaceholder
        
        peekPasswordButton.addTarget(self, action: #selector(peekPasswordTapped(_:)), for: .touchDown)
        peekPasswordButton.addTarget(self, action: #selector(unpeekPasswordTapped(_:)), for: .touchUpInside)
        
        //Dismiss keyboard if tapping outside of the text fields.
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapScreen(_:)))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func peekPasswordTapped(_ sender: UIButton) {
        passwordField.isSecureTextEntry = false
    }
    
    @objc func unpeekPasswordTapped(_ sender: UIButton) {
        passwordField.isSecureTextEntry = true
    }
    
    @objc func didTapScreen(_ sender: UITapGestureRecognizer) {
        let tapLocation = sender.location(in: view)
        let emailFrame = emailField.convert(emailField.frame, to: view)
        let passwordFrame = passwordField.convert(passwordField.frame, to: view)

        if tapLocation.x < emailFrame.origin.x ||
            tapLocation.x > emailFrame.origin.x + emailFrame.width ||
            tapLocation.y < emailFrame.origin.y ||
            tapLocation.y > passwordFrame.origin.y + passwordFrame.height {
            
            self.view.endEditing(true)
        }
    }

    @IBAction func loginPressed(_ sender: UIButton) {
        guard let email = emailField.text, let password = passwordField.text else { return }
        
        Auth.auth().signIn(withEmail: email, password: password) { [unowned self] (authResult, error) in
            guard error == nil else {
                loginErrorLabel.alpha = 1
                UIView.animate(withDuration: 0.5, delay: 2.0, options: .curveEaseIn, animations: {
                    self.loginErrorLabel.alpha = 0
                }, completion: nil)

                print(error!.localizedDescription)
                return
            }
            
            //Save password to UserDefaults
            UserDefaults.standard.set(email, forKey: "loginEmail")
            UserDefaults.standard.set(password, forKey: "loginPassword")
                        
            view.addSubview(loadingView.view)
            addChild(loadingView)
            NSLayoutConstraint.activate([loadingView.view.topAnchor.constraint(equalTo: view.topAnchor),
                                         loadingView.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                                         view.trailingAnchor.constraint(equalTo: loadingView.view.trailingAnchor),
                                         view.bottomAnchor.constraint(equalTo: loadingView.view.bottomAnchor)])
            
            UIView.animate(withDuration: 0.5, animations: {
                self.loadingView.view.alpha = 1.0
            }, completion: nil)
            
            FIRManager.initializeRecords { [unowned self] _ in
                loadingView.removeFromParent()
                performSegue(withIdentifier: "LoginSegue", sender: nil)
            }
        }
    }
}


// MARK: - UITextFieldDelegate

extension LoginController {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailField {
            guard textField.text!.count > 0 else { return false }
            
            passwordField.becomeFirstResponder()
        }
        else {
            guard textField.text!.count > 0 else { return false }
            
            self.view.endEditing(true)
        }
        
        return false
    }
}
