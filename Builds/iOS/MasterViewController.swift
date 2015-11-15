//
//  MasterViewController.swift
//  JustTuner
//
//  Created by Adam Elemental on 15/09/2015.
//
//

import UIKit

class MasterViewController: UITableViewController
{
//    var dataController: DataControllerObjC
    var juceViewController: JuceViewController?
    var messages = [Message]()
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Messages"
        //self.tableView.delegate = self
        self.loadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadData() {
        print ("loadData");
        let dataController = DataControllerObjC()
        let jsonString = dataController.getJsonData()
        print (jsonString)
        
        let jsonData = jsonString.dataUsingEncoding(NSUTF8StringEncoding)
        
        if let jsonData = jsonData { // Check 1.
            do {
                let jsonDictionary = try NSJSONSerialization.JSONObjectWithData(jsonData, options: .AllowFragments)  // Check 2. and 3.
                print("Dictionary received")
                
                // Load into messages array
                if let jsonArray = jsonDictionary as? NSArray {
                    for item in jsonArray {
                        messages.append(Message(json: item as! NSDictionary));
                    }
                    print (messages.debugDescription);
                }
            }
            catch let error as NSError {
                print(error)
            }
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return messages.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell     {
        
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "cell")
        
        if let message = self.messages[indexPath.row] as Message? {
            cell.textLabel!.text = message.title
        } else {
            cell.textLabel!.text = "Untitled"
        }
        
        return cell
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        let message = messages[indexPath.row]
        let dataController = DataControllerObjC()
        
        dataController.setMessage(message.title, message.message)
        juceViewController!.setTitle()

        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            if #available(iOS 8.0, *) {
                showDetailViewController(juceViewController!, sender: self)
            } else {
                // Fallback on earlier versions
            }
        } else {
            self.navigationController?.pushViewController(juceViewController!, animated: true)
        }

    }
    

    

}
