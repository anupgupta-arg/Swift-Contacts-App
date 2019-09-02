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
        fillDetails()
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped))
        
        navigationItem.rightBarButtonItem = done
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
    }
    
    
    
    @IBAction func cameraButtonAction(_ sender: Any) {
    }
}

extension EditContactDeatilsVC {
    
    func fillDetails() {
        
        avatar.sd_setImage(with: URL(string: peopleContactDetails?.profile_pic ?? "" ), placeholderImage:UIImage(named: "contactPlaceHolder") )
        firstNameTextField.text = peopleContactDetails?.first_name ?? ""
        lastNameTextField.text = peopleContactDetails?.last_name ?? ""
        mobileNumberTextField.text = peopleContactDetails?.phone_number
        emailTextField.text = peopleContactDetails?.email
        
        
    }
    @objc func doneButtonTapped() {
        
        
        guard firstNameTextField.text != "" else {
            print("first nmae111")
            self.showAlert(title: "Error", message: "Please enter valid first name.")
            
            return
        }
        
        guard lastNameTextField.text != "" else {
            print("first nmae2222")
            self.showAlert(title: "Error", message: "Please enter valid last name")
            return
        }
        guard mobileNumberTextField.text != "" && mobileNumberTextField.text!.isPhoneNumber  else {
            print("first nmae333")
            self.showAlert(title: "Error", message: "Please enter valid mobile number")
            return
        }
        guard emailTextField.text != "" && (emailTextField.text?.isValidEmail())!   else {
            print("first nmae444")
            self.showAlert(title: "Error", message: "Please enter valid email")
            
            
            return
        }
        
        
        if peopleContactDetails?.id == 0 ||  peopleContactDetails == nil{
            addNewContact();
        }
        else{
            updateContact();
        }
        
        
    }
    
 
    
    func updateContact(){
        
        guard let id = peopleContactDetails?.id else {
            return;
        }
        
        let updateUrl = "\(updatePeopleDetailsURL)\(id).json"
        
        
        let userDict : [String : Any] = ["first_name": firstNameTextField.text ?? "",
                                         "last_name": lastNameTextField.text ?? "",
                                         "email": emailTextField.text ?? "",
                                         "phone_number": mobileNumberTextField.text ?? "",
                                         "profile_pic": peopleContactDetails?.profile_pic ?? "",
                                         "favorite": peopleContactDetails?.favorite ?? ""
        ]
        self.view.isUserInteractionEnabled = true
        self.view.makeToastActivity(.center)
       
       
        let apiCallObj = apiCall.init()
        apiCallObj.updateContact(apiUrl: updateUrl, userDict: userDict, success: { (contactDetails) -> Void in
            self.peopleContactDetails = contactDetails
            self.fillDetails();
            // show alert
            self.view.isUserInteractionEnabled = true
           
            self.view.hideToastActivity()
            self.showAlert(title: "Success", message: "Conatct Update succesfully")
        },failure:  { (Error) -> Void in
            
            print("Error", Error as Any);
            // show alert
            self.view.isUserInteractionEnabled = true
            
            self.view.hideToastActivity()
             self.showAlert(title: "Error", message: "Something went wrong")
        })
    }
    
    func addNewContact() {
        
        let userDict : [String : Any] = ["first_name": firstNameTextField.text ?? "",
                                         "last_name": lastNameTextField.text ?? "",
                                         "email": emailTextField.text ?? "",
                                         "phone_number": mobileNumberTextField.text ?? "",
                                         "profile_pic": peopleContactDetails?.profile_pic ?? "",
                                         "favorite": peopleContactDetails?.favorite ?? "",
                                         
                                         ]
        let apiCallObj = apiCall.init()
        self.view.isUserInteractionEnabled = false
        self.view.makeToastActivity(.center)
       
        apiCallObj.addNewContact(userDict: userDict, success: { (contactDetails) -> Void in
            self.peopleContactDetails = contactDetails
            self.fillDetails();
            // show alert
            self.view.isUserInteractionEnabled = true
           
            self.view.hideToastActivity()
            self.showAlert(title: "Success", message: "Conatct Added succesfully")
        }, failure:  { (Error)-> Void in
            print("Error",Error as Any)
            // show alert
            self.view.isUserInteractionEnabled = true
           
            self.view.hideToastActivity()
            self.showAlert(title: "Error", message: Error!.localizedDescription)
        })
    }
}
extension EditContactDeatilsVC :UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        self.view.endEditing(true)
        return true;
    }
}


