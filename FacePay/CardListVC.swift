//
//  CardListVC.swift
//  FacePay
//
//  Created by James Wilson on 2/11/17.
//  Copyright © 2017 jimdanger. All rights reserved.
//

import UIKit
import Alamofire

class CardListVC: UIViewController, CardIOPaymentViewControllerDelegate {

    var cardIOVC: CardIOPaymentViewController?
    var cardInfos: [CardIOCreditCardInfo]?

    override func viewDidLoad() {
        super.viewDidLoad()
         cardIOVC = CardIOPaymentViewController(paymentDelegate: self)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func addFirstCardButton(_ sender: Any) {
        print("addFirstCardButton")
        addCard()
    }

    func addCard() {
//        let cardIOVC = CardIOPaymentViewController(paymentDelegate: self)
        cardIOVC?.modalPresentationStyle = .formSheet
        present(cardIOVC!, animated: true, completion: nil)
    }
    
    func userDidCancel(_ paymentViewController: CardIOPaymentViewController!) {
        paymentViewController.dismiss(animated: true, completion: nil)
    }

    func userDidProvide(_ cardInfo: CardIOCreditCardInfo!, in paymentViewController: CardIOPaymentViewController!) {
        print(cardInfo)
        cardIOVC?.dismiss(animated: true, completion: nil)

        // add card to the VC in this array:
        cardInfos?.append(cardInfo)

        // upload the card to WorldPay
        saveCardToWorldPayVault()

    }

    // MARK:- WORLDPAY: 
    func saveCardToWorldPayVault(){
        print("saveCardToWorldPayValut")

     
    }





}


