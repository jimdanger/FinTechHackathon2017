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

    @IBOutlet weak var cardNumberLabel: UILabel!
    @IBOutlet weak var addCardButton: UIButton!

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
        cardNumberLabel.isHidden = false

        var cardDescription = cardInfo.description
        let index = cardDescription.index(cardDescription.startIndex, offsetBy: 1)
        cardNumberLabel.text = cardDescription.substring(from: index)  // to remove the opening " { "

        addCardButton.setTitle("Add another card", for: .normal)



        // upload the card to WorldPay
        Session.instance.cardNumber = cardInfo.cardNumber
        Session.instance.expirationDate = "\(cardInfo.expiryMonth)/\(cardInfo.expiryYear)"

        saveCardToWorldPayVault()

        // Alert Success of Vault Upload:
        let actionSheetController: UIAlertController = UIAlertController(title: "Card Added To Vault!  ; )", message: "You may now use Wink at accepting merchants.", preferredStyle: .alert)
        let cancelAction: UIAlertAction = UIAlertAction(title: "Okay", style: .cancel) { action -> Void in
            //Just dismiss the action sheet
        }
        actionSheetController.addAction(cancelAction)
        self.present(actionSheetController, animated: true, completion: nil)
        


    }

    // MARK:- WORLDPAY: 
    func saveCardToWorldPayVault(){
        print("saveCardToWorldPayValut")

        WorldPayManager.instance.saveCardAndGetToken()
     
    }





}


