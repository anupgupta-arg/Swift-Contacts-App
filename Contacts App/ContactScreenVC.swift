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
    
    @IBAction func addPeopleBarButtonAction(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc : EditContactDeatilsVC = storyBoard.instantiateViewController(withIdentifier: "EditContactDeatilsVCID") as! EditContactDeatilsVC
      //  vc.peopleContactUpdated = peopleContactUpdated;
        //        navigationController?.present(vc, animated: true, completion: nil)
        navigationController?.pushViewController(vc, animated: true)
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc : ContactDetailsScreenVC = storyBoard.instantiateViewController(withIdentifier: "ContactDetailsScreenVCID") as! ContactDetailsScreenVC
        vc.peopleContactDeatils = contact[indexPath.row];
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
}

extension ContactScreenVC {
    
    func getContactListFromBackend() {
        Alamofire.request(baseUrl).response { response in
            guard let data = response.data else { return }
            do {
                let decoder = JSONDecoder()
                let allContact = try decoder.decode([ContactList].self, from: data)
                self.contact = allContact
                self.contactListTable.reloadData()
               
            } catch let error {
                print(error)
            }
        }
    }
    
    
}
