//
//  ViewController.swift
//  FirebaseUI
//
//  Created by 旌榮 凌 on 2020/7/17.
//  Copyright © 2020 com.matthewProject. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import GoogleSignIn

class ViewController: UIViewController, GIDSignInDelegate{

    @IBOutlet weak var loginMessage: UILabel!
    @IBOutlet weak var GoogleSignInBtn: GIDSignInButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance()?.delegate = self
        GIDSignIn.sharedInstance()?.presentingViewController = self
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if error == nil{
//            if let userName = user.profile.name {
//                loginMessage.text = "Hello \(userName)"
//            }
            if let autentication = user.authentication{
                let credential = GoogleAuthProvider.credential(withIDToken: autentication.idToken, accessToken: autentication.accessToken)
                
                Auth.auth().signIn(with: credential, completion: { (firebaseuser, error) in if error == nil {
                    if let username = firebaseuser?.user.displayName{
                        self.loginMessage.text = "Hello Firebase User: \(username)"
                        self.GoogleSignInBtn.isEnabled = false
                        let alertView = UIAlertController.init(title: "登入成功", message: "歡迎: \(username)", preferredStyle: UIAlertController.Style.alert)
                        alertView.addAction(UIAlertAction.init(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                        self.present(alertView, animated: true, completion: nil)
                    }
                    
                }else{
                    print(error?.localizedDescription)
                    let alertView = UIAlertController.init(title: "登入失敗", message: "原因：\(error!.localizedDescription)", preferredStyle: UIAlertController.Style.alert)
                    alertView.addAction(UIAlertAction.init(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alertView,animated: true,completion: nil)
                    }
                    
                })
            }
            
        }else{
            print(error.localizedDescription)
        }
    }
    
    @IBAction func logout(_ sender: Any) {
        do{
            try Auth.auth().signOut()
            self.GoogleSignInBtn.isEnabled = true
            self.loginMessage.text = "請選擇登入方式"
        }catch{
            print(error.localizedDescription)
        }
    }


}

