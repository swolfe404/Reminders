//
//  AlarmCellTappedViewController.swift
//  Clock
//
//  Created by Seth Wolfe on 8/13/16.
//  Copyright © 2016 Seth Wolfe. All rights reserved.
//

import UIKit

class AlarmCellTappedViewController: UIViewController {

    @IBOutlet weak var hourLabel: UILabel!
    @IBOutlet weak var minuteLabel: UILabel!
    @IBOutlet weak var amLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var noteLabel: UILabel!
    
    var testArray = [Alarm] ()
    var row = 0
    var timer: NSTimer!
    
    //Dismiss self
    @IBAction func backPressed(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //If our current time is equal to the time in our alarm the alarm should go off
    func update(){
        for alarm in testArray{
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "HH:mm"
            let currentTime: NSString = dateFormatter.stringFromDate(NSDate())
            let currentHour:NSString = currentTime.substringToIndex(2)
            var currentMinute:NSString = currentTime.substringFromIndex(3)
            currentMinute = currentMinute.substringToIndex(2)
            
            if(testArray.count > 0 && Int(currentHour as String) == alarm.hour && Int(currentMinute as String) == alarm.minute){
                timer?.invalidate()
                
                //Dismiss self so that alarmViewController can send us to alarmOffViewController
                
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
    }
    
    //Remove the alarm from the array and dismiss self
    @IBAction func deletePressed(sender: UIButton) {
                testArray.removeAtIndex(row)
                self.dismissViewControllerAnimated(true, completion: nil)

    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        //Check if we should update the other timers
        
        let alarmDefaults = NSUserDefaults.standardUserDefaults()
        let test = alarmDefaults.objectForKey("alarmArray") as? NSData
        if test != nil {
            testArray = (NSKeyedUnarchiver.unarchiveObjectWithData(test!)as? [Alarm])!
        }
        
        //Find which alarm we are working with
        
        var counter = 0
        for alarm in testArray {
            counter += 1
            if testArray[counter - 1].wasTapped{
                row = counter - 1
            }
        }
        
        
        //Set the labels.text equal to the time
        //Formatted so there are no hours over twelve, and if any number is below 10 it will 
        //have a leading zero; ex: "09"
        
        let hour = testArray[row].hour
        let minute = testArray[row].minute
        if hour > 12 {
            if hour - 12 > 9 {
                hourLabel.text = "\(hour - 12)"
            } else {
                hourLabel.text = "0" + "\(hour - 12)"
            }
                    
                amLabel.text = "pm"
            }else{
                if hour > 9{
                    hourLabel.text = "\(hour)"
                } else {
                    hourLabel.text = "0" + "\(hour)"
                }
                    
                    amLabel.text = "am"
                }
        if minute > 9 {
            minuteLabel.text = "\(testArray[row].minute)"
            } else {
                minuteLabel.text = "0" + "\(testArray[row].minute)"
            }
                
        nameLabel.text = testArray[row].name as String
        noteLabel.text = testArray[row].note as String
        testArray[row].wasTapped = false
        
        //finish checking if we should update the timers
        if(testArray.count > 0){
            timer = NSTimer(fireDate: NSDate(), interval: 1, target: self, selector: #selector(update), userInfo: nil, repeats: true)
            NSRunLoop.mainRunLoop().addTimer(timer, forMode: NSDefaultRunLoopMode)
        }
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        //Invalidate our NSTimer and save our alarmArray
        
        timer?.invalidate()
        let alarmarray = NSKeyedArchiver.archivedDataWithRootObject(testArray)
        let alarmDefaults = NSUserDefaults.standardUserDefaults()
        alarmDefaults.setObject(alarmarray, forKey: "alarmArray")
        alarmDefaults.synchronize()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
