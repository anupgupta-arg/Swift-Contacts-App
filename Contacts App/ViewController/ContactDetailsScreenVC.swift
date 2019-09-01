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
import MessageUI

class ContactDetailsScreenVC: UIViewController{
    
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var contactName: UILabel!
    @IBOutlet weak var mobileNumberLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    @IBOutlet weak var favButton: UIButton!
    
    var peopleContactDetails : ContactList?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
   
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        let edit = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editButtonTapped))
        fetchPeopleCompleteDeatils()
        fillDetails()
        navigationItem.rightBarButtonItem = edit
    }
    
    @IBAction func messageButtonAction(_ sender: Any) {
        guard MFMessageComposeViewController.canSendText() else {
           // print("Message Did Not Configure")
            self.showAlert(title: "Sorry", message: "Message Did Not Configure")
            return
        }
        guard let number = peopleContactDetails?.phone_number else {
            // Show alert message
        self.showAlert(title: "Sorry", message: "Phone Number is not correct")
            return;
        }
        guard number != "" else {
            self.showAlert(title: "Sorry", message: "Phone Number is not Availabel")
            return;
        }
        
        let messageVC = MFMessageComposeViewController()
        messageVC.body = "This is GO-JEK iOS Contacts App";
        messageVC.recipients = ["\(number)"]
        messageVC.messageComposeDelegate = self
      
        self.present(messageVC, animated: true, completion: nil)
    }
    @IBAction func callButtonAction(_ sender: Any) {
        guard let number = peopleContactDetails?.phone_number else {
            // Show alert message
            print("call Did Not Configure")
             self.showAlert(title: "Sorry", message: "Phone Number is not correct")
            return;
        }
        
        if let url = URL(string: "tel://\(number)"),
            UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:], completionHandler:nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }else{
            self.showAlert(title: "Sorry", message: "Phone Number is not correct")
        }
    }
    @IBAction func emailButtonAction(_ sender: Any) {
        
        guard MFMailComposeViewController.canSendMail() else {
            // Show alert message
            print("Mail Did Not Configure")
            self.showAlert(title: "Sorry", message: "Mail box Did Not Configure")
            return
        }
        guard let recipient = peopleContactDetails?.email else{
            self.showAlert(title: "Sorry", message: "NO email address availabel")
            return
        }
        
        guard recipient != "" else{
            self.showAlert(title: "Sorry", message: "NO email address availabel")
            return
        }
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([recipient])
            mail.setMessageBody("This is GO-JEK iOS Contacts App", isHTML: true);
            
            present(mail, animated: true)
       
    }
    
    @IBAction func favButtonAction(_ sender: Any) {
        if peopleContactDetails?.id == 0 {
            addNewContact();
        }
        else{
            updateContact();
        }
        
        
        
    }
    
    @objc func editButtonTapped()  {
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc : EditContactDeatilsVC = storyBoard.instantiateViewController(withIdentifier: "EditContactDeatilsVCID") as! EditContactDeatilsVC
        vc.peopleContactDetails = peopleContactDetails;
        //        navigationController?.present(vc, animated: true, completion: nil)
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
extension ContactDetailsScreenVC {
    
   func fetchPeopleCompleteDeatils(){
    
    guard  let id = peopleContactDetails?.id else{
        return
    }
    guard  id != 0 else{
        return
    }
    let peopleurl = "\(updatePeopleDetailsURL)\(id).json"
    //let peopleurl : String = peopleContactDetails?.url ?? "";

    self.view.makeToastActivity(.center)
    self.view.isUserInteractionEnabled = false
    
    Alamofire.request(peopleurl).response { response in
        guard let data = response.data else { return }
        do {
            let decoder = JSONDecoder()
            self.view.hideToastActivity()
            self.view.isUserInteractionEnabled = true
            self.peopleContactDetails = try decoder.decode(ContactList.self, from: data)
            self.fillDetails();
        } catch let error {
            print(error)
            self.view.hideToastActivity()
            self.view.isUserInteractionEnabled = true
            self.showAlert(title: "Sorry", message: "Something went Wrong")
        }
    }
    }
    
}
extension ContactDetailsScreenVC {
    
    func fillDetails()  {
        
        avatar.sd_setImage(with: URL(string: peopleContactDetails?.profile_pic ?? "" ), placeholderImage:UIImage(named: "contactPlaceHolder") )
        contactName.text = "\(peopleContactDetails?.first_name ?? "" ) \(peopleContactDetails?.last_name ?? "")"
        mobileNumberLabel.text =  peopleContactDetails?.phone_number
        emailLabel.text = peopleContactDetails?.email
        if peopleContactDetails!.favorite {
             favButton.setImage(UIImage.init(named: "favFilledGreen"), for: .normal)
        }
        else{
             favButton.setImage(UIImage.init(named: "fevStarBlank"), for: .normal)
        }
       
    }
    

}


extension ContactDetailsScreenVC:  MFMessageComposeViewControllerDelegate   {
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        switch (result) {
        case .cancelled:
            print("Message was cancelled")
            dismiss(animated: true, completion: nil)
        case .failed:
            print("Message failed")
            dismiss(animated: true, completion: nil)
        case .sent:
            print("Message was sent")
            dismiss(animated: true, completion: nil)
        default:
            break
        }
    }
    
}
extension ContactDetailsScreenVC : MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        switch (result) {
        case .cancelled:
            print("Message was cancelled")
            dismiss(animated: true, completion: nil)
        case .failed:
            print("Message failed")
            dismiss(animated: true, completion: nil)
        case .sent:
            print("Message was sent")
            dismiss(animated: true, completion: nil)
        default:
            break
        }
    }
    
    
}

extension ContactDetailsScreenVC {
    
   
    
    func updateContact(){
        
        guard let id = peopleContactDetails?.id else {
            return;
        }
        
        let updateUrl = "\(updatePeopleDetailsURL)\(id).json"
        let isFavorite: Bool?
        if peopleContactDetails!.favorite {
            isFavorite = false
        }
        else{
            isFavorite = true
        }
        
        let userDict : [String : Any] = ["first_name": peopleContactDetails?.first_name as Any,
                                         "last_name":  peopleContactDetails?.last_name as Any,
                                         "email": peopleContactDetails?.email as Any ,
                                         "phone_number": peopleContactDetails?.phone_number as Any ,
                                         "profile_pic": peopleContactDetails?.profile_pic ?? "",
                                         "favorite": isFavorite as Any
        ]
        
        let apiCallObj = apiCall.init()
        apiCallObj.updateContact(apiUrl: updateUrl, userDict: userDict, success: { (contactDetails) -> Void in
            self.peopleContactDetails = contactDetails
            self.fillDetails();
             // show alert
        },failure:  { (Error) -> Void in
            
            print("Error", Error as Any);
             // show alert
        })
    }

    func addNewContact() {
        
        guard peopleContactDetails?.first_name != "" else {
            print("first nmae111")
            self.showAlert(title: "Sorry", message: "This user is from your mobile conatct list and this info is wrong ")
            
            return
        }
        
        guard peopleContactDetails?.last_name != "" else {
            print("first nmae2222")
           self.showAlert(title: "Sorry", message: "This user is from your mobile conatct list and this info is wrong ")
            return
        }
        guard peopleContactDetails?.phone_number != "" && (peopleContactDetails?.phone_number?.isPhoneNumber)!  else {
            print("first nmae333")
           self.showAlert(title: "Sorry", message: "This user is from your mobile conatct list and this info is wrong ")
            return
        }
        guard peopleContactDetails?.email != "" && (peopleContactDetails?.email?.isValidEmail())!   else {
            print("first nmae444")
           self.showAlert(title: "Sorry", message: "This user is from your mobile conatct list and this info is wrong ")
            
            
            return
        }
        
        let userDict : [String : Any] = ["first_name": peopleContactDetails?.first_name as Any,
                                         "last_name":  peopleContactDetails?.last_name as Any,
                                         "email": peopleContactDetails?.email as Any ,
                                         "phone_number": peopleContactDetails?.phone_number as Any ,
                                         "profile_pic": peopleContactDetails?.profile_pic ?? "",
                                         "favorite": true
        ]
         let apiCallObj = apiCall.init()
        apiCallObj.addNewContact(userDict: userDict, success: { (contactDetails) -> Void in
            self.peopleContactDetails = contactDetails
            self.fillDetails();
            // show alert
            
        }, failure:  { (Error)-> Void in
            print("Error",Error as Any)
             // show alert
        })
    }
    
}
