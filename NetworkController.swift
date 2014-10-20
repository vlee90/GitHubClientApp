//
//  NetworkController.swift
//  GitHubClientApp
//
//  Created by Vincent Lee on 10/20/14.
//  Copyright (c) 2014 VincentLee. All rights reserved.
//

import Foundation

class NetworkController {
    var url = NSURL(string: "http://localhost:3000/")
    var configuration = NSURLSessionConfiguration.ephemeralSessionConfiguration()
    var urlSession: NSURLSession?
    
    init() {
        
    }
    func setup() {
        self.urlSession = NSURLSession(configuration: self.configuration)
        var request = NSMutableURLRequest(URL: self.url)
        request.HTTPMethod = "GET"
        let dataTask = self.urlSession!.dataTaskWithRequest(request, completionHandler: { (data, httpResponse, error) -> Void in
            if let response = httpResponse as? NSHTTPURLResponse {
                switch response.statusCode {
                case 200...299:
                    for header in response.allHeaderFields {
                        println(header)
                    }
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
}