//
//  MenuVC.swift
//  FacePay
//
//  Created by James Wilson on 2/12/17.
//  Copyright © 2017 jimdanger. All rights reserved.
//

import UIKit

class MenuVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        print("MenuVC viewDidLoad")
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.


    }


    // MARK:- Buttons
    @IBAction func WalletPressed(_ sender: Any) {
        print("WalletPressed")

        performSegue(withIdentifier: "card", sender: nil)

    }

    @IBAction func photosPressed(_ sender: Any) {
        print("photosPressed")
        performSegue(withIdentifier: "photo", sender: nil)

    }

    @IBAction func transactionsPressed(_ sender: Any) {
        print("transactionsPressed")
        performSegue(withIdentifier: "transactions", sender: nil)

    }




}
