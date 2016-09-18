//
//  globalCounter.swift
//  Clock
//
//  Created by Dennis Wolfe on 8/20/16.
//  Copyright © 2016 Dennis Wolfe. All rights reserved.
//

import UIKit

class globalCounter: NSObject {
    public static let sharedInstance = globalCounter()
    private override init(){}
    public var controllerTimer: NSTimer!
    public var viewTimer: NSTimer!
    
    
}
