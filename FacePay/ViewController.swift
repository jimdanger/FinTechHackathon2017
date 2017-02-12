//
//  ViewController.swift
//  FacePay
//
//  Created by James Wilson on 2/11/17.
//  Copyright © 2017 jimdanger. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuthUI
import FBSDKCoreKit
import FBSDKLoginKit
import FirebaseFacebookAuthUI
import RxSwift

class ViewController: UIViewController {

    let objcCode = CustomObject() 

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print("viewDidLoad")
        
        CardIOUtilities.preload()

        WorldPayManager.instance.saveCardAndGetToken()




    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    // MARK: - Buttons
    @IBAction func testSaveToDataBaseButtonPressed(_ sender: Any) {
        print("testSaveToDataBaseButtonPressed")
        objcCode.someMethod() // turns out I'm not using this anymore, but if we need to use objective C code, we can throw it in here and call it from a swift file.

        FireBaseObjectSaver.instance.saveCurrentUserToDataBase()

    }

    @IBAction func loginWithFBButtonPressed(_ sender: Any) {
        print("loginWithFBButtonPressed")
        loginWithFacebook()
    }


    // MARK: - Login Methods
    func loginWithFacebook() {
        let loginManager = FBSDKLoginManager()

        let permissions: [String] = ["email", "public_profile", "user_friends" /*, "user_photos"*/] // user_photos requires review from FB

        loginManager.logIn(withReadPermissions: permissions, from: self, handler: { (result, error) in

            if let error = error {
                print(error)
            } else if result!.isCancelled {
                print("FBLogin cancelled")
            } else {
                // success:
                print("FBLogin success")

                let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)

                self.loginToFireBase(credential: credential)
            }
        })
    }


    func loginToFireBase(credential: FIRAuthCredential) {
        FIRAuth.auth()?.signIn(with: credential) { (user, error) in

            if let error = error {
                print("error: \(error)")
                return
            } else {
                print("user: \(user)")
                Session.instance.user = user


                self.performSegue(withIdentifier: "next", sender: self)

            }
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // do nothing 
    }

}
