//
//  ViewController.swift
//  UIkitDynamicDemo
//
//  Created by HamGuy on 10/15/14.
//  Copyright (c) 2014 HamGuy. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITableViewDataSource,UITableViewDelegate{
    
    @IBOutlet var tableView: UITableView!
    var selectedIndex = 0;
//    @IBOutlet weak var tableView: UITableView!
    var allText = ["Gravity","Collisions","Springs","Snap","Focus","Properties"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.title = "UIDynamicKit"
//        self.view.backgroundColor = UIColor.greenColor()
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell? = tableView.dequeueReusableCellWithIdentifier("titleCell", forIndexPath: indexPath) as? UITableViewCell
        cell?.textLabel.text = self.allText[indexPath.row]
        
        return cell!;
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allText.count
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "passValue"){
            let send = segue.destinationViewController as GravityController
            let index=tableView.indexPathForSelectedRow()!.row;
            send.tagetType = DynamicType(rawValue:index)
        }
    }
}

