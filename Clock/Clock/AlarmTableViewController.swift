//
//  AlarmTableViewController.swift
//  Clock
//
//  Created by Seth Wolfe on 8/11/16.
//  Copyright © 2016 Seth Wolfe. All rights reserved.
//

import UIKit

class AlarmTableViewController: UITableViewController {
    var timer: NSTimer!
    var selectedRow = 0
    
    var seconds = 0
    var am:NSString = ""
    var note:NSString = ""
    var name:NSString = ""
    var hour = 0
    var minute = 0
    var alarm = Alarm()
    var testArray = [Alarm]()
    var currentTime:NSString = ""
    var row = 0
    
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        //We do not want our navigation bar to be hidden in this view
        //because we want to add multiple alarms
        
        self.navigationController?.navigationBarHidden = false
        
        //This pulls our timer array out of NSUserDefaults
        
        let alarmDefaults = NSUserDefaults.standardUserDefaults
        let test = alarmDefaults().objectForKey("alarmArray") as? NSData
        if test != nil {
            testArray = (NSKeyedUnarchiver.unarchiveObjectWithData(test!) as? [Alarm])!
        }
        //We need our tableView to reflect our timer array that we just got
        tableView.reloadData()
        
        //if we have anything in our timer array it needs to update
        if(testArray.count >= 1){
            timer = NSTimer(fireDate: NSDate(), interval: 1, target: self, selector: #selector(update), userInfo: nil, repeats: true)
            NSRunLoop.mainRunLoop().addTimer(timer, forMode: NSDefaultRunLoopMode)
        }
        
        
        
    }

    func update(){
        for alarm in testArray{
            
            //This update checks if the alarm has expired
            //to do that we need to know the current time
            
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "HH:mm"
            currentTime = dateFormatter.stringFromDate(NSDate())
            let currentHour:NSString = currentTime.substringToIndex(2)
            var currentMinute:NSString = currentTime.substringFromIndex(3)
            currentMinute = currentMinute.substringToIndex(2)
            
            print("currentTime")
            print(currentHour)
            print(currentMinute)
            print("")
            print("Alarm count")
            print(testArray.count)
            print("alarm hour")
            print(alarm.hour)
            print("alarm minute")
            print(alarm.minute)
            print("")
            
            //if our array has something in it and our timer was set to go
            //off at the current time, then we need to send it to alarmCellOff
            
            if(testArray.count > 0 && Int(currentHour as String) == alarm.hour && Int(currentMinute as String) == alarm.minute){
                
                //We need to get rid of this
                
                timer?.invalidate()
                
                //This will let us know which alarm went off
                
                alarm.wasTapped = true
                
                //Save our alarm to NSUserDefaults
                
                let alarmarray = NSKeyedArchiver.archivedDataWithRootObject(testArray)
                let alarmDefaults = NSUserDefaults.standardUserDefaults()
                alarmDefaults.setObject(alarmarray, forKey: "alarmArray")
                alarmDefaults.synchronize()
                let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
                let destination = storyboard.instantiateViewControllerWithIdentifier("alarmCellOff")
                
                //Take us to alarmCellOff
                
                presentViewController(destination, animated: true, completion: nil)
            }
            row += 1
        }
        row = 0
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
        return testArray.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell2", forIndexPath: indexPath)
        let row = indexPath.row
        
        //The name of our cell should be the name we set it as
        
        cell.textLabel?.text = testArray[row].name as String
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        //When we click on a row it should take us to another view
        //giving us information about the alarm
        
        selectedRow = indexPath.row
        testArray[indexPath.row].wasTapped = true
        let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let destination = storyboard.instantiateViewControllerWithIdentifier("alarmCellTapped")
        presentViewController(destination, animated: true, completion: nil)
        
    }
    
    
    override func viewWillDisappear(animated: Bool) {
        
        //when the view dissapears we will want to invalidate our current
        //NSTimer object and save our array of alarms
        
        super.viewWillDisappear(animated)
        timer?.invalidate()
        let alarmarray = NSKeyedArchiver.archivedDataWithRootObject(testArray)
        let alarmDefaults = NSUserDefaults.standardUserDefaults()
        alarmDefaults.setObject(alarmarray, forKey: "alarmArray")
        alarmDefaults.synchronize()

    }
}