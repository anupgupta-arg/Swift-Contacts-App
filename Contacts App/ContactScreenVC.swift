//
//  ContactScreenVC.swift
//  Contacts App
//
//  Created by Anup Gupta on 31/08/19.
//  Copyright © 2019 geekguns. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage

class ContactScreenVC: UIViewController {
    @IBOutlet weak var contactListTable: UITableView!
    
    var contact = [ContactList]()
    override func viewDidLoad() {
        super.viewDidLoad()
        contactListTable.register(UINib(nibName:"ContactCell",bundle: nil), forCellReuseIdentifier: "ContactCellID")
        
        contactListTable.tableFooterView = UIView();
        getContactListFromBackend();
    }
    


}

extension ContactScreenVC : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contact.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : ContactCell = contactListTable.dequeueReusableCell(withIdentifier: "ContactCellID") as! ContactCell
        let personDetails = contact[indexPath.row];
        cell.contactName.text = "\(personDetails.first_name ) \(personDetails.last_name )";
        let imgurl = personDetails.profile_pic;
       
        cell.avatar.sd_setImage(with: URL(string: imgurl as String ), placeholderImage:UIImage(named: "contactPlaceHolder") )
        return cell;
        
    }
    
    
}

extension ContactScreenVC {
    
    func getContactListFromBackend() {
        Alamofire.request(baseUrl).response { response in
            guard let data = response.data else { return }
            do {
                let decoder = JSONDecoder()
                let tweetRequest = try decoder.decode([ContactList].self, from: data)
                print(tweetRequest)
                self.contact = tweetRequest
                self.contactListTable.reloadData()
               // completion(tweetRequest)
            } catch let error {
                print(error)
               // completion(nil)
            }
        }
    }
    
    
}


struct ContactList : Codable{
    
    let id: Int
    let first_name: String
    let last_name: String
    let profile_pic: String
    let favorite: Bool
    let url: String
    
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
