//
//  ViewController.swift
//  gd-tip-calculator
//
//  Created by USER on 9/17/15.
//  Copyright © 2015 USER. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var billField: UITextField!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var tipPercentageControl: UISegmentedControl!
    
    @IBOutlet weak var borderView: UIView!
    
    
    let defaults = NSUserDefaults.standardUserDefaults()
    let formatter = NSNumberFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        billField.becomeFirstResponder()
        borderView.layer.borderWidth = 1
        initializeLabels()
        initializeColorTheme()
        clearOldSavedAmount()
        initializeBillField()
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let defaultIndex = defaults.integerForKey("defaultTipPercentageControlIndex")
        tipPercentageControl.selectedSegmentIndex = defaultIndex
        let (tipAmount,totalAmount) = calculateAmounts()
        updateLabels(tipAmount,totalAmount: totalAmount)
        updateColorTheme()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onEditingChanged(sender: AnyObject) {
        let (tipAmount,totalAmount) = calculateAmounts()
        updateLabels(tipAmount,totalAmount: totalAmount)
        if billField.text == "" {
            billField.text = formatter.currencySymbol
        }
    }
    @IBAction func onTap(sender: AnyObject) {
        view.endEditing(true)
    }
    
    func calculateAmounts() -> (Double, Double){
        let tipPercentages = [0.18, 0.20, 0.22]
        let tipPercentage = tipPercentages[tipPercentageControl.selectedSegmentIndex]
        
        let billAmountText = billField.text!.stringByReplacingOccurrencesOfString(formatter.currencySymbol, withString: "")
        let billAmountTextWithoutComma = billAmountText.stringByReplacingOccurrencesOfString(",", withString: "")
        let billAmount = billAmountTextWithoutComma._bridgeToObjectiveC().doubleValue
        defaults.setDouble(billAmount, forKey: "savedBillAmount")
    
        defaults.setObject(NSDate(), forKey: "lastCachedAt")
        defaults.synchronize()
        let tipAmount = billAmount * tipPercentage
        let totalAmount = billAmount + tipAmount
        return (tipAmount,totalAmount)
    }
    
    func updateLabels(tipAmount: Double, totalAmount: Double){
        tipLabel.text = formatter.stringFromNumber(tipAmount)
        totalLabel.text =   formatter.stringFromNumber(totalAmount)
    }
    
    func updateColorTheme(){
        let colorTheme = defaults.objectForKey("defaultColorTheme") as! String
//        Note: can't figure out how to change the color segmented control on theme editing changed. Requires you to leave the view.
        var borderColor = UIColor.blueColor().CGColor
        switch colorTheme{
        case "spider-man":
            self.view.backgroundColor = UIColor(red: 0.80, green: 0.19, blue: 0, alpha: 1)
            UISegmentedControl.appearance().tintColor = UIColor(red: 0.13, green:0.13, blue: 0.67, alpha: 1)
            borderColor = UIColor(red: 0.13, green:0.13, blue: 0.67, alpha: 1).CGColor
        case "hulk":
            self.view.backgroundColor = UIColor(red: 0.55, green: 0.61, blue: 0.23, alpha: 1)
            UISegmentedControl.appearance().tintColor = UIColor.purpleColor()
            borderColor = UIColor.purpleColor().CGColor
        default:
            self.view.backgroundColor = UIColor(red: 0.8, green: 0.96, blue: 0.93, alpha: 1)
            UISegmentedControl.appearance().tintColor = UIColor.blueColor()
        }
        if borderView != nil {
            borderView.layer.borderColor = borderColor
        }
    }
    
    func initializeLabels(){
        tipLabel.text   = formatter.stringFromNumber(0)
        totalLabel.text = formatter.stringFromNumber(0)
    }

    
    func initializeColorTheme(){
        if defaults.objectForKey("defaultColorTheme") == nil {
            defaults.setObject("default", forKey: "defaultColorTheme")
        }
    }
    
    func clearOldSavedAmount(){
        let tenMinAgo = NSDate().dateByAddingTimeInterval(-60*10)
        if let lastCachedAt = defaults.objectForKey("lastCachedAt"){
            let lastCachedAt = lastCachedAt as! NSDate
            if tenMinAgo.earlierDate(lastCachedAt) == lastCachedAt || defaults.integerForKey("savedBillAmount") == 0 {
                defaults.setObject(nil, forKey: "savedBillAmount")
                defaults.synchronize()
            }
        }
    }
    
    func initializeBillField(){
        formatter.numberStyle = .CurrencyStyle
        let savedBillAmount = defaults.objectForKey("savedBillAmount")
        if savedBillAmount == nil {
            billField.text = formatter.currencySymbol
        }else{
            billField.text  = formatter.stringFromNumber(savedBillAmount as! Double)
        }
    }


}

