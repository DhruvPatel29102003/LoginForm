//
//  google.swift
//  Login
//
//  Created by Droadmin on 14/09/23.
//

import Foundation
import GoogleSignIn
import GoogleSignInSwift
import FirebaseCore
import FirebaseAuth
class GoogleLogin{
    
    static let googleLogin = GoogleLogin()
    
    private init(){}
    func googleSingin(presentingViewController: UIViewController){
        
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            return
            
        }
        
        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        // Start the sign in flow!
        GIDSignIn.sharedInstance.signIn(withPresenting: presentingViewController) { [unowned self] result, error in
            guard error == nil else {
                // ...
                print("Google Sign-In error: \(error?.localizedDescription ?? "")")
                return
            }
            
            guard let user = result?.user,
                  let idToken = user.idToken?.tokenString
                    
            else {
                
                print("Missing user or ID token")
                return
            }
            UserDefaults.standard.set(true, forKey: "login")
            if let navigationController = presentingViewController.navigationController {
                let thirdVc = presentingViewController.storyboard?.instantiateViewController(withIdentifier: "ThirdViewController") as! ThirdViewController
                navigationController.pushViewController(thirdVc, animated: false)
            }
            
        }
    }
}
