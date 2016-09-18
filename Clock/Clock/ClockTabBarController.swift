//
//  ClockTabBarController.swift
//  Clock
//
//  Created by Seth Wolfe on 8/8/16.
//  Copyright © 2016 Seth Wolfe. All rights reserved.
//

import UIKit

class ClockTabBarController: UITabBarController {

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func addClockButtonPressed(sender: AnyObject) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        self.tabBar.items![0].title = "Stopwatch"
        if self.tabBar.selectedItem! == self.tabBar.items![1] {
         
            let destination2 = storyboard.instantiateViewControllerWithIdentifier("timerViewController")
            presentViewController(destination2, animated: true, completion: nil)
            
        } else if self.tabBar.selectedItem! == self.tabBar.items![2] {
  
            let destination = storyboard.instantiateViewControllerWithIdentifier("alarmViewController")
            presentViewController(destination, animated: true, completion: nil)
        }
    
    }
}
