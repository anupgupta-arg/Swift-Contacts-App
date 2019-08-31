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

       
    }
    


}

extension ContactScreenVC : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }
    
    
}
