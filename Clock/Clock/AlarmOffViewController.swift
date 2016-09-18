//
//  AlarmOffViewController.swift
//  Clock
//
//  Created by Seth Wolfe on 8/13/16.
//  Copyright © 2016 Seth Wolfe. All rights reserved.
//

import UIKit
import AVFoundation

class AlarmOffViewController: UIViewController {
    @IBOutlet weak var alarmLabel: UILabel!
    @IBOutlet weak var noteLabel: UILabel!
    var testArray = [Alarm] ()
    var counter = 0
    var row = 0
    var timer: NSTimer!
    var audioPlayer : AVAudioPlayer! = nil
    
    @IBAction func backPressed(sender: UIButton) {
        
        //dismiss self
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBOutlet weak var offButton: UIButton!
    
    //If off is pressed we want to turn off the audio that is being played
    @IBAction func offPressed(sender: UIButton) {
        offButton.enabled = false
        audioPlayer?.stop()
    }
    
    
    func update() {
        var index = 0
        for alarm in testArray{
            index += 1
            //We want to update every alarm except the one that has gone off
            if index - 1 != row {
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "HH:mm"
                let currentTime: NSString = dateFormatter.stringFromDate(NSDate())
                let currentHour:NSString = currentTime.substringToIndex(2)
                var currentMinute:NSString = currentTime.substringFromIndex(3)
                currentMinute = currentMinute.substringToIndex(2)
                
                //if another alarm has gone off in the time that it took for this one to go off 
                //then we need to dismiss the view so that we can go to that alarm's alarmOffView
                if(testArray.count > 0 && Int(currentHour as String) == alarm.hour && Int(currentMinute as String) == alarm.minute){
                    timer?.invalidate()
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
            }
        }
    }

    override func viewWillAppear(animated:Bool){
        super.viewWillAppear(animated)
        
        //Unarchive the alarm object and set it to an array of alarms
        
        let alarmDefaults = NSUserDefaults.standardUserDefaults()
        let test = alarmDefaults.objectForKey("alarmArray") as? NSData
        if test != nil {
            testArray = (NSKeyedUnarchiver.unarchiveObjectWithData(test!) as? [Alarm])!
        }
        
        //Use this to find which cell/row in the tableview has expired, I'm using a boolean "wasTapped"
        
        for alarm in testArray {
            counter += 1
            if alarm.wasTapped{
                row = counter - 1
                alarmLabel.text = alarm.name as String
                noteLabel.text = alarm.note as String
            }
        }
        if(testArray.count > 0){
            timer = NSTimer(fireDate: NSDate(), interval: 1, target: self, selector: #selector(update), userInfo: nil, repeats: true)
            NSRunLoop.mainRunLoop().addTimer(timer, forMode: NSDefaultRunLoopMode)
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let path = NSBundle.mainBundle().pathForResource("Beep", ofType: "wav")
        let fileURL = NSURL(fileURLWithPath: path!)
        audioPlayer = try! AVAudioPlayer(contentsOfURL: fileURL, fileTypeHint: nil)
        audioPlayer.numberOfLoops = -1
        audioPlayer.prepareToPlay()
        audioPlayer.play()        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        //if the alarm went off we need to remove it from our array
        
        testArray.removeAtIndex(row)
        
        //and save it
        
        let alarmarray = NSKeyedArchiver.archivedDataWithRootObject(testArray)
        let alarmDefaults = NSUserDefaults.standardUserDefaults()
        alarmDefaults.setObject(alarmarray, forKey: "alarmArray")
        alarmDefaults.synchronize()
        
        //we also need to invalidate our timer and stop our audioPlayer if it hasn't been stopped
        timer?.invalidate()
        audioPlayer?.stop()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
