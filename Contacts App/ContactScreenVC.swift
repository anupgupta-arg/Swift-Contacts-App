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
    //var people = [PeopleDetails]()
    var groupContactArray = [[ContactList]]()
    
    let contactStore = CNContactStore()
    var arrpic = NSMutableArray()
   
    
     var arrayIndexSection = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contactListTable.register(UINib(nibName:"ContactCell",bundle: nil), forCellReuseIdentifier: "ContactCellID")
        
        contactListTable.tableFooterView = UIView();
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        groupContactArray.removeAll();
        contact.removeAll();
        getContactListFromContactList();
        getContactListFromBackend();
    }
    
    @IBAction func addPeopleBarButtonAction(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc : EditContactDeatilsVC = storyBoard.instantiateViewController(withIdentifier: "EditContactDeatilsVCID") as! EditContactDeatilsVC
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
}

extension ContactScreenVC : UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
       return groupContactArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 57
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  groupContactArray[section].count //contact.count; //
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : ContactCell = contactListTable.dequeueReusableCell(withIdentifier: "ContactCellID") as! ContactCell
        let personDetails = groupContactArray[indexPath.section][indexPath.row] //contact[indexPath.row]; //
        cell.contactName.text = "\(personDetails.first_name ) \(personDetails.last_name )";
        let imgurl = personDetails.profile_pic;
        if personDetails.favorite {
             cell.favImage.image = UIImage.init(named: "fevStarGreen")
        }
            else{
             cell.favImage.isHidden = true
        }
        
        
        
        cell.avatar.sd_setImage(with: URL(string: imgurl as String ), placeholderImage:UIImage(named: "contactPlaceHolder") )
        return cell;
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc : ContactDetailsScreenVC = storyBoard.instantiateViewController(withIdentifier: "ContactDetailsScreenVCID") as! ContactDetailsScreenVC
        let personDetails = groupContactArray[indexPath.section][indexPath.row]

        
         vc.peopleContactDetails = personDetails;
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "\(groupContactArray[section].first?.first_name.prefix(1).uppercased() ?? "")"
    }

    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return arrayIndexSection
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
                
               self.groupContactArray = self.getGroupArray(modelArray: self.contact)
                self.contactListTable.reloadData()
          //   print("test",test)
                
                
            } catch let error {
                print(error)
            }
        }
    }
    
    
}

extension ContactScreenVC {
    
    
    func getContactListFromContactList()  {
        
        
        
        fetchContacts(completion: {contacts in
            contacts.forEach({
                print("Name: \($0.givenName), number: \($0.phoneNumbers.first?.value.stringValue ?? "nil")")
                print("Email: \($0.emailAddresses.first?.value ?? "nil")")
                
                let fname = $0.givenName
                let lname = $0.familyName
                let mobile = $0.phoneNumbers.first?.value.stringValue ?? ""
                let email = $0.emailAddresses.first?.value ?? ""
                
               // let tempPeople = PeopleDetails(id: 0, first_name: fname, last_name: lname, email: email as String, phone_number: mobile, profile_pic: "", favorite: false)
                let tempContact = ContactList(id: 0, first_name: fname, last_name: lname, profile_pic: "", favorite: false, url: "",email: email as String ,phone_number: mobile)
                
                self.contact.append(tempContact)
                //self.people.append(tempPeople)
               
                
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

extension ContactScreenVC {
    
    func getGroupArray(modelArray:[ContactList])->[[ContactList]]{
        self.contact = modelArray.sorted(by: { $0.first_name.uppercased() < $1.first_name.uppercased() })
        let groupContactArray = self.contact.reduce([[ContactList]]()) {
            guard var last = $0.last else { return [[$1]] }
            var collection = $0
            if last.first!.first_name.prefix(1).uppercased() == $1.first_name.prefix(1).uppercased() {
                last += [$1]
                collection[collection.count - 1] = last
            } else {
                 self.arrayIndexSection.append(String([$1].first?.first_name.prefix(1).uppercased() ?? ""))
                collection += [[$1]]
            }
            return collection
        }
        
        return groupContactArray
    }
}
