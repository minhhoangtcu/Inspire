//
//  CatagoriesTable.swift
//  Inspire
//
//  Created by Minh Hoang on 9/23/16.
//  Copyright © 2016 Minh Hoang. All rights reserved.
//

import UIKit

class CatagoriesTable: UITableViewController {
    
    struct CellIdentifiers {
        static let singleCatagory = "SingleCategory"
        static let doubleCatagory = "DoubleCatagory"
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 && indexPath.row == 0 {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.singleCatagory) else {
                print("CatagoriesTable: Cannot dequeue cell named \(CellIdentifiers.singleCatagory)")
                return UITableViewCell() // basically return an empty cell
            }
            
            return cell
            
        } else {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.doubleCatagory) else {
                print("CatagoriesTable: Cannot dequeue cell named \(CellIdentifiers.doubleCatagory)")
                return UITableViewCell() // basically return an empty cell
            }
            
            return cell
            
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 1 {
            return "Catagories"
        } else {
            return ""
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

