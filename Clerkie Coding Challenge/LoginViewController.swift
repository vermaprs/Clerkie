//
//  LoginViewController.swift
//  Clerkie Coding Challenge
//
//  Created by Prashant Verma on 8/25/18.
//  Copyright © 2018 Prashant Verma. All rights reserved.
//

import Foundation
import UIKit
import Parse
import SBCardPopup

class LoginViewController: UIViewController, UITextFieldDelegate{
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var loginButton: RoundCorner!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextField.text = nil
        emailTextField.placeholder = "Email address or Phone number"
        passwordTextField.text = nil
        passwordTextField.placeholder = "Password"
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        let currentUser = PFUser.current()
        if currentUser != nil {
            loadHomeScreen()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        return true
    }
    
    @IBAction func registerAction(_ sender: Any) {
        let popUpView = RegisterViewController.create()
        let registerPopUp = SBCardPopupViewController(contentViewController: popUpView)
        registerPopUp.show(onViewController: self)
        
    }
    
    func loadHomeScreen(){
        performSegue(withIdentifier: "loginToLoggedIn", sender: LoginViewController.self)
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
    
    @IBAction func loginAction(_ sender: RoundCorner) {
        
        let sv = LoginViewController.displaySpinner(onView: self.view)
        PFUser.logInWithUsername(inBackground: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
            LoginViewController.removeSpinner(spinner: sv)
            if user != nil {
                self.loadHomeScreen()
            }else{
                if let descrip = error?.localizedDescription{
                    self.displayErrorMessage(message: (descrip))
                }
            }
        }

    }
    
}

extension LoginViewController{
    class func displaySpinner(onView : UIView) -> UIView {
        let spinnerView = UIView.init(frame: onView.bounds)
        spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let ai = UIActivityIndicatorView.init(activityIndicatorStyle: .whiteLarge)
        ai.startAnimating()
        ai.center = spinnerView.center
        
        DispatchQueue.main.async {
            spinnerView.addSubview(ai)
            onView.addSubview(spinnerView)
        }
        
        return spinnerView
    }
    
    class func removeSpinner(spinner :UIView) {
        DispatchQueue.main.async {
            spinner.removeFromSuperview()
        }
    }
}


