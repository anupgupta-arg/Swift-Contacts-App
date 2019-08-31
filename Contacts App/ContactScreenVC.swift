//
//  ContactScreenVC.swift
//  Contacts App
//
//  Created by Anup Gupta on 31/08/19.
//  Copyright © 2019 geekguns. All rights reserved.
//

import UIKit

class ContactScreenVC: UIViewController {
    @IBOutlet weak var contactListTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contactListTable.register(UINib(nibName:"ContactCell",bundle: nil), forCellReuseIdentifier: "ContactCellID")
        
        contactListTable.tableFooterView = UIView();
       
    }
    


}

extension ContactScreenVC : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : ContactCell = contactListTable.dequeueReusableCell(withIdentifier: "ContactCellID") as! ContactCell
        cell.contactName.text = "Anup";
        return cell;
        
    }
    
    
}
