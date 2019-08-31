//
//  AlamofireConnectionMangager.swift
//  Contacts App
//
//  Created by Anup Gupta on 31/08/19.
//  Copyright © 2019 geekguns. All rights reserved.
//

import Foundation
import Alamofire

class AlamofireConnectionMangager {
    
    private static var _instance: AlamofireConnectionMangager?;
    
    private init() {
        
    }
    
    public static func getSingleton() -> AlamofireConnectionMangager {
        if (AlamofireConnectionMangager._instance == nil) {
            AlamofireConnectionMangager._instance = AlamofireConnectionMangager.init();
        }
        return AlamofireConnectionMangager._instance!;
    }
    
    func getDataFromServer( url: String , param : NSDictionary, success: @escaping (NSDictionary) -> () , failure: @escaping (Error?) -> () ) {
        
        
        Alamofire.request(url , method: .get, parameters: param as? [String: Any] , encoding: URLEncoding.default, headers: nil).responseJSON
            {
                (response:DataResponse<Any>) in
                
                //                print("response.request :", response.request as Any)
                //                print("response.response :", response.response as Any)
                //                print("response.result:", response.result as Any)
                //                print("response.value: ", response.value as Any)
                //                print("response.error:", response.error as Any)
                
                //                let StatusCode = response.response?.statusCode
                
                if (response.error != nil) {
                    failure(response.error);
                }
                else if (response.value != nil) {
                    success(response.value as! NSDictionary)
                }
                
                
        }
        
    }
    
    func postDataToServer( url: String , param : NSDictionary, success: @escaping (NSDictionary) -> () , failure: @escaping (Error?) -> () ) {
        
        Alamofire.request(url , method: .post, parameters: param as? [String: Any] , encoding: URLEncoding.default, headers: nil).responseJSON
            {
                (response:DataResponse<Any>) in
                //                print("response.request :", response.request as Any)
                //                print("response.response :", response.response as Any)
                //                print("response.result:", response.result as Any)
                //                print("response.value: ", response.value as Any)
                //                print("response.error:", response.error as Any)
                
                if (response.error != nil) {
                    failure(response.error);
                }
                else if (response.value != nil) {
                    success(response.value as! NSDictionary)
                }
                
                
        }
        
    }
    
    func downloadImagesFromServer(url: String , success: @escaping (Data) -> () , failure: @escaping (Error?) -> ()){
        
        // Use Alamofire to download the image
        Alamofire.request(url).responseData { (response) in
            if response.error == nil {
                print(response.result)
                
                // Show the downloaded image:
                if let data = response.data {
                    // self.downloadImage.image = UIImage(data: data)
                    success(data)
                    
                }
            }
            else{
                failure(response.error)
                
            }
        }
        
    }
    
    
    
}


// This is Use Description
/*
 AlamofireConnectionMangager.sharedInstance.getDataFromServer( url: urlSting , param : params as NSDictionary, success: {(responseResult) -> Void in
 
 print("responseResult :::",responseResult)
 print("Success")
 
 }, failure:{(error) -> Void in
 
 if error {
 print("Somting went wrong")
 }
 self.showAlert(alertMessage: "Somthing went wrong")
 
 }) */
