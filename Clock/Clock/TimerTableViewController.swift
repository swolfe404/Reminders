//
//  TimerTableViewController.swift
//  Clock
//  Created by Seth Wolfe on 8/11/16.
//  Copyright © 2016 Seth Wolfe. All rights reserved.
//

import UIKit

class TimerTableViewController: UITableViewController, TimerDelegate {

    var timer: NSTimer!
    var timerArray = []
    var timerObj = Timer()
    var testArray = [Timer]()
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden = false
        
        //Unarchive our timerArray, if it has at least one element in it
        //we need to update the timer
        
        let alarmDefaults = NSUserDefaults.standardUserDefaults()
        let test = alarmDefaults.objectForKey("timerarray") as? NSData
        if test != nil {
            testArray = (NSKeyedUnarchiver.unarchiveObjectWithData(test!) as? [Timer])!
            for timer in testArray {
                let timerObj = timer as Timer
                timerObj.delegate = self
            }
        }
        tableView.reloadData()
        if(testArray.count >= 1){
            timer = NSTimer(fireDate: NSDate(), interval: 1, target: self, selector: #selector(update), userInfo: nil, repeats: true)
            NSRunLoop.mainRunLoop().addTimer(timer, forMode: NSDefaultRunLoopMode)
        }

    }
    
    func timerCompleted(timer: Timer){
        
        //if the timer has been completed we need to save it and set timer.complete to true
        
        let alarmDefaults = NSUserDefaults.standardUserDefaults()
        let timerarray = NSKeyedArchiver.archivedDataWithRootObject(timerArray)
        timer.complete = true
        alarmDefaults.setObject(timerarray, forKey: "timerarray")
        alarmDefaults.synchronize()

        //We will then go to the timerCellOff view
        let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let destination = storyboard.instantiateViewControllerWithIdentifier("timerCellOff")
        presentViewController(destination, animated: true, completion: nil)
    }
    
    //We need to update the other timers in the array
    func update(){
        for timer in testArray {
                timer.update()
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //there should be as many rows as there are timers
        return testArray.count
    }

    
   
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        //Set the text on the cell to the name given to it
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        let row = indexPath.row
        cell.textLabel?.text = testArray[row].name as String
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let destination = storyboard.instantiateViewControllerWithIdentifier("timerCellTapped")

        //I'm going to temporarily use this to describe which cell was tapped in the
        //If a cell is tapped and complete is true, then there should be no other cell with
        //timer.complete == true because that timer would have been deleted in func timerCompleted
        
        testArray[indexPath.row].complete = true
        
        presentViewController(destination, animated: true, completion: nil)
        
    }
   
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        //Save the timer before we switch views 
        
        let alarmDefaults = NSUserDefaults.standardUserDefaults()
        let timerarray = NSKeyedArchiver.archivedDataWithRootObject(testArray)
        alarmDefaults.setObject(timerarray, forKey: "timerarray")
        alarmDefaults.synchronize()
        timer?.invalidate()

    }
}
