//
//  Api.swift
//  Contacts App
//
//  Created by Anup Gupta on 01/09/19.
//  Copyright © 2019 geekguns. All rights reserved.
//

import Foundation
import Alamofire


class apiCall {
    
    
    
//    func updateContact2(peopleContactDetails : ContactList , userDict : [String : Any]) -> ContactList{
//
//        let id = peopleContactDetails.id
////        guard let id = peopleContactDetails.id else {
////            return;
////        }
//
//        let updateUrl = "\(updatePeopleDetailsURL)\(id).json"
//        let isFavorite: Bool?
//        if peopleContactDetails.favorite {
//            isFavorite = false
//        }
//        else{
//            isFavorite = true
//        }
//
////        let userDict : [String : Any] = ["first_name": peopleContactDetails?.first_name as Any,
////                                         "last_name":  peopleContactDetails?.last_name as Any,
////                                         "email": peopleContactDetails?.email as Any ,
////                                         "phone_number": peopleContactDetails?.phone_number as Any ,
////                                         "profile_pic": peopleContactDetails?.profile_pic ?? "",
////                                         "favorite": isFavorite as Any
////        ]
//
//        Alamofire.request(updateUrl , method: .put, parameters: userDict , encoding: JSONEncoding.default, headers: nil).responseJSON
//            {
//                (response:DataResponse<Any>) in
//                print("response",response)
//                print("re")
//
//                if (response.error != nil) {
//                    // failure(response.error);
//                }
//                else if (response.value != nil) {
//                    //success(response.value as! NSDictionary)
//
//                    print(response.value as Any)
//
//                    guard let data = response.data else { return }
//                    do {
//                        let decoder = JSONDecoder()
//                       peopleContactDetails = try decoder.decode(ContactList.self, from: data)
//                        // peopleContactDetails = contactDetails
//
//
//                        self.fillDetails()
//
//                        //                        self.contact.append(contentsOf: allContact)
//                        //
//                        //                        self.groupContactArray = self.getGroupArray(modelArray: self.contact)
//                        //                        self.contactListTable.reloadData()
//                        //   print("test",test)
//
//
//                    } catch let error {
//                        print(error)
//                    }
//
//                }
//
//
//        }
//    }
    
//    func addNewContact2() {
//        
//        
////        let userDict : [String : Any] = ["first_name": peopleContactDetails?.first_name as Any,
////                                         "last_name":  peopleContactDetails?.last_name as Any,
////                                         "email": peopleContactDetails?.email as Any ,
////                                         "phone_number": peopleContactDetails?.phone_number as Any ,
////                                         "profile_pic": peopleContactDetails?.profile_pic ?? "",
////                                         "favorite": true
////        ]
//        
//        Alamofire.request(baseUrl , method: .post, parameters: userDict , encoding: JSONEncoding.default, headers: nil).responseJSON
//            {
//                (response:DataResponse<Any>) in
//                print("response",response)
//                print("re")
//                if (response.error != nil) {
//                    // failure(response.error);
//                }
//                else if (response.value != nil) {
//                    //success(response.value as! NSDictionary)
//                    print(response.value as Any)
//                }
//        }
//    }
    
    
    
    func addNewContact(userDict : [String : Any] , success: @escaping (ContactList) -> () , failure: @escaping (Error?) -> () ) {
        
       
       
        
        Alamofire.request(baseUrl , method: .post, parameters: userDict , encoding: JSONEncoding.default, headers: nil).responseJSON
            {
                (response:DataResponse<Any>) in
                print("response",response)
                print("re")
                if (response.error != nil) {
                     failure(response.error);
                }
                else if (response.value != nil) {
                    
                    print(response.value as Any)
                    
                    
                    guard let data = response.data else { return }
                    do {
                        let decoder = JSONDecoder()
                        let peopleContactDetails = try decoder.decode(ContactList.self, from: data)
                        
                        success(peopleContactDetails )
                        
                        
                    } catch let error {
                        print(error)
                        
                        failure(error)
                    }
                }
        }
        
    }
    
    
    
    
    func updateContact( apiUrl : String , userDict : [String : Any] , success: @escaping (ContactList) -> () , failure: @escaping (Error?) -> () ) {
        
       // let updateUrl = "\(updatePeopleDetailsURL)\(userDict["id"] ?? "").json"
//        var isFavorite : Bool = userDict["favorite"] as! Bool
//        if  isFavorite {
//            isFavorite = false
//        }
//        else{
//            isFavorite = true
//        }
        
        Alamofire.request(apiUrl , method: .put, parameters: userDict , encoding: JSONEncoding.default, headers: nil).responseJSON
            {
                (response:DataResponse<Any>) in
                print("response",response)
                print("re")
                
                if (response.error != nil) {
                    
                     failure(response.error)
                }
                else if (response.value != nil) {
                   
                    
                    print(response.value as Any)
                    
                    guard let data = response.data else { return }
                    do {
                        let decoder = JSONDecoder()
                     let peopleContactDetails = try decoder.decode(ContactList.self, from: data)
                        
                        success(peopleContactDetails )

                        
                    } catch let error {
                        print(error)
                        
                        failure(error)
                    }
                    
                }
                
                
        }
    }
    
}
