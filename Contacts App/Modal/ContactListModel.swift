//
//  ContactListModel.swift
//  Contacts App
//
//  Created by Anup Gupta on 31/08/19.
//  Copyright © 2019 geekguns. All rights reserved.
//

import Foundation

struct ContactList : Codable{
    
    let id: Int
    let first_name: String
    let last_name: String
    let profile_pic: String
    let favorite: Bool
    let url: String?
    let email: String?
    let phone_number: String?
    
    //    let id : Int?
    //    let firstName : String?
    //    let lastName : String?
    //    let profilePicURL : String?
    //    let favorite : Bool?
    //    let contactURL : String?
    //
    //    private enum CodingKeys: String, CodingKey {
    //        case id = "id"
    //        case firstName = "first_name"
    //        case lastName = "last_name"
    //        case profilePicURL = "profile_pic"
    //        case favorite = "favorite"
    //        case contactURL = "url"
    //
    //    }
    //    "id": 10140,
    //    "first_name": "aaaaakam",
    //    "last_name": "dfsdsdfs",
    //    "profile_pic": "/images/missing.png",
    //    "favorite": true,
    //    "url": "http://gojek-contacts-app.herokuapp.com/contacts/10140.json"
}



//
//struct PeopleDetails : Codable{
//
//    let id: Int
//    let first_name: String
//    let last_name: String
//    let email: String
//    let phone_number: String
//    let profile_pic: String
//    let favorite: Bool
//    
//    
////    "id": 1,
////    "first_name": "Amitabh",
////    "last_name": "Bachchan",
////    "email": "ab@bachchan.com",
////    "phone_number": "+919980123412",
////    "profile_pic": "https://contacts-app.s3-ap-southeast-1.amazonaws.com/contacts/profile_pics/000/000/007/original/ab.jpg?1464516610",
////    "favorite": false,
////    "created_at": "2016-05-29T10:10:10.995Z",
////    "updated_at": "2016-05-29T10:10:10.995Z"
////
//}
