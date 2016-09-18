//
//  TimerCellTappedViewController.swift
//  Clock
//
//  Created by Seth Wolfe on 8/13/16.
//  Copyright © 2016 Seth Wolfe. All rights reserved.
//

import UIKit

class TimerCellTappedViewController: UIViewController {
    var timer: NSTimer!
    @IBOutlet weak var noteLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var hoursLabel: UILabel!
    @IBOutlet weak var minutesLabel: UILabel!
    @IBOutlet weak var secondsLabel: UILabel!
    var row = 0
    var counter = 0
    var timerObj = Timer()
    var testArray = [Timer]()
    var test: NSData?
    @IBAction func deletePressed(sender: AnyObject) {
        
        //remove timer from array and dismiss self
        //we don't need to save here because I'll do that in viewWillDisappear anyways

        testArray.removeAtIndex(row)
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    
    @IBAction func backPressed(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func update(){
        if(test != nil){
            
            //A lot of this is formatting to make the numbers look pretty/correct
            
            //Because of the inconvenient way I am keeping time if there are 30 seconds
            //left and you call testArray[row].minute the timer will report back 1 minute.
            //However, for our purposes there would be 0 minutes and 30 seconds because we are
            //counting seconds - so we should subtract one if the integer is 1 or greater
            
            //Another thing this takes into account is the case where the seconds/minutes/hours
            //are less than ten. It would look better to have a 0 in front of every single digit
            //integer, in order to do that we can just check if the number is less than 10
            
            var hour = testArray[row].hour
            var minute = testArray[row].minute
            var seconds = testArray[row].seconds
            
            if(hour < 10 && hour >= 1){
                hoursLabel.text = "0" + String (testArray[row].hour - 1)
                
            }else if(hour == 0){
                hoursLabel.text = "0" + String (testArray[row].hour)
                
            }else{
                hoursLabel.text = String (hour - 1)
            }
            
            if(minute < 10 && minute >= 1){
                minutesLabel.text = "0" + String (testArray[row].minute - 1)

            }else if(minute == 0){
                minutesLabel.text = "0" + String (testArray[row].minute)
                
            }else{
                minutesLabel.text = String (testArray[row].minute - 1)
            }
            
            if(seconds > 50){
                secondsLabel.text = "0" + String (60 - seconds)
                
            }else if(seconds == 60){
                secondsLabel.text = "0" + String (60 - seconds)
                
            }else{
                secondsLabel.text = String (60 - seconds)
            }
            
            //This is also a bandaid that really shouldn't be here
            //This will dismiss the the current view so that we can switch views to the
            //TimerOffViewController. Because of this the view change looks a little sporatic
            
            if(hoursLabel.text == "00" && minutesLabel.text == "00" && testArray[row].seconds == 0){
                self.dismissViewControllerAnimated(true, completion: nil)
            }
            
        }

        //This will update every timer in the testArray
        
        for timer in testArray {
            let timerObj = timer as Timer
            timerObj.update()
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        //Grab the timer array using NSKeyedUnarchiver, instantiate an NSTimer
        
        let alarmDefaults = NSUserDefaults.standardUserDefaults()
        test = alarmDefaults.objectForKey("timerarray") as? NSData
        if test != nil {
            testArray = (NSKeyedUnarchiver.unarchiveObjectWithData(test!) as? [Timer])!

        
        timer = NSTimer(fireDate: NSDate(), interval: 1, target: self, selector: #selector(update), userInfo: nil, repeats: true)
        NSRunLoop.mainRunLoop().addTimer(timer, forMode: NSDefaultRunLoopMode)
        }
        
        //This check will allow us to find out what cell we tapped
        //This probably could've been done more easily if I had used segues
        
        for timer in testArray {
            counter += 1
            if timer.complete{
                nameLabel.text = timer.name as String
                noteLabel.text = timer.note as String
                timer.complete = false
                row = counter - 1
            }
        }
        counter = 0
        

        
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(animated: Bool) {
        
        //This is really important, I have to update my timer array
        //in order for the time to be continuous when I switch views
        
        //Invalidate my NStimer
        
        super.viewWillDisappear(animated)
        let alarmDefaults = NSUserDefaults.standardUserDefaults()
        let timerarray = NSKeyedArchiver.archivedDataWithRootObject(testArray)
        alarmDefaults.setObject(timerarray, forKey: "timerarray")
        alarmDefaults.synchronize()
        timer?.invalidate()
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

}
