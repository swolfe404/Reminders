//
//  Timer.swift
//  Clock
//
//  Created by Seth Wolfe on 8/14/16.
//  Copyright © 2016 Seth Wolfe. All rights reserved.
//

import UIKit

@objc
protocol TimerDelegate{
    func timerCompleted(timer: Timer)
}

public class Timer: NSObject, NSCoding {
    
    weak var delegate:TimerDelegate?
    var hour: Int
    var minute: Int
    var name: NSString
    var note: NSString
    var seconds: Int
    var complete = false
    
    override init() {
        hour = 0
        minute = 0
        name = ""
        note = ""
        seconds = 0
        complete = false
        super.init()
    }
    
    init(hour: Int, minute: Int, name: NSString, note: NSString, seconds: Int, complete: Bool){
        self.hour = hour
        self.minute = minute
        self.name = name
        self.note = note
        self.seconds = seconds
        self.complete = complete
    }
    
    public required convenience init?(coder aDecoder: NSCoder) {
        
        let hour = aDecoder.decodeIntegerForKey("hour")
        let minute = aDecoder.decodeIntegerForKey("minute")
        let name = aDecoder.decodeObjectForKey("name") as! String
        let note = aDecoder.decodeObjectForKey("note") as! String
        let seconds = aDecoder.decodeObjectForKey("seconds") as! Int
        let complete = aDecoder.decodeObjectForKey("complete") as! Bool
        
        self.init(hour: hour, minute: minute, name: name, note: note, seconds: seconds, complete: complete)
        
    }
    
    public func encodeWithCoder(aCoder: NSCoder) {

        aCoder.encodeInteger(self.hour, forKey: "hour")
        aCoder.encodeInteger(self.minute, forKey: "minute")
        aCoder.encodeObject(self.name, forKey: "name")
        aCoder.encodeObject(self.note, forKey: "note")
        aCoder.encodeObject(self.seconds, forKey: "seconds")
        aCoder.encodeObject(self.complete, forKey: "complete")
    }
    
    func update(){
        self.seconds += 1
        print(seconds)
        if(self.seconds == 60){
            self.seconds = 0
            self.minute -= 1
            
            //the <= is here to catch any errors, if everything has acted correctly then minutes
            //should never be below zero
            if(self.minute <= 0 && self.hour > 0){
                self.hour -= 1
                self.minute = 59
            }
        }
        if(self.minute <= 0 && self.hour == 0){
            self.complete = true
            self.delegate?.timerCompleted(self)
      
    }

}
}

