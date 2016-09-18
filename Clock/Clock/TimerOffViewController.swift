//
//  TimerOffViewController.swift
//  Clock
//
//  Created by Seth Wolfe on 8/13/16.
//  Copyright © 2016 Seth Wolfe. All rights reserved.
//

import UIKit
import AVFoundation
class TimerOffViewController: UIViewController {

    var timer: NSTimer!
    var timerArray = []
    var timerObj = Timer()
    var testArray = [Timer]()
    var counter = 0
    var row = 0
    @IBOutlet weak var offButton: UIButton!
    
    //This willl turn the sound off when pressed
    @IBAction func offPressed(sender: UIButton) {
        offButton.enabled = false
        audioPlayer?.stop()
        
    }
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var note: UILabel!
    var audioPlayer : AVAudioPlayer! = nil
    
    //Dismiss self
    @IBAction func backPressed(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //Need to keep track of the other timers in our test array
    func update(){
        for timer in testArray {
            let timerObj = timer as Timer
            if(!timerObj.complete){
                timerObj.update()
            }
            
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        
        //Unarchive our timer array and declare an NSTimer
        let alarmDefaults = NSUserDefaults.standardUserDefaults()
        let test = alarmDefaults.objectForKey("timerarray") as? NSData
        if test != nil {
            testArray = (NSKeyedUnarchiver.unarchiveObjectWithData(test!) as? [Timer])!
        }
        timer = NSTimer(fireDate: NSDate(), interval: 1, target: self, selector: #selector(update), userInfo: nil, repeats: true)
        NSRunLoop.mainRunLoop().addTimer(timer, forMode: NSDefaultRunLoopMode)
        
        //Find the row of the timer that went off so that we can change that timer
        //in our timer array
        for timer in testArray {
            let timerObj = timer as Timer
            counter += 1
            if(timer.complete){
                row = counter - 1
                timer.complete = false
            }
        }
        
        //Set the text of the name and note label here
        name.text = String (testArray[row].name)
        note.text = String (testArray[row].note)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //Infinitely play the beep sound
        //Might replace the beep sound with a more pleasant one
        let path = NSBundle.mainBundle().pathForResource("Beep", ofType: "wav")
        let fileURL = NSURL(fileURLWithPath: path!)
        audioPlayer = try! AVAudioPlayer(contentsOfURL: fileURL, fileTypeHint: nil)
        audioPlayer.numberOfLoops = -1
        audioPlayer.prepareToPlay()
        audioPlayer.play()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        //get rid of the timer that went off and save our timer array
        testArray.removeAtIndex(row)
        let alarmDefaults = NSUserDefaults.standardUserDefaults()
        let timerarray = NSKeyedArchiver.archivedDataWithRootObject(testArray)
        alarmDefaults.setObject(timerarray, forKey: "timerarray")
        alarmDefaults.synchronize()
        
        //if timer and audioPlayer haven't been invalidated/stopped 
        //they need to before we go to another view
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
