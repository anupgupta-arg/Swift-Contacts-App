//
//  EditContactDeatilsVC.swift
//  Contacts App
//
//  Created by Anup Gupta on 31/08/19.
//  Copyright © 2019 geekguns. All rights reserved.
//

import UIKit
import Alamofire

class EditContactDeatilsVC: UIViewController {
    
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var mobileNumberTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    var peopleContactUpdated : PeopleDetails?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fillData()
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped))
        
        navigationItem.rightBarButtonItem = done
    }
    
    
    
    @IBAction func cameraButtonAction(_ sender: Any) {
    }
}

extension EditContactDeatilsVC {
    
    func fillData() {
        
        avatar.sd_setImage(with: URL(string: peopleContactUpdated?.profile_pic ?? "" ), placeholderImage:UIImage(named: "contactPlaceHolder") )
        firstNameTextField.text = peopleContactUpdated?.first_name ?? ""
        lastNameTextField.text = peopleContactUpdated?.last_name ?? ""
        mobileNumberTextField.text = peopleContactUpdated?.phone_number
        emailTextField.text = peopleContactUpdated?.email
        
        
    }
    @objc func doneButtonTapped() {
        
        if peopleContactUpdated == nil {
            addNewContact();
        }
        else{
            updateContact();
        }
        
        
    }
 
    func updateContact(){
        
        let updateUrl = "\(updatePeopleDetailsURL)\(peopleContactUpdated?.id ?? nil).json"
        
        let userDict : [String : Any] = ["first_name": firstNameTextField.text ?? "",
                                         "last_name": lastNameTextField.text ?? "",
                                         "email": emailTextField.text ?? "",
                                         "phone_number": mobileNumberTextField.text ?? "",
                                         "profile_pic": peopleContactUpdated?.profile_pic ?? "",
                                         "favorite": peopleContactUpdated?.favorite ?? "",
                                         //                                       "created_at": "2016-05-29T10:10:10.995Z",
            //                                       "updated_at": "2016-05-29T10:10:10.995Z"
        ]
        
        Alamofire.request(updateUrl , method: .put, parameters: userDict , encoding: JSONEncoding.default, headers: nil).responseJSON
            {
                (response:DataResponse<Any>) in
                print("response",response)
                print("re")
                if (response.error != nil) {
                    // failure(response.error);
                }
                else if (response.value != nil) {
                    //success(response.value as! NSDictionary)
                    print(response.value)
                }
                
                
        }
    }
    
    func addNewContact() {
        
        
      //  let updateUrl = "\(updatePeopleDetailsURL)\(peopleContactUpdated?.id ?? nil).json"
        
        let userDict : [String : Any] = ["first_name": firstNameTextField.text ?? "",
                                         "last_name": lastNameTextField.text ?? "",
                                         "email": emailTextField.text ?? "",
                                         "phone_number": mobileNumberTextField.text ?? "",
                                         "profile_pic": peopleContactUpdated?.profile_pic ?? "",
                                         "favorite": peopleContactUpdated?.favorite ?? "",
                                         //                                       "created_at": "2016-05-29T10:10:10.995Z",
            //                                       "updated_at": "2016-05-29T10:10:10.995Z"
        ]
        
        Alamofire.request(baseUrl , method: .post, parameters: userDict , encoding: JSONEncoding.default, headers: nil).responseJSON
            {
                (response:DataResponse<Any>) in
                print("response",response)
                print("re")
                if (response.error != nil) {
                    // failure(response.error);
                }
                else if (response.value != nil) {
                    //success(response.value as! NSDictionary)
                    print(response.value as Any)
                }
        }
    }
    
}


