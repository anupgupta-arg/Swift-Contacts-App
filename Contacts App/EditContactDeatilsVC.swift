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
    var peopleContactDetails : ContactList?
    
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
        
        avatar.sd_setImage(with: URL(string: peopleContactDetails?.profile_pic ?? "" ), placeholderImage:UIImage(named: "contactPlaceHolder") )
        firstNameTextField.text = peopleContactDetails?.first_name ?? ""
        lastNameTextField.text = peopleContactDetails?.last_name ?? ""
        mobileNumberTextField.text = peopleContactDetails?.phone_number
        emailTextField.text = peopleContactDetails?.email
        
        
    }
    @objc func doneButtonTapped() {
        
        if peopleContactDetails == nil {
            addNewContact();
        }
        else{
            updateContact();
        }
        
        
    }
 
    func updateContact(){
        
        let updateUrl = "\(updatePeopleDetailsURL)\(String(describing: peopleContactDetails?.id ?? nil) ).json"
        
        let userDict : [String : Any] = ["first_name": firstNameTextField.text ?? "",
                                         "last_name": lastNameTextField.text ?? "",
                                         "email": emailTextField.text ?? "",
                                         "phone_number": mobileNumberTextField.text ?? "",
                                         "profile_pic": peopleContactDetails?.profile_pic ?? "",
                                         "favorite": peopleContactDetails?.favorite ?? "",
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
                    print(response.value as Any)
                }
                
                
        }
    }
    
    func addNewContact() {
        
        
      //  let updateUrl = "\(updatePeopleDetailsURL)\(peopleContactUpdated?.id ?? nil).json"
        
        let userDict : [String : Any] = ["first_name": firstNameTextField.text ?? "",
                                         "last_name": lastNameTextField.text ?? "",
                                         "email": emailTextField.text ?? "",
                                         "phone_number": mobileNumberTextField.text ?? "",
                                         "profile_pic": peopleContactDetails?.profile_pic ?? "",
                                         "favorite": peopleContactDetails?.favorite ?? "",
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


