//
//  SignUpViewController.swift
//  UDMSwift
//
//  Created by OSXVN on 8/23/16.
//  Copyright © 2016 XUANVINHTD. All rights reserved.
//

class SignUpViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: - Properties
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var titlePage: UILabel!
    
    @IBOutlet weak var textBoxEmail: UITextField!
    
    @IBOutlet weak var iconFullName: UIImageView!
    @IBOutlet weak var textBoxFullName: UITextField!
    
    @IBOutlet weak var iconPassword: UIImageView!
    @IBOutlet weak var textBoxPassword: UITextField!
    @IBOutlet weak var textBoxRePassword: UITextField!
    
    @IBOutlet weak var line1View: UIView!
    
    @IBOutlet weak var buttonSignUp: UIButton!
    @IBOutlet weak var labelPolicy: UILabel!
    
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    
    var isPageSignIn: Bool = false
    
    override func configItems() {
        //SetUp page SignIn
        iconFullName.hidden = isPageSignIn
        textBoxFullName.hidden = isPageSignIn
        iconPassword.hidden = isPageSignIn
        textBoxRePassword.hidden = isPageSignIn
        line1View.hidden = isPageSignIn
        
        // Delegate textBox
        textBoxFullName.delegate = self
        textBoxEmail.delegate = self
        textBoxPassword.delegate = self
        textBoxRePassword.delegate = self
        
        if isPageSignIn {
            titlePage.text = "Sign in with your email address"
            labelPolicy.text = "By clicking on 'Sign In' you agree to our Terms of Service and Privacy Policy."
        }
    }
    
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configItems()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    // MARK: - Sign Account
    @IBAction func signUpAccount(sender: AnyObject) {
        guard let email = textBoxEmail.text, passwd = textBoxPassword.text else {
            return
        }
        activityIndicatorView.startAnimating()
        
        if isPageSignIn {
            if checkError(isPageSignIn) {
                activityIndicatorView.stopAnimating()
                return
            }
            
            let data = UDMDictionaryBuilder.share.login(withEmail: email, password: passwd)
            UDMServer.share.signInAccount(withData: data, Completion: { (data, msg, success) in
                if success {
                    self.saveUser(withData: data)
                    dispatch_async(dispatch_get_main_queue(), {
                        self.activityIndicatorView.stopAnimating()
                    })
                } else {
                    dispatch_async(dispatch_get_main_queue(), {
                        self.activityIndicatorView.stopAnimating()
                    })
                    UDMAlert.alert(title: "Sigin Error", message: msg, dismissTitle: "OK", inViewController: self, withDismissAction: nil)
                }
            })
        } else {
            guard let fullName = textBoxFullName.text else {
                return
            }
            
            if checkError(isPageSignIn) {
                activityIndicatorView.stopAnimating()
                return
            }
            let data = UDMDictionaryBuilder.share.signin(withFullName: fullName, email: email, password: passwd)
            UDMServer.share.signInAccount(withData: data, Completion: { (data, msg, success) in
                if success {
                    self.saveUser(withData: data)
                    dispatch_async(dispatch_get_main_queue(), {
                        self.activityIndicatorView.stopAnimating()
                    })
                    log.info("Register account success!")
                } else {
                    dispatch_async(dispatch_get_main_queue(), {
                        self.activityIndicatorView.stopAnimating()
                    })
                    UDMAlert.alert(title: "Sigin Error", message: msg, dismissTitle: "OK", inViewController: self, withDismissAction: nil)
                }
            })
        }
    }
    
    func saveUser(withData data: [String: AnyObject]) -> Void{
        UserManager.share.isLogInSuccess = true
        NSNotificationCenter.defaultCenter().postNotificationName(UDMConfig.Notification.GetDataCourseAndCategory, object: nil)
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func checkError(flat: Bool) -> Bool {
        if textBoxEmail.text! == "" || textBoxPassword.text! == "" {
            UDMAlert.alert(title: "Empty field", message: "Cannot empty fields. \nPlease input.", dismissTitle: "OK", inViewController: self, withDismissAction: nil)
            return true
        }
        //Error check
        var isError = false
        var strError = ""
        
        if !UDMHelpers.isValidEmail(textBoxEmail.text!) {
            strError = "Must be a valid email address."
            isError = true
        }
        
        if !UDMHelpers.checkMinLength(textBoxPassword, minLength: 3) {
            strError += "\nPassword must be >= 8 length."
            isError = true
        }
        
        if UDMHelpers.checkMaxLength(textBoxPassword, maxLength: 16) {
            strError += "\nPassword must be <= 15 length."
            isError = true
        }
        
        if !flat {
            if !UDMHelpers.checkMinLength(textBoxRePassword, minLength: 3) {
                strError += "\nRePassword must be >= 8 length."
                isError = true
            }
            
            if UDMHelpers.checkMaxLength(textBoxRePassword, maxLength: 16) {
                strError += "\nRePassword must be <= 15 length."
                isError = true
            }
            
            if textBoxPassword.text != textBoxRePassword.text {
                strError += "\nDo not match password."
                isError = true
            }
            
            if textBoxFullName.text == "" {
                strError += "\nDo not empty fields."
                isError = true
            }
        }
        if isError {
            UDMAlert.alert(title: "Incorrect Password", message: strError, dismissTitle: "OK", inViewController: self, withDismissAction: nil)
            return true
        }
        return false
    }
    
    // MARK: Handling event
    
    @IBAction func actionResetPassword(sender: AnyObject) {
        UDMAlert.textInput(title: "Reset password", placeholder: "Input your email", oldText: "", dismissTitle: "Send", inViewController: self) { (text) in
            UDMHUD.showActivityIndicator()
            let data = UDMDictionaryBuilder.share.resetPassword(withEmail: text)
            UDMServer.share.signInAccount(withData: data, Completion: { (data, msg, success) in
                UDMHUD.hideActivityIndicator({
                    if success {
                        log.info("Send email message: \(msg)")
                    } else {
                        UDMAlert.alert(title: "Reset Password Error", message: msg, dismissTitle: "OK", inViewController: self, withDismissAction: nil)
                        log.error("ERROR message: \(msg)")
                    }
                })
            })
        }
    }
}
