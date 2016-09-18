//
//  TimerViewController.swift
//  Clock
//
//  Created by Seth Wolfe on 8/8/16.
//  Copyright © 2016 Seth Wolfe. All rights reserved.
//

import UIKit

extension UIViewController {
    
    //Recognize tap as a gesture and if there has been a tap dismiss the keyboard
    func hideKeyboardTapped() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
}

    func dismissKeyboard() {
        view.endEditing(true)
    }
}

class AlarmViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var myDatePicker: UIDatePicker!
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var noteText: UITextField!
    
    var alarmHour:NSString = "0"
    var alarmMinute:NSString = "0"
    var am:NSString = "am"
    var note:NSString = ""
    var name:NSString = ""
    var strDate = ""
    var alarm = Alarm()
    var alarmArray = [Alarm]()
    var timer: NSTimer!
    var row = 0

    //If return is pressed in our keyboard then we should dismiss the keyboard
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    //Dismiss self
    @IBAction func backPressed(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func update(){
        
        //Check each alarm in the array and if the time it should go off is equal
        //to the current time then we should go to alarmCellOff
        
        for alarm in alarmArray{
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "HH:mm"
            let currentTime: NSString = dateFormatter.stringFromDate(NSDate())
            let currentHour:NSString = currentTime.substringToIndex(2)
            var currentMinute:NSString = currentTime.substringFromIndex(3)
            currentMinute = currentMinute.substringToIndex(2)
            
            if(alarmArray.count > 0 && Int(currentHour as String) == alarm.hour && Int(currentMinute as String) == alarm.minute){
                timer?.invalidate()
                alarm.wasTapped = true
                let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
                let destination = storyboard.instantiateViewControllerWithIdentifier("alarmCellOff")
                presentViewController(destination, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func savePressed(sender: UIButton) {

        //Unarchive our current array of alarms
        
        let dateFormatter = NSDateFormatter()
        let alarmDefaults = NSUserDefaults.standardUserDefaults()
        let test = alarmDefaults.objectForKey("alarmArray") as? NSData
        if test != nil {
            alarmArray = (NSKeyedUnarchiver.unarchiveObjectWithData(test!) as? [Alarm])!
        }
        
        //Create an alarm with the current time
        
        dateFormatter.dateFormat = "HH mm a"
        strDate = dateFormatter.stringFromDate(myDatePicker.date)
        print(strDate)
        alarmHour = strDate
        if(strDate != ""){
            alarmHour = alarmHour.substringToIndex(2)
            alarmMinute = strDate
            alarmMinute = alarmMinute.substringFromIndex(3)
            alarmMinute = alarmMinute.substringToIndex(2)
            am = strDate
            am = am.substringFromIndex(6)
            name = nameText.text!
            note = noteText.text!
            alarm.hour = Int (alarmHour as String)!
            alarm.minute = Int (alarmMinute as String)!
            alarm.name = name
            alarm.note = note
            
            //append the alarm to the array (we'll save it in viewWillDisappear)
            
            alarmArray.append(alarm)

        }
 
        //After pressing save we should dismiss the view
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
 
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        //This is all a test to see if we should create a new NSTimer and update our
        //alarms, if there is anything in our alarmArray then we should
        
        let alarmDefaults = NSUserDefaults.standardUserDefaults()
        let test = alarmDefaults.objectForKey("alarmArray") as? NSData
        if test != nil {
            alarmArray = (NSKeyedUnarchiver.unarchiveObjectWithData(test!) as? [Alarm])!
        }
        if(alarmArray.count > 0){
            timer = NSTimer(fireDate: NSDate(), interval: 1, target: self, selector: #selector(update), userInfo: nil, repeats: true)
            NSRunLoop.mainRunLoop().addTimer(timer, forMode: NSDefaultRunLoopMode)
        }
    }
 
    override func viewDidLoad(){
        super.viewDidLoad()
        self.hideKeyboardTapped()
        self.nameText.delegate = self
        self.noteText.delegate = self
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        //Invalidate timer and save our alarmArray
        
        timer?.invalidate()
        let alarmDefaults = NSUserDefaults.standardUserDefaults()
        let alarmarray = NSKeyedArchiver.archivedDataWithRootObject(alarmArray)
        alarmDefaults.setObject(alarmarray, forKey: "alarmArray")
        alarmDefaults.synchronize()
    }

}

