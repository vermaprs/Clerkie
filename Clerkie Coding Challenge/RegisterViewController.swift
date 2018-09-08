//
//  RegisterViewController.swift
//  Clerkie Coding Challenge
//
//  Created by Prashant Verma on 8/31/18.
//  Copyright © 2018 Prashant Verma. All rights reserved.
//

import Foundation
import Parse
import SBCardPopup

class RegisterViewController: UIViewController, SBCardPopupContent, UITextFieldDelegate {
    
    @IBAction func closePopUp(_ sender: Any) {
        self.popupViewController?.close()
    }
    
    @IBOutlet weak var userNameTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var repeatPasswordTextField: UITextField!
    
    var popupViewController: SBCardPopupViewController?
    
    var allowsTapToDismissPopupCard: Bool = true
    
    var allowsSwipeToDismissPopupCard: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userNameTextField.text = nil
        userNameTextField.placeholder = "Email address or Phone number"
        passwordTextField.text = nil
        passwordTextField.placeholder = "Password"
        repeatPasswordTextField.text = nil
        repeatPasswordTextField.placeholder = "Password"
        userNameTextField.delegate = self
        passwordTextField.delegate = self
        repeatPasswordTextField.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        userNameTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        repeatPasswordTextField.resignFirstResponder()
        return true
    }
    
    static func create() -> UIViewController{
        let storyboard = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "Register") as! RegisterViewController
        return storyboard
    }
    
    func loadLoginScreen(){
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let loginViewController = storyBoard.instantiateViewController(withIdentifier: "Login") as! LoginViewController
        self.present(loginViewController, animated: true, completion: nil)
    }
    
    func displayErrorMessage(message:String) {
        let alertView = UIAlertController(title: "Error!", message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction) in
        }
        alertView.addAction(OKAction)
        if let presenter = alertView.popoverPresentationController {
            presenter.sourceView = self.view
            presenter.sourceRect = self.view.bounds
        }
        self.present(alertView, animated: true, completion:nil)
    }
    
    func isValid(_ user: String) -> Bool {
        let emailRegEx = "(?:[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}" + "~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\" +
            "x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[\\p{L}0-9](?:[a-" +
            "z0-9-]*[\\p{L}0-9])?\\.)+[\\p{L}0-9](?:[\\p{L}0-9-]*[\\p{L}0-9])?|\\[(?:(?:25[0-5" +
            "]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-" +
            "9][0-9]?|[\\p{L}0-9-]*[\\p{L}0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21" +
        "-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"
        let email = NSPredicate(format:"SELF MATCHES[c] %@", emailRegEx)
        let emailEval = email.evaluate(with: user)
        let phoneRegEx = "^\\d{3}-\\d{3}-\\d{4}$"
        let phone = NSPredicate(format: "SELF MATCHES %@", phoneRegEx)
        let phoneEval =  phone.evaluate(with: user)
        
        return emailEval || phoneEval
    }
    
    func isValidPassword(password: String) -> Bool {
        let passwordRegex = "^(?=.*\\d)(?=.*[a-z])(?=.*[A-Z])[0-9a-zA-Z!@#$%^&*()\\-_=+{}|?>.<,:;~`’]{8,}$"
        let pass =  NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        return pass.evaluate(with: password)
    }
    
    @IBAction func registerAction(_ sender: Any) {
        
        let user = PFUser()
        user.username = userNameTextField.text
        user.password = passwordTextField.text
        print(user.password)
        
        print(isValidPassword(password: user.password!))
        
        let repeatPassword = repeatPasswordTextField.text
        
        
        if(user.username == ""){
            let alert = UIAlertController(title: "Error", message: "Username field can not be left blank.", preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
                
            }
            alert.addAction(OKAction)
            self.present(alert, animated: true, completion: nil)
            return
        }
        else if(isValid(user.username!) != true){
            let alert = UIAlertController(title: "Error", message: "Please enter a valid email address or phone number.", preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
                
            }
            alert.addAction(OKAction)
            self.present(alert, animated: true, completion: nil)
            return
            
        }

        else if(user.password == ""){
            let alert = UIAlertController(title: "Error", message: "Password field can not be left blank.", preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
                
            }
            alert.addAction(OKAction)
            self.present(alert, animated: true, completion: nil)
            return
        }
        else if(isValidPassword(password: user.password!) != true){
            let alert = UIAlertController(title: "Error", message: "Password should me more than 8 characters with at least one capital, numeric or special character.", preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
                
            }
            alert.addAction(OKAction)
            self.present(alert, animated: true, completion: nil)
            return
        }
        else if(user.password != repeatPassword){
            let alert = UIAlertController(title: "Error", message: "Please enter same password in both fields.", preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
                
            }
            alert.addAction(OKAction)
            self.present(alert, animated: true, completion: nil)
            return
        }
        else if(isValid(user.username!) == true && isValidPassword(password: user.password!) == true){
            let sv = LoginViewController.displaySpinner(onView: self.view)
            user.signUpInBackground { (success, error) in
                LoginViewController.removeSpinner(spinner: sv)
                if success{
                    self.loadLoginScreen()
                }else{
                    if let descrip = error?.localizedDescription{
                        self.displayErrorMessage(message: descrip)
                    }
                }
            }
        }
        
    }
    
}

