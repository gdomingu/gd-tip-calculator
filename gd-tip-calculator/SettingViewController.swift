//
//  SettingViewController.swift
//  gd-tip-calculator
//
//  Created by USER on 9/19/15.
//  Copyright © 2015 USER. All rights reserved.
//

import UIKit

class SettingViewController: ViewController {

    @IBOutlet weak var defaultPercentageControl: UISegmentedControl!
    @IBOutlet weak var defaultColorThemeControl: UISegmentedControl!
    
    @IBOutlet weak var backButton: UIBarButtonItem!
    
    let colorThemes = ["default", "spider-man", "hulk"]
    override func viewDidLoad() {
//        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(animated: Bool) {
//        super.viewWillAppear(animated)
        let defaultIndex = defaults.integerForKey("defaultTipPercentageControlIndex")
        let defaultTheme = defaults.objectForKey("defaultColorTheme") as! String
        defaultColorThemeControl.selectedSegmentIndex = colorThemes.indexOf(defaultTheme)!
        defaultPercentageControl.selectedSegmentIndex = defaultIndex
        updateColorTheme()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onBackClick(sender: AnyObject) {
        print("foo")
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func onSettingEditingChanged(sender: AnyObject) {
        let defaultIndex = defaultPercentageControl.selectedSegmentIndex
        defaults.setInteger(defaultIndex, forKey: "defaultTipPercentageControlIndex")
        defaults.synchronize()
    }
    
    @IBAction func onThemeEditingChanged(sender: UISegmentedControl) {
            let colorTheme = colorThemes[defaultColorThemeControl.selectedSegmentIndex]
            defaults.setObject(colorTheme, forKey: "defaultColorTheme")
            updateColorTheme()
    }

}
