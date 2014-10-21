//
//  NetworkController.swift
//  GitHubClientApp
//
//  Created by Vincent Lee on 10/20/14.
//  Copyright (c) 2014 VincentLee. All rights reserved.
//

import Foundation
import UIKit

class NetworkController {
    var url = NSURL(string: "http://localhost:3000/")
    var configuration = NSURLSessionConfiguration.ephemeralSessionConfiguration()
    var urlSession: NSURLSession?
    var queue: NSOperationQueue?
    
    init() {
        
    }
    func requestData(completionFunction: (error: String?, data: NSDictionary) -> Void) {
        self.urlSession = NSURLSession(configuration: self.configuration)
        var request = NSMutableURLRequest(URL: self.url)
        request.HTTPMethod = "GET"
        let dataTask = self.urlSession!.dataTaskWithRequest(request, completionHandler: { (data, httpResponse, error) -> Void in
            if let response = httpResponse as? NSHTTPURLResponse {
                switch response.statusCode {
                case 200...299:
//                    for header in response.allHeaderFields {
                        var parsedDictionary = self.parseJSON((data))
                        if parsedDictionary != nil {
                            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                                completionFunction(error: nil, data: parsedDictionary!)
                            })
                        }
//                    }
                case 400:
                    println("400: Bad Request - Syntax error likely")
                case 401:
                    println("401: Unauthorized - Authorization either not provided or incorrect")
                case 403:
                    println("403: Forbidden - Request valid, but server will not respond")
                case 404:
                    println("404: Not Found - Resource not found")
                case 429:
                    println("429: Too many requests - Rate limted")
                case 500...599:
                    println("\(response.statusCode): Server failed")
                default:
                    println("\(response.statusCode): Error")
                }
            }
            else {
                println("Error occured")
            }
        })
        dataTask.resume()
    }
    
    func parseJSON(JSONData: NSData) -> NSDictionary? {
        var error: NSError?
        if let dictionary = NSJSONSerialization.JSONObjectWithData(JSONData, options: nil, error: &error) as? NSDictionary {
            return dictionary
        }
        else {
            return nil
        }
    }
    
    func createUIImage(url: NSURL, completionHanlder: (dataToPass: NSData?) -> Void) -> Void{
        self.queue = NSOperationQueue()
        self.queue?.addOperationWithBlock({ () -> Void in
            let data = NSData(contentsOfURL: url)
            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                completionHanlder(dataToPass: data)
            })
        })
    }
}