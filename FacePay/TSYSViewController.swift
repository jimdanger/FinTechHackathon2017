//
//  TSYSViewController.swift
//  FacePay
//
//  Created by James Wilson on 2/12/17.
//  Copyright © 2017 jimdanger. All rights reserved.
//

import UIKit

class TSYSViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {

    @IBOutlet weak var tableView: UITableView!


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        print("TSYSViewController viewDidLoad")
        tableView.delegate = self
        tableView.dataSource = self

        getTSYSData()

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

    // MARK: - UITableViewDelegate Methods

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{

        let cell = tableView.dequeueReusableCell(withIdentifier: "TSYSCell", for: indexPath) as! TSYSCell

        //cell.nameLabel.text = categories[indexPath.row].name


        return cell
    }


    // MARK: - APIs
    func getTSYSData() {

        
    }



}
