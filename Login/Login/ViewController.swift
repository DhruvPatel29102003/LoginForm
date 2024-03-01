//
//  ViewController.swift
//  Login
//
//  Created by Droadmin on 12/09/23.
//

import UIKit
import SQLite3
import FacebookLogin
import GoogleSignIn
import GoogleSignInSwift
import FirebaseCore
import FirebaseAuth


class ViewController: UIViewController {
    @IBOutlet weak var facebookBtn: FBLoginButton!
    
    var objSecondController = SecondViewController()
    @IBOutlet weak var pswTxt: UITextField!
    @IBOutlet weak var userNameTxt: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Login Page"
        

        autoLogin()
        facBookLogin()
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func googleLogin(_ sender: Any) {

        GoogleLogin.googleLogin.googleSingin(presentingViewController: self)
        
    }
    func facBookLogin(){
        if let token = AccessToken.current,!token.isExpired {
            let thirdVc = self.storyboard?.instantiateViewController(withIdentifier: "ThirdViewController") as! ThirdViewController
            self.navigationController?.pushViewController(thirdVc, animated: false)
                // User is logged in, do work such as go to next view controller.
        }else{
            facebookBtn.permissions = ["public_profile", "email"]
            facebookBtn.delegate = self

        }
    }
    func autoLogin(){
        if UserDefaults.standard.bool(forKey: "login") == true{
            let thirdVc = self.storyboard?.instantiateViewController(withIdentifier: "ThirdViewController") as! ThirdViewController
            self.navigationController?.pushViewController(thirdVc, animated: false)
        }
    }
    
    @IBAction func Regester(_ sender: Any) {
        let secondVC = self.storyboard?.instantiateViewController(withIdentifier: "SecondViewController") as! SecondViewController
        self.navigationController?.pushViewController(secondVC, animated: true)
    }
    
    @IBAction func login(_ sender: Any) {
        
        if isValidUser(username: userNameTxt.text ?? "", password: pswTxt.text ?? ""){
            UserDefaults.standard.set(true, forKey: "login")
            let thirdVc = self.storyboard?.instantiateViewController(withIdentifier: "ThirdViewController") as! ThirdViewController
            self.navigationController?.pushViewController(thirdVc, animated: true)
        }else{
            userNameTxt.layer.borderColor = UIColor.red.cgColor
            userNameTxt.layer.borderWidth = 1.0
            
            pswTxt.layer.borderColor = UIColor.red.cgColor
            pswTxt.layer.borderWidth = 1.0
            
            print("invalid username and password")
        }
        
    }
    func isValidUser(username: String, password: String) -> Bool {
        let query = "SELECT username,password FROM Regester WHERE username = ? AND password = ?"
        var statement: OpaquePointer?
        self.objSecondController.createDatabase()
        if sqlite3_prepare_v2(objSecondController.db, query, -1, &statement, nil) == SQLITE_OK {
            
            sqlite3_bind_text(statement, 1, (username as NSString).utf8String, -1, nil)
            sqlite3_bind_text(statement, 2, (password as NSString).utf8String, -1, nil)
            if sqlite3_step(statement) == SQLITE_ROW {
                print("login succsful")
                
                // Login successful, user exists with provided username and password
                sqlite3_finalize(statement)
                return true
            }
        }
        
        sqlite3_finalize(statement)
        return false
    }
    
}
extension ViewController : LoginButtonDelegate{
    func loginButton(_ loginButton: FBSDKLoginKit.FBLoginButton, didCompleteWith result: FBSDKLoginKit.LoginManagerLoginResult?, error: Error?) {
        
        if let token = result?.token?.tokenString {
            let thirdVc = self.storyboard?.instantiateViewController(withIdentifier: "ThirdViewController") as! ThirdViewController
            self.navigationController?.pushViewController(thirdVc, animated: false)
            let request = FBSDKLoginKit.GraphRequest(graphPath: "me", parameters: ["fileds": "short_name,name"], tokenString: token, version: nil, httpMethod: .get)
            request.start { (connection, result, error) in
                print("\(result)")
                
            }
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginKit.FBLoginButton) {
        print("logout")
    }
    
    
}




