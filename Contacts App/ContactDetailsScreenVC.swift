//
//  ContactDetailsScreenVC.swift
//  Contacts App
//
//  Created by Anup Gupta on 31/08/19.
//  Copyright © 2019 geekguns. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage
class ContactDetailsScreenVC: UIViewController {
    
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var contactName: UILabel!
    @IBOutlet weak var mobileNumberLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    var peopleContactDeatils : ContactList?
    var peopleContactUpdated : PeopleDetails?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fillDetails()
        fetchPeopleCompleteDeatils()
//        avatar.layer.cornerRadius = 50

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        let edit = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editButtonTapped))
       
        navigationItem.rightBarButtonItem = edit
    }
    
    @IBAction func messageButtonAction(_ sender: Any) {
    }
    @IBAction func callButtonAction(_ sender: Any) {
    }
    @IBAction func emailButtonAction(_ sender: Any) {
    }
    @IBAction func favButtonAction(_ sender: Any) {
    }
    
    @objc func editButtonTapped()  {
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc : EditContactDeatilsVC = storyBoard.instantiateViewController(withIdentifier: "EditContactDeatilsVCID") as! EditContactDeatilsVC
        vc.peopleContactUpdated = peopleContactUpdated;
//        navigationController?.present(vc, animated: true, completion: nil)
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
extension ContactDetailsScreenVC {
    
    func fetchPeopleCompleteDeatils() {
        let peopleurl : String = peopleContactDeatils?.url ?? "";
        guard peopleurl != "" else {
            return
        }
        Alamofire.request(peopleurl).response { response in
            guard let data = response.data else { return }
            do {
                let decoder = JSONDecoder()
                self.peopleContactUpdated = try decoder.decode(PeopleDetails.self, from: data)
                self.updateDetails();
            } catch let error {
                print(error)
            }
        }
    }
    
}
extension ContactDetailsScreenVC {
    
    func fillDetails()  {
        
        avatar.sd_setImage(with: URL(string: peopleContactDeatils?.profile_pic ?? "" ), placeholderImage:UIImage(named: "contactPlaceHolder") )
        contactName.text = "\(peopleContactDeatils?.first_name ?? "" ) \(peopleContactDeatils?.last_name ?? "")"
        mobileNumberLabel.text = ""
        emailLabel.text = ""
    }
    
    
    func updateDetails()  {
        
        avatar.sd_setImage(with: URL(string: peopleContactUpdated?.profile_pic ?? "" ), placeholderImage:UIImage(named: "contactPlaceHolder") )
        contactName.text = "\(peopleContactUpdated?.first_name ?? "" ) \(peopleContactUpdated?.last_name ?? "")"
        mobileNumberLabel.text = peopleContactUpdated?.phone_number
        emailLabel.text = peopleContactUpdated?.email
    }
    
    
}
