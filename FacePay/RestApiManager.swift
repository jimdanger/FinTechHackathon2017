//
//  RestApiManager.swift
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


public class RestApiManager {

    private static let backgroundQueue = DispatchQueue(label: "com.bluefletch.background-queue", qos: .utility, attributes: [.concurrent])

    lazy var sessionManager: SessionManager = {
        let manager = Alamofire.SessionManager.default
        manager.adapter = DRRequestAdapter_Microsoft()
        return manager
    }()

    open static var instance: RestApiManager  = RestApiManager()
    let publicKey: String = "95064f1c-b0aa-4734-981f-5e5b81bc490e"

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

            // if we have an auth token, use it.
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = method.rawValue
            do {
                let request = try Alamofire.JSONEncoding.default.encode(urlRequest, with:parameters)
                self.sessionManager.request(request)
                    .validate()

                    .responseJSON(queue: RestApiManager.backgroundQueue, options: .allowFragments, completionHandler: { (response) -> Void in
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
    func microsoftCreatePerson() {


        let urlString: String = "https://westus.api.cognitive.microsoft.com/face/v1.0/persongroups/facepay/persons"
        let params: Parameters = [
            "name":"Nicole",
            "userData":"User-provided data attached to the person"
        ]
        
        let _ = requestWithObservable(endpoint: urlString, method: .post, parameters: params).subscribe(onNext: { (thing) in
            print(thing ?? "")
            if let dict: [String:Any] = thing {
                if let id = dict["personId"] as? String {
                    Session.instance.personIdFromMicrosoft = id
                }
            }
            
        }, onError: { (e) in
            print(e)
        }, onCompleted: {
            print("onCompleted")
        }) {
            // do nothing
        }
    }

    func microsoftAddAPersonFace() {

        // omitting from demo. 

    }
}


private struct DRRequestAdapter_Microsoft: RequestAdapter {
    func adapt(_ urlRequest: URLRequest) throws -> URLRequest {

        var request = urlRequest
//        let header1Value: String = "application/json"
        let header2Value: String = "e5bdbaf52816430bb3ff0ef29850855f"

//        request.addValue(header1Value, forHTTPHeaderField: "Content-Type")
        request.addValue(header2Value, forHTTPHeaderField: "Ocp-Apim-Subscription-Key")

        debugPrint(request)
        debugPrint(request.allHTTPHeaderFields.debugDescription)
        return request
    }
}
