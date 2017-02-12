//
//  WorldPayManager.swift
//  FacePay
//
//  Created by James Wilson on 2/12/17.
//  Copyright © 2017 jimdanger. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift
import ObjectMapper
import AFNetworking
//import AlamofireObjectMapper


public class WorldPayManager {

    private static let backgroundQueue = DispatchQueue(label: "com.bluefletch.background-queue2", qos: .utility, attributes: [.concurrent])

    lazy var sessionManager: SessionManager = {
        let manager = Alamofire.SessionManager.default
        manager.adapter = DRRequestAdapter_worldPay()
        return manager
    }()

    open static var instance: WorldPayManager  = WorldPayManager()
    let worldPayPublicKey: String = "95064f1c-b0aa-4734-981f-5e5b81bc490e"

    func makeExampleRequest() {
        Alamofire.request("https://httpbin.org/get").responseJSON { response in
            print(response.request ??  "nil request ")  // original URL request
            print(response.response ??  "nil response") // HTTP URL response
            print(response.data ?? "no data")     // server data
            print(response.result)   // result of response serialization

            if let JSON = response.result.value {
                print("JSON: \(JSON)")
            }
        }
    }


    func makePostWithParameters() {

        let urlString: String =  "https://gwapi.demo.securenet.com/api/PreVault/Card"

        let parameters: Parameters = ["key": "value"]
        let _ = requestWithObservable(endpoint: urlString, method: .post, parameters: parameters).subscribe(onNext: { (thing) in
            print(thing ?? "")
        }, onError: { (e) in
            print(e)
        }, onCompleted: {
            print("onCompleted")
        }) {
            // do nothing
        }
    }


    public func requestWithObservable(endpoint: String, method: HTTPMethod, parameters: [String:Any]?) -> Observable<[String : Any]?> {

        let obs = Observable<[String: Any]?>.create { observer in

            guard let url: URL = URL(string: endpoint) else {
                print("Error: BaseApi cannot convert host string to URL")
                return Disposables.create() // TODO: is this the proper way to use return or break to exit scope so guard does not fail?
            }

            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = method.rawValue
            do {
                let request = try Alamofire.JSONEncoding.default.encode(urlRequest, with:parameters)
                self.sessionManager.request(request)
                    .validate()

                    .responseJSON(queue: WorldPayManager.backgroundQueue, options: .allowFragments, completionHandler: { (response) -> Void in
                        guard response.result.isSuccess else {
                            print("Error while fetching: \(response.result.error)")
                            //let e = ValidationError()
                            if let e = response.result.error {
                                observer.onError(e)
                            }
                            return
                        }

                        var dictionaryToReturn: [String: Any] = [:]

                        if let dictionary = response.result.value as? [String: Any] {
                            dictionaryToReturn = dictionary
                        }

                        observer.onNext(dictionaryToReturn)
                        observer.onCompleted()
                    })

            } catch {
                observer.onError(error)
            }

            return Disposables.create()
        }

        return obs.observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
    }


    // DONE and works:
    func saveCardAndGetToken() {

        let urlString: String = "https://gwapi.demo.securenet.com/api/PreVault/Card"
//        guard let cardNumber: String = Session.instance.cardNumber else {
//            return
//        }
//
//        guard let expirationDate: String = Session.instance.expirationDate else {
//            return
//        }
     //   print(expirationDate)
        
        let params: Parameters = [
                "publicKey": worldPayPublicKey,
                "card": [
                    "number": "4111 1111 1111 1111",
                    "expirationDate": "01/2017",
                    "address": [
                        "line1": "123 Main St.",
                        "city": "Austin",
                        "state": "TX",
                        "zip": "78759"
                    ]
                ],
                "developerApplication": [
                    "developerId": 12345678,
                    "version": "1.2"
                ]
        ]


        var request = URLRequest(url: URL(string: urlString)!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Basic ODAwNjkxMjpjUXhiaksyYkNEZnA=", forHTTPHeaderField: "Authorization")
        request.httpBody = try! JSONSerialization.data(withJSONObject: params, options: [])

        URLSession.shared.dataTask(with:request, completionHandler: {(data, response, error) in
            if error != nil {
                print(error)
            } else {
                do {
                    guard let json = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: Any] else {
                            return
                    }

                    guard let errors = json?["errors"] as? [[String: Any]] else {
                        return
                    }
                    if errors.count > 0 {
                        // show error
                        return
                    } else {
                        // show confirmation

                        // save the token to the session.
                        if let dict: Dictionary = json {
                            Session.instance.worldPaytoken = dict["token"] as? String
                        }

                        // create a user in our database with the token:
                        RestApiManager.instance.microsoftCreatePerson()

                    }
                }
            }
        }).resume()


    }
}


private struct DRRequestAdapter_worldPay: RequestAdapter {
    func adapt(_ urlRequest: URLRequest) throws -> URLRequest {

        var request = urlRequest
        let headerValue: String = "Basic ODAwNjkxMjpjUXhiaksyYkNEZnA="
        request.addValue(headerValue, forHTTPHeaderField: "Authorization")

        debugPrint(request)
        debugPrint(request.allHTTPHeaderFields.debugDescription)
        return request
    }
}
