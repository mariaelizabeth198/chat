//
//  LoginController.swift
//  chat
//
//  Created by Maria Elizabeth Da Silva Bezerra on 07/02/2019.
//  Copyright © 2019 Maria Elizabeth. All rights reserved.
//

import UIKit
import Firebase

class LoginController: UIViewController {
    var inputsContainerViewHeightAnchor: NSLayoutConstraint?
    var nameTextFieldHeightAnchor: NSLayoutConstraint?
    var emailTextFieldHeightAnchor: NSLayoutConstraint?
    
    let inputsContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        return view
    }()
    
    let loginRegisterButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(r: 80, g: 101, b: 161)
        button.setTitle("Register", for: .normal)
        button.layer.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.addTarget(self, action: #selector(handleRegister), for: .touchUpInside)
        return button
    }()
    
    @objc fileprivate func handleRegister() {
        guard let name = nameTextField.text,
            let email = emailTextField.text,
            let password = passwordTextField.text else {return}
        
        Auth.auth().createUser(withEmail: email, password: password, completion: { (user: User?, error) in
            if error != nil {
                print("ERROR")
                return
            }
            
            guard let uid = user?.uid else {return}
            
            var ref: DatabaseReference!
            ref = Database.database().reference(fromURL: "https://chat-f1e27.firebaseio.com/")
            let usersReference = ref.child("users").child(uid)
            let values = ["name": name, "email": email]
            usersReference.updateChildValues(values, withCompletionBlock: { (error, ref) in
                if error != nil {
                    print(error ?? "an error")
                    return
                }
                
                print("Saved user success")
                
            })
            
        })
    }
    
    let nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Name"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let nameSeparatorView:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Email address"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let emailSeparatorView:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Password"
        textField.isSecureTextEntry = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "user")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let loginRegisterSegmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Login", "Register"])
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.tintColor = .white
        sc.selectedSegmentIndex = 1
        sc.addTarget(self, action: #selector(handleLoginRegisterChanged), for: .valueChanged)
        return sc
    }()
    
    @objc fileprivate func handleLoginRegisterChanged() {
        let title = loginRegisterSegmentedControl.titleForSegment(at: loginRegisterSegmentedControl.selectedSegmentIndex)
        loginRegisterButton.setTitle(title, for: .normal)
        inputsContainerViewHeightAnchor?.constant = loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 100: 150
        
        nameTextFieldHeightAnchor?.isActive = false
        nameTextFieldHeightAnchor = loginRegisterSegmentedControl.selectedSegmentIndex == 0 ?
            nameTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 0) :
            nameTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3)
        nameTextFieldHeightAnchor?.isActive = true
        
        emailTextFieldHeightAnchor?.isActive = false
        emailTextFieldHeightAnchor = loginRegisterSegmentedControl.selectedSegmentIndex == 0 ?
            emailTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/2) :
            emailTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3)
        emailTextFieldHeightAnchor?.isActive = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(r:61, g: 91, b: 151)
        view.addSubview(profileImageView)
        view.addSubview(loginRegisterSegmentedControl)
        view.addSubview(inputsContainerView)
        view.addSubview(loginRegisterButton)
        
        setupProfileImageView()
        setupLoginRegisterSegmentControl()
        setupInputsContainerView()
        setupLoginRegisterButton()
    }
    
    fileprivate func setupProfileImageView() {
        profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileImageView.bottomAnchor.constraint(equalTo: loginRegisterSegmentedControl.topAnchor, constant: -12).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
    }
    
    fileprivate func setupLoginRegisterSegmentControl() {
        loginRegisterSegmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginRegisterSegmentedControl.bottomAnchor.constraint(equalTo: inputsContainerView.topAnchor, constant: -10).isActive = true
        loginRegisterSegmentedControl.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor, multiplier: 1).isActive = true
        loginRegisterSegmentedControl.heightAnchor.constraint(equalToConstant: 35).isActive = true
    }
    
    fileprivate func setupInputsContainerView() {
        inputsContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inputsContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        inputsContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        inputsContainerViewHeightAnchor = inputsContainerView.heightAnchor.constraint(equalToConstant: 150)
        inputsContainerViewHeightAnchor?.isActive = true
        
        inputsContainerView.addSubview(nameTextField)
        inputsContainerView.addSubview(nameSeparatorView)
        inputsContainerView.addSubview(emailTextField)
        inputsContainerView.addSubview(emailSeparatorView)
        inputsContainerView.addSubview(passwordTextField)
        
        setupNameTextField()
        setupNameSeparatorView()
        setupEmailTextField()
        setupEmailSeparatorView()
        setupPasswordTextField()
    }
    
    fileprivate func setupNameTextField() {
        nameTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        nameTextField.topAnchor.constraint(equalTo: inputsContainerView.topAnchor).isActive = true
        nameTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        nameTextFieldHeightAnchor = nameTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3)
        nameTextFieldHeightAnchor?.isActive = true
    }
    
    fileprivate func setupNameSeparatorView() {
        nameSeparatorView.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor).isActive = true
        nameSeparatorView.topAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true
        nameSeparatorView.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        nameSeparatorView.heightAnchor.constraint(equalToConstant: 2).isActive = true
    }
    
    fileprivate func setupEmailTextField() {
        emailTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        emailTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true
        emailTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        
        emailTextFieldHeightAnchor = emailTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3)
        emailTextFieldHeightAnchor?.isActive = true
    }
    
    fileprivate func setupEmailSeparatorView() {
        emailSeparatorView.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor).isActive = true
        emailSeparatorView.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        emailSeparatorView.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        emailSeparatorView.heightAnchor.constraint(equalToConstant: 2).isActive = true
    }
    
    fileprivate func setupPasswordTextField() {
        passwordTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        passwordTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        passwordTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3).isActive = true
    }
    
    fileprivate func setupLoginRegisterButton() {
        loginRegisterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginRegisterButton.topAnchor.constraint(equalTo: inputsContainerView.bottomAnchor, constant: 12).isActive = true
        loginRegisterButton.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        loginRegisterButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
}

extension UIColor {
    convenience init(r:CGFloat, g: CGFloat, b: CGFloat) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
}
