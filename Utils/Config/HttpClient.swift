//
//  HttpClient.swift
//  WhipMe
//
//  Created by Song on 2016/9/29.
//  Copyright © 2016年 -. All rights reserved.
//

import UIKit
import Alamofire

private let baseURLString = ""
typealias CompletionHandler = (Any?, Error?) -> Swift.Void

class HttpClient: NSObject {
    static let sharedInstance = HttpClient()

    public func apiRequest(url: String, parameters: Parameters, method: HTTPMethod, completionHandler: @escaping CompletionHandler) -> Void {
        let requeseurl = baseURLString.appending(url)
        Alamofire.request(requeseurl, method: method, parameters: parameters)
            .responseJSON { response in
                completionHandler(response.result.value,response.result.error)
        }
    }
}
