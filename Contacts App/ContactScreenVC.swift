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
import Contacts
class ContactScreenVC: UIViewController {
    @IBOutlet weak var contactListTable: UITableView!
    
    var contact = [ContactList]()
    var people = [PeopleDetails]()
    let contactStore = CNContactStore()
    var arrpic = NSMutableArray()
    var arrfname = NSMutableArray()
    var arrlname = NSMutableArray()
    var arrnumber = NSMutableArray()
    var arrEmail = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contactListTable.register(UINib(nibName:"ContactCell",bundle: nil), forCellReuseIdentifier: "ContactCellID")
        
        contactListTable.tableFooterView = UIView();
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        getContactListFromContactList();
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
//                self.contact = allContact
                self.contact.append(contentsOf: allContact)
                self.contactListTable.reloadData()
               
            } catch let error {
                print(error)
            }
        }
    }
    
    
}

extension ContactScreenVC {
    
    
    func getContactListFromContactList()  {
        
//        var contacts = [CNContact]()
//       // let fullname = [CNContactFormatter.descriptorForRequiredKeys(for: .fullName)]
//         //let keys = [CNContactFormatter.descriptorForRequiredKeys(for: .phoneticFullName)]
//
//        let keys = [
//            CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
//            CNContactPhoneNumbersKey,
//            CNContactEmailAddressesKey,
//            ] as [Any]
//        let request = CNContactFetchRequest(keysToFetch: keys as! [CNKeyDescriptor])
//
//        do {
//            try self.contactStore.enumerateContacts(with: request) {
//                (contact, stop) in
//                // Array containing all unified contacts from everywhere
//                contacts.append(contact)
//                print("contacts from phone",contacts)
//            }
//        }
//        catch {
//            print("unable to fetch contacts")
//        }
        
        
        
        fetchContacts(completion: {contacts in
            contacts.forEach({
                print("Name: \($0.givenName), number: \($0.phoneNumbers.first?.value.stringValue ?? "nil")")
                print("Email: \($0.emailAddresses.first?.value ?? "nil")")
                
                let fname = $0.givenName
                let lname = $0.familyName
                let mobile = $0.phoneNumbers.first?.value.stringValue ?? ""
                let email = $0.emailAddresses.first?.value ?? ""
                
                
                
                
                let tempPeople = PeopleDetails(id: 0, first_name: fname, last_name: lname, email: email as String, phone_number: mobile, profile_pic: "", favorite: false)
               let tempContact = ContactList(id: 0, first_name: fname, last_name: lname, profile_pic: "", favorite: false, url: "")
                
                self.contact.append(tempContact)
                self.people.append(tempPeople)
                self.arrfname.add("\($0.givenName)")
                self.arrlname.add("\($0.familyName)")
                self.arrnumber.add("\($0.phoneNumbers.first?.value.stringValue ?? "nil")")
                self.arrEmail.add("\($0.emailAddresses.first?.value ?? "nil")")
                
                var img = UIImage()
                if $0.thumbnailImageData != nil
                {
                    img = UIImage.init(data: $0.thumbnailImageData!)!
                    self.arrpic.add(img)
                }
                else
                {
                    self.arrpic.add("")
                }
            })
            if contacts.count > 0
            {
               
                self.contactListTable.reloadData()
                
            }
        })
        
        
    }
    
    //MARK:- Fetch All Contacts of Phone
    func fetchContacts(completion: @escaping (_ result: [CNContact]) -> Void){
        DispatchQueue.main.async {
            var results = [CNContact]()
            let keys = [CNContactGivenNameKey,CNContactFamilyNameKey,CNContactMiddleNameKey,CNContactEmailAddressesKey,CNContactPhoneNumbersKey,CNContactThumbnailImageDataKey] as [CNKeyDescriptor]
            let fetchRequest = CNContactFetchRequest(keysToFetch: keys)
            fetchRequest.sortOrder = .userDefault
            let store = CNContactStore()
            store.requestAccess(for: .contacts, completionHandler: {(grant,error) in
                if grant{
                    do {
                        try store.enumerateContacts(with: fetchRequest, usingBlock: { (contact, stop) -> Void in
                            results.append(contact)
                        })
                    }
                    catch let error {
                        print(error.localizedDescription)
                    }
                    completion(results)
                }else{
                    print("Error \(error?.localizedDescription ?? "")")
                }
            })
        }
    }
    
}
