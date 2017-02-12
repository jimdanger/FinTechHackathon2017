//
//  FireBaseObjectSaver.swift
//  FacePay
//
//  Created by James Wilson on 2/11/17.
//  Copyright © 2017 jimdanger. All rights reserved.
//

import Foundation
import Firebase


public class FireBaseObjectSaver {

    open static var instance: FireBaseObjectSaver  = FireBaseObjectSaver()
    let firebase_storage_bucket: String = "gs://fintackhack2017.appspot.com"

    // FireBase DataBase Keys:
    let kFireBaseUserUUID: String = "FireBaseUserUUID"
    let kUserEmail: String = "UserEmail"
    let kWorldPayVaultToken: String = "WorldPayVaultToken"
    let kUserDisplayName: String = "UserDisplayName"
    let kMicrosoftCognitionServicesID: String = "kMicrosoftCognitionServicesID"

    open func saveToStorage(){
        // This might have been the wrong method? This might be to save locally. Or maybe it is like AWS S3 - to store files, not database.

        /*
        let storage = FIRStorage.storage()
        let storageRef = storage.reference(forURL: firebase_storage_bucket)
        let imagesRef = storageRef.child("images")
        var spaceRef = storageRef.child("images/space.jpg")
        let storagePath = "\(firebase_storage_bucket)/images/space.jpg"
        spaceRef = storage.reference(forURL: storagePath)
        */
    }

    func saveCurrentUserToDataBase(){
        var ref: FIRDatabaseReference!
        ref = FIRDatabase.database().reference()

        guard let displayName = Session.instance.user?.displayName else {
            return
        }
        guard let uuId = Session.instance.user?.uid else {
            return
        }
        guard let email = Session.instance.user?.email else {
            return
        }


//        ref.child("users/\(uuId)/\(asdf)").setValue("askjfkljashdf")
    }


    /*
    open func savetoRemoteDatabase(object: Any){
        var ref: FIRDatabaseReference!
        ref = FIRDatabase.database().reference()

        let jsonObject: NSMutableDictionary = NSMutableDictionary()

        let displayName = Session.instance.user?.displayName
        let uuID = Session.instance.user?.uid
        let email = Session.instance.user?.email

        jsonObject.setValue(uuID, forKey: kFireBaseUserUUID)
        jsonObject.setValue(displayName, forKey: kUserDisplayName)
        jsonObject.setValue(email, forKey: kUserEmail)

        let jsonData: NSData

        do {
            jsonData = try JSONSerialization.data(withJSONObject: jsonObject, options: JSONSerialization.WritingOptions()) as NSData
            let jsonString = NSString(data: jsonData as Data, encoding: String.Encoding.utf8.rawValue) as! String
            print("json string = \(jsonString)")
        } catch _ {
            print ("JSON Failure")
        }

        let valid = JSONSerialization.isValidJSONObject(jsonObject) // true
        if valid {
            postJsonToFireBasejsonDat(jsonObject: jsonObject)
        }
    }


    func postJsonToFireBasejsonDat(jsonObject: NSMutableDictionary){
        var ref: FIRDatabaseReference!
        ref = FIRDatabase.database().reference()
    }
    */
}

