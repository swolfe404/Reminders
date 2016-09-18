//
//  Alarm.swift
//  Clock
//
//  Created by Seth Wolfe on 8/15/16.
//  Copyright © 2016 Seth Wolfe. All rights reserved.
//

import UIKit
@objc
class Alarm: NSObject, NSCoding {
    
    var hour: Int
    var minute: Int
    var name: NSString
    var note: NSString
    var wasTapped = false
    
    override init() {
        hour = 0
        minute = 0
        name = ""
        note = ""
        wasTapped = false
        super.init()
    }
    
    init(hour: Int, minute: Int, name: NSString, note: NSString, wasTapped: Bool){
        self.hour = hour
        self.minute = minute
        self.name = name
        self.note = note
        self.wasTapped = wasTapped
    }
    
    
    public required convenience init?(coder aDecoder: NSCoder) {
        
        let hour = aDecoder.decodeIntegerForKey("hour")
        let minute = aDecoder.decodeIntegerForKey("minute")
        let name = aDecoder.decodeObjectForKey("name") as! String
        let note = aDecoder.decodeObjectForKey("note") as! String
        let wasTapped = aDecoder.decodeObjectForKey("wasTapped") as! Bool
        
        self.init(hour: hour, minute: minute, name: name, note: note, wasTapped: wasTapped)
        
    }
    
    internal func encodeWithCoder(aCoder: NSCoder) {
        
        aCoder.encodeInteger(self.hour, forKey: "hour")
        aCoder.encodeInteger(self.minute, forKey: "minute")
        aCoder.encodeObject(self.name, forKey: "name")
        aCoder.encodeObject(self.note, forKey: "note")
        aCoder.encodeObject(self.wasTapped, forKey: "wasTapped")
    }
    
    func clearAlarm(alarm: Alarm){
        self.hour = 0
        self.minute = 0
        self.name = ""
        self.note = ""
        self.wasTapped = false
    }

}
