//
//  LewisStartTableViewController.swift
//  LewisWorkout
//
//  Created by JOSEPH KERR on 7/12/16.
//  Copyright © 2016 b3k3r. All rights reserved.
//

import UIKit


class LWStartTableViewCell: UITableViewCell {
    @IBOutlet weak var stageLabel: UILabel!
    @IBOutlet weak var stageImageView: UIImageView!
}

protocol TableResponseDelegate {
    
    func createViewWithCellContents(cell: LWStartTableViewCell, ContentOffset offset: CGFloat)
}


class LWStartTableViewController: UITableViewController {

    
    var delegate: TableResponseDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let backView = UIView()
        backView.backgroundColor = UIColor.black
        self.tableView.backgroundView = backView
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // MARK: - Table view delegate

    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if let stageCell = cell as? LWStartTableViewCell {
            if indexPath.row == 0 {
                stageCell.stageImageView.image = UIImage(named: "menuItem - 1")
                stageCell.stageLabel.text = "Football"
            } else if indexPath.row == 1 {
                stageCell.stageImageView.image = UIImage(named: "menuItem - 2")
                stageCell.stageLabel.text = "Basketball"
                
            } else if indexPath.row == 2 {
                stageCell.stageImageView.image = UIImage(named: "menuItem - 3")
                stageCell.stageLabel.text = "Gym"
                
            }else if indexPath.row == 3 {
                stageCell.stageImageView.image = UIImage(named: "menuItem - 4")
                stageCell.stageLabel.text = "Track"
                
            }
        }
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let supplView = UIView()
        supplView.backgroundColor = UIColor.black
        return supplView
    }

    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let supplView = UIView()
        supplView.backgroundColor = UIColor.black
        return supplView
    }

    // MARK: - Table view data source

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 4
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LewisCell", for: indexPath)

        // Configure the cell...

        return cell
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath) {
        //
        let cellSelected: LWStartTableViewCell = tableView.cellForRow(at: indexPath) as! LWStartTableViewCell
        tableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
        
        delegate?.createViewWithCellContents(cell: cellSelected, ContentOffset: self.tableView.contentOffset.y)
        
    }
   
}