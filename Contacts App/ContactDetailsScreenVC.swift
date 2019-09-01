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
    
    var peopleContactDetails : ContactList?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fillDetails()
        fetchPeopleCompleteDeatils()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        let edit = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editButtonTapped))
        
        navigationItem.rightBarButtonItem = edit
    }
    
    @IBAction func messageButtonAction(_ sender: Any) {
        guard MFMessageComposeViewController.canSendText() else {
            print("Message Did Not Configure")
            return
        }
        guard let number = peopleContactDetails?.phone_number else {
            // Show alert message
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
             // Show alert message
        }
    }
    @IBAction func emailButtonAction(_ sender: Any) {
    }
    @IBAction func favButtonAction(_ sender: Any) {
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
    
    func fetchPeopleCompleteDeatils() {
        let peopleurl : String = peopleContactDetails?.url ?? "";
        guard peopleurl != "" else {
            return
        }
        Alamofire.request(peopleurl).response { response in
            guard let data = response.data else { return }
            do {
                let decoder = JSONDecoder()
                self.peopleContactDetails = try decoder.decode(ContactList.self, from: data)
                self.fillDetails();
            } catch let error {
                print(error)
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

