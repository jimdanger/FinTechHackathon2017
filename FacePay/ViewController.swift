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

class ViewController: UIViewController, CardIOPaymentViewControllerDelegate {

    let objcCode = CustomObject() 

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print("viewDidLoad")
        
        CardIOUtilities.preload()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func cardIOScanner(_ sender: Any) {
        let cardIOVC = CardIOPaymentViewController(paymentDelegate: self)
        cardIOVC?.modalPresentationStyle = .formSheet
        present(cardIOVC!, animated: true, completion: nil)
    }
    
    func userDidCancel(_ paymentViewController: CardIOPaymentViewController!) {
        paymentViewController.dismiss(animated: true, completion: nil)
    }
    
    func userDidProvide(_ cardInfo: CardIOCreditCardInfo!, in paymentViewController: CardIOPaymentViewController!) {

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

                let userDetailsRequest = FBSDKGraphRequest(graphPath: "me", parameters:["fields":"id,email,picture.width(200).height(200),name,first_name,last_name,gender,age_range,location,friends","return_ssl_resources":1] )

                //self.firebaseLogin(credential)
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


                // TODO: go to next view?? idk



            }
        }
    }

}
