//
//  Session.swift
//  FacePay
//
//  Created by James Wilson on 2/11/17.
//  Copyright © 2017 jimdanger. All rights reserved.
//

import Foundation
import Firebase

public class Session {

    /// I'm just putting all kinds of info in this global singelton. Probbaly bad practice but hackathon so whatever.

    open static var instance: Session  = Session()
    
    var user: FIRUser? // Firebase user
    var personIdFromMicrosoft: String?


    
}
