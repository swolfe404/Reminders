//
//  StopWatchViewController.swift
//  Clock
//
//  Created by Seth Wolfe on 8/8/16.
//  Copyright © 2016 Seth Wolfe. All rights reserved.
//

import UIKit

class StopWatchViewController: UIViewController {
    

    @IBOutlet weak var resetOutlet: UIButton!
    var timer: NSTimer!
    var startPressed = false;
    var startHour = ""
    var startMinute = ""
    var startSecond = ""
    var currentTime = ""
    var difference = 0
    var difference2 = 0
    var difference3 = 0

    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var label3: UILabel!

    
    //Set all of the differences to 0
    @IBAction func resetButton(sender: UIButton) {
        difference = 0
        difference2 = 0
        difference3 = 0
        
    }
    
    @IBAction func startButton(sender: UIButton) {

        //If start has been pressed switch the the title to stop
        //else switch the title to start
        
        if(!startPressed){
            sender.setTitle("Stop", forState: .Normal)
            startPressed = true
            
        }else{
            sender.setTitle("Start", forState: .Normal)
            startPressed = false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(startPressed){
            resetOutlet.enabled = true
        }
        
    }
    
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        //if we haven't disposed of every timer we should get rid of it before we declare another one
        timer?.invalidate()
        
        timer = NSTimer(fireDate: NSDate(), interval: 1, target: self, selector: #selector(update), userInfo: nil, repeats: true)
        NSRunLoop.mainRunLoop().addTimer(timer, forMode: NSDefaultRunLoopMode)
        
        //hides the navigation bar permanently
        self.navigationController?.navigationBarHidden = true
    }
    
    
    
    
    func update(){
        if(startPressed){
            difference += 1
            if(label.text! == "59"){
                difference = 0
                difference2 += 1
            }
            if(label2.text! == "59"){
                difference2 = 0
                difference3 += 1
            }
        }
        if difference >= 10
        {
            label.text = "\(difference)"
        }
        else
        {
            label.text = "0\(difference)"
        }
        if difference2 >= 10
        {
            label2.text = "\(difference2)"
        }
        else
        {
            label2.text = "0\(difference2)"
        }
        if difference3 >= 10
        {
            label3.text = "\(difference3)"
        }
        else
        {
            label3.text = "0\(difference3)"
        }
    }
    
}
