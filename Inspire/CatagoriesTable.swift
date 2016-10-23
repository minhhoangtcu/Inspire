//
//  CatagoriesTable.swift
//  Inspire
//
//  Created by Minh Hoang on 9/23/16.
//  Copyright © 2016 Minh Hoang. All rights reserved.
//

import UIKit

class CatagoriesTable: UITableViewController {
    
    // holds all identifiers inside StoryBoard
    struct CellIdentifiers {
        static let singleCatagory = "SingleCategory"
        static let doubleCatagory = "DoubleCatagory"
    }
    
    @IBOutlet var catagoriesTable: UITableView!
    
    // defines all picture getters
    let pc = PictureGetter(withTags: "portrait", numOfPictures: 10)
    let tg = TagsGetter()
    
    // defines all catagories that we want to display
    let catagories: [[String]] = [["random"],
                                  ["portrait", "landscape"],
                                  ["blackAndWhite", "journalism"]]
    
    var numberOfRowsForSecondSection: Int {
        get {
            return catagories.count - 1 // we don't count the first row
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 && indexPath.row == 0 {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.singleCatagory) as? SingleCatagoryCell else {
                print("CatagoriesTable: Cannot dequeue cell named \(CellIdentifiers.singleCatagory)")
                return UITableViewCell() // basically return an empty cell
            }
            
            cell.catagoryLabel = catagories[0][0]
            if pc.isDoneFectching {
                let firstPhoto = pc.photos[0]
                cell.catagoryImage = firstPhoto.image
                print(firstPhoto.toString() + "\n")
//                tg.getTags(photo: firstPhoto)
            }
            
            return cell
            
        } else {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.doubleCatagory) as? DoubleCatagoryCell else {
                print("CatagoriesTable: Cannot dequeue cell named \(CellIdentifiers.doubleCatagory)")
                return UITableViewCell() // basically return an empty cell
            }
            
            cell.leftCatagoryLabel = catagories[indexPath.section + indexPath.row][0] // we need to include indexPath.section because we want to ignore the first catagory.
            cell.rightCatagoryLabel = catagories[indexPath.section + indexPath.row][1]
            
            if pc.isDoneFectching {
                cell.leftCatagoryImage = pc.photos[indexPath.section + indexPath.row*2].image
                cell.rightCatagoryImage = pc.photos[indexPath.section + indexPath.row*2 + 1].image
//                print(pc.photos[indexPath.section + indexPath.row*2].toString() + "\n")
//                print(pc.photos[indexPath.section + indexPath.row*2 + 1].toString() + "\n")
            }
            
            return cell
            
        }
    }
    
    // first section has only 1 row, and the second one depends on how many catagories that we have
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : numberOfRowsForSecondSection
    }
    
    // always have 2 sections
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    // names the section
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 1 {
            return "Catagories"
        } else {
            return ""
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 && indexPath.row == 0 {
            return 240.0
        } else {
            return 135.0
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        pc.functionToExecuteAtTheEnd = {
            print("Finished loading data")
            self.catagoriesTable.reloadData()
        }
        pc.getUrls()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

