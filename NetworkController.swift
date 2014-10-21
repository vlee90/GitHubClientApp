//
//  NetworkController.swift
//  GitHubClientApp
//
//  Created by Vincent Lee on 10/20/14.
//  Copyright (c) 2014 VincentLee. All rights reserved.
//

import Foundation
import UIKit
import Accounts

class NetworkController {
    var url = NSURL(string: "http://localhost:3000/")
    var configuration = NSURLSessionConfiguration.ephemeralSessionConfiguration()
    var queue: NSOperationQueue?
    var session = NSURLSession()
    
    
    let clientID = "client_id=daa6e5fc857f9896c7c2"
    let clientSecret = "client_secret=d700c36a39198dec0bd34bcea2e321418e95b176"
    let redirectURL = "redirect_uri=appScheme://githubclient"
    let scope =  "scope=user,repo"
    let githubOAuthGET = "https://github.com/login/oauth/authorize"
    let githubOAuthPOST = "https://github.com/login/oauth/access_token"
    var authorizationToken: String?
    
    init() {
        
    }
    
    func requestOAuthAcessGET() {
        let urlGET = self.githubOAuthGET + "?" + self.clientID + "&" + self.redirectURL + "&" + self.scope
        //https://github.com/login/oauth/authorize?daa6e5fc857f9896c7c2&redirect_uri=appScheme://githubclient&scope=user,repo
        //Calls this delegate function
        // -------- GET ---------
        UIApplication.sharedApplication().openURL(NSURL(string: urlGET)!)
    }
    
    func handleCallbackURL(callbackURL: NSURL) {
        //  Query are the terms after the ? in the URL. Ex: appscheme://githubclient?code=df0568e71a01613060a0 . code=...is the query.
        let query = callbackURL.query
        let components = query?.componentsSeparatedByString("code=")
        let code = components?.last
        //  Grabs the Request Token in code.
        //  ------ POST -------
        //  Create query string for the POST call to get the authorization token.
        let urlQueryPOST = self.clientID + "&" + self.clientSecret + "&" + "code=\(code!)"
        //  Make POST request for Authorization Token
        var request = NSMutableURLRequest(URL: NSURL(string: self.githubOAuthPOST)!)
        //  Create data to post in the HTTP body
        var postData = urlQueryPOST.dataUsingEncoding(NSASCIIStringEncoding, allowLossyConversion: true)
        let length = postData!.length
        //  Set request parameters
        request.HTTPMethod = "POST"
        request.setValue("\(length)", forHTTPHeaderField: "Content-Length")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = postData
        //  Send POST Request
        let dataTask = NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
            if error != nil {
                println(error.description)
            }
            else {
                if let httpResponse = response as? NSHTTPURLResponse {
                    switch httpResponse.statusCode {
                    case 200...299:
                        var token = NSString(data: data, encoding: NSASCIIStringEncoding)
                        let components = token?.componentsSeparatedByString("access_token=")
                        self.authorizationToken = components!.last as? String
                        println("Authorization Token: \(self.authorizationToken!)")
                        //  Setup configurations for session. As long as session is given the token (either from UserDefault or call), our calls will always be authenticated within scope.
                        var configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
                        configuration.HTTPAdditionalHeaders = ["Authorization" : "token \(self.authorizationToken!)"]
                        self.session = NSURLSession(configuration: configuration)
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
                        println("\(httpResponse.statusCode): Server failed")
                    default:
                        println("\(httpResponse.statusCode): Error")
                    }
                }
                else {
                    println("Error occured")
                }
            }
        })
        dataTask.resume()
    }
    
    func requestData(completionFunction: (error: String?, data: NSDictionary) -> Void) {
        var urlSession = self.session
        var request = NSMutableURLRequest(URL: self.url!)
        request.HTTPMethod = "GET"
        let dataTask = self.session.dataTaskWithRequest(request, completionHandler: { (data, httpResponse, error) -> Void in
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