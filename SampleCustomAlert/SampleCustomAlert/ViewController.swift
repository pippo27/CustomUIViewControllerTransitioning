//
//  ViewController.swift
//  SampleCustomAlert
//
//  Created by Arthit Thongpan on 10/31/15.
//  Copyright © 2015 Arthit Thongpan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func showAlert(sender: AnyObject) {
        
        let movieDetailAlertViewController = self.storyboard?.instantiateViewControllerWithIdentifier("MovieDetailAlertViewController") as! MovieDetailAlertViewController        
        movieDetailAlertViewController.view.tintColor = self.view.tintColor
        //movieDetailAlertViewController.closeButton.addTarget(self, action: "onCloseButtonClicked:", forControlEvents: .TouchUpInside)
        
        
        self.presentViewController(movieDetailAlertViewController, animated: true, completion: nil)
        

        
    }
    
    func onCloseButtonClicked(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

