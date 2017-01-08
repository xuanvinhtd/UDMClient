//
//  SignInViewController.swift
//  UDMClient
//
//  Created by OSXVN on 1/4/17.
//  Copyright © 2017 XUANVINHTD. All rights reserved.
//

import UIKit

final class SignInViewController: UIViewController {
    
    // MARK: - Properties
    var buttonloginFacebook: FBSDKLoginButton!
    
    override func configItems() {
        // MARK: - Initialize sign-in Google
        var configureError: NSError?
        GGLContext.sharedInstance().configureWithError(&configureError)
        GIDSignIn.sharedInstance().delegate = self
        
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().signInSilently()
    }
    
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configItems()
    }
    
    override func viewWillDisappear(animated: Bool) {
        GIDSignIn.sharedInstance().signOut()
    }
    
    // MARK: - Action button Sign
    @IBAction func signWithFacebook(sender: AnyObject) {
        
        let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
        
        fbLoginManager.logInWithReadPermissions(["email"], fromViewController: self) { (result, error) -> Void in
            
            if (error == nil){
                let fbloginresult : FBSDKLoginManagerLoginResult = result
                if(fbloginresult.grantedPermissions != nil && fbloginresult.grantedPermissions.contains("email"))
                {
                    self.getFBUserData()
                }
            }
        }
    }
    @IBAction func signWithGoogle(sender: AnyObject) {
        GIDSignIn.sharedInstance().signIn()
    }
    
    @IBAction func signWithEmail(sender: AnyObject) {
        let vc = SignUpViewController.initFromNib()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func loginAccount(sender: AnyObject) {
        let vc = SignUpViewController.initFromNib() as! SignUpViewController
        vc.isPageSignIn = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
// MARK: - Google Sign
extension SignInViewController:GIDSignInUIDelegate, GIDSignInDelegate {
    
    func signInWillDispatch(signIn: GIDSignIn!, error: NSError!) {
    }
    
    func signIn(signIn: GIDSignIn!, presentViewController viewController: UIViewController!) {
        self.presentViewController(viewController, animated: true, completion: nil)
    }
    
    func signIn(signIn: GIDSignIn!, dismissViewController viewController: UIViewController!) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func signIn(signIn: GIDSignIn!, didSignInForUser user: GIDGoogleUser!, withError error: NSError!) {
        if (error == nil) {
            //get infor send to server
            guard let accessToken = user.authentication.accessToken else {
                log.error("Get accessToken of google = nil")
                return
            }
            let data = ["accessToken": accessToken]
            UDMServer.share.signInAccount(withData: data, Completion: { (data, msg, success) in
                if success {
                    log.info("Sigin with google Success")
                    _ = data["accessToken"]
                    self.navigationController?.popViewControllerAnimated(true)
                } else {
                    log.error("Sigin with google: \(msg)")
                }
            })
            log.info("Infor user from Google : \(user.profile)")
        } else {
            log.error("\(error.localizedDescription)")
        }
    }
    
    func signIn(signIn: GIDSignIn!, didDisconnectWithUser user:GIDGoogleUser!, withError error: NSError!) {
        let data = ["fullname":"", "email":"", "password":""]
        UDMServer.share.signInAccount(withData: data) { (data, msg, success) in
            if success {
                log.info("Sigin with google success")
                _ = data["accessToken"]
                self.navigationController?.popViewControllerAnimated(true)
            } else {
                log.error("Sigin with google: \(msg)")
            }
        }
    }
}
// MARK: - Facebook Sign
extension SignInViewController {
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        //println("\(UDMUser.shareManager.getInforUser().fullName) Logged Out")
    }
    
    func getFBUserData(){
        if((FBSDKAccessToken.currentAccessToken()) != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).startWithCompletionHandler({ (connection, result, error) -> Void in
                if (error == nil){
                    log.info("Infor user from Facebook : \(result)")
                    let data = ["accessToken": String(result["accessToken"])]
                    UDMServer.share.signInAccount(withData: data, Completion: { (data, msg, success) in
                        if success {
                            log.info("Sigin with google Success")
                            _ = data["accessToken"]
                            self.navigationController?.popViewControllerAnimated(true)
                        } else {
                            log.error("Sigin with google: \(msg)")
                        }
                    })
                    log.info("Info of Facebook: \(result)")
                }
            })
        }
    }
}

