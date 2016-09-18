//
//  AlarmViewController.swift
//  Clock
//
//  Created by Seth Wolfe on 8/12/16.
//  Copyright © 2016 Seth Wolfe. All rights reserved.
//

import UIKit

extension UIViewController{
    
    //Recognize tap as a gesture, when tapped dismiss keyboard
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard1))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard1() {
        self.view.endEditing(true)
    }
}


class TimerViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate,UITextFieldDelegate {

    //Dismiss self
    @IBAction func back(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //When return is pressed dismiss keyboard
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    var timer: NSTimer!
    var timerObj = Timer()
    var testArray = [Timer]()
    @IBOutlet weak var hourPicker: UIPickerView!
    @IBOutlet weak var minutePicker: UIPickerView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var note: UITextField!
    var timerArray = [Timer]()
    @IBOutlet weak var name: UITextField!
    var hour:NSString = "0"
    var minute:NSString = "0"
    var hourArray = [Int]()
    var minuteArray = [Int]()
    
    
    @IBAction func savePressed(sender: UIButton) {
        let alarmDefaults = NSUserDefaults.standardUserDefaults()
        
        //I need to set my test to the objectForKey because this might not be
        //the first time saving a timer, if there are 3 timers already
        //then I need to have an array with all of those timers and the current
        //timer instead of just the current timer
        let test = alarmDefaults.objectForKey("timerarray") as? NSData
        if test != nil {
            timerArray = (NSKeyedUnarchiver.unarchiveObjectWithData(test!) as? [Timer])!
            print("test1")
        }
        
        //Create a timer with all of the inputs from the user
        let timer = Timer()
        timer.minute = Int (minute as String)!
        timer.hour = Int (hour as String)!
        timer.name = name.text!
        timer.note = note.text!
        timer.seconds = 0
        
        //Add it to the array and save it
        timerArray.append(timer)
        let timerarray = NSKeyedArchiver.archivedDataWithRootObject(timerArray)
        alarmDefaults.setObject(timerarray, forKey: "timerarray")
        alarmDefaults.synchronize()
        
        //If we've pressed save we should dismiss the view
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
    override func viewWillAppear(animated: Bool) {
        
        //This checks if the array has an actual timer in it before I create 
        //an NSTimer, because if it doesn't then I shouldn't have an NSTimer calling
        //update every second
        let alarmDefaults = NSUserDefaults.standardUserDefaults()
        let test = alarmDefaults.objectForKey("timerarray") as? NSData
        if test != nil {
            testArray = (NSKeyedUnarchiver.unarchiveObjectWithData(test!) as? [Timer])!
        }
        if(testArray.count > 0){
            timer = NSTimer(fireDate: NSDate(), interval: 1, target: self, selector: #selector(update), userInfo: nil, repeats: true)
            NSRunLoop.mainRunLoop().addTimer(timer, forMode: NSDefaultRunLoopMode)
        }

    }
    
    //Update the other timers in the testArray
    func update(){
        for timer in testArray {
            let timerObj = timer as Timer
            timerObj.update()
        }
    }
    
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        //The number of rows in our pickerView should be 60 or 24
        
        if(pickerView == hourPicker){
            return hourArray.count
        }else {
            return minuteArray.count
        }
    }
    
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        //The number on the picker view should be 0-59 or 0-23 depending
        //on whether it is the hourPicker or the minutePicker
        
        if(pickerView == hourPicker){
            return "\(hourArray[row])"
        }else {
            return "\(minuteArray[row])"
        }
        
        
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        //this is where we get the hour and minutes to save to the timer
        //They'll be stored in the local variables "hour" and "minute"
        
        if(pickerView == hourPicker){
            hour = "\(hourArray[row])"
        }else{
            minute = "\(minuteArray[row])"
        }
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        hourPicker.dataSource = self
        hourPicker.delegate = self
        minutePicker.dataSource = self
        minutePicker.delegate = self
        
        //Create the minuteArray and hourArray
        for i in 0 ..< 60 {
            minuteArray.append(i)
        }
        
        for j in 0 ..< 24 {
            
            hourArray.append(j)
        }
        self.note.delegate = self
        self.name.delegate = self
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        //Invalidate timer everytime we leave a view
        timer?.invalidate()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    


}
