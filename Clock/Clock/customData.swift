//
//  customData.swift
//  Clock
//
//  Created by Dennis Wolfe on 8/15/16.
//  Copyright © 2016 Dennis Wolfe. All rights reserved.
//

import UIKit

class customData: NSObject {
    var timerArray = [Timer]()
    var timer = Timer()
    
    
    func saveData(){
        let data = NSKeyedArchiver.archivedDataWithRootObject(timerArray)
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(data, forKey: "")
    }
    
}
