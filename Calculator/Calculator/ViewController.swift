//
//  ViewController.swift
//  Calculator
//
//  Created by Chi Shing Tse on 20/10/2019.
//  Copyright © 2019 EIE. All rights reserved.
//
//EIE3109 Lab 1 Tse Chi Shing 17063375d

import UIKit

class ViewController: UIViewController {
    
    var userIsInTheMiddleOfTyping = false;
    
    var displayValue: Double{
        get{return Double(display.text!)!;}
        set{display.text = String(newValue)}}
    
    private var brain = CalculatorBrain();
    
    
    @IBOutlet weak var display: UILabel!
    
    @IBAction func digitPress(_ sender: UIButton) {
        let digit = sender.currentTitle!;
        let originalText = display.text!;
        if userIsInTheMiddleOfTyping == false {
            display.text = digit;
            userIsInTheMiddleOfTyping = true;
        }else{display.text = originalText + digit;}
        
        print("\(digit) digit pressed");
    }
    
    
    @IBAction func operationPressed(_ sender: UIButton) {
        
        if userIsInTheMiddleOfTyping{
            brain.setOperand(displayValue);
            userIsInTheMiddleOfTyping = false;}
        
        if let operation = sender.currentTitle{
            brain.performOperation(operation);
            userIsInTheMiddleOfTyping = brain.userIsInTheMiddleOfTyping;
        }
        
        if let result = brain.result{
            displayValue = result;
            //displayWatch1 = brain.accumulatorBuffer!;
            //displayWatch2 = brain.accumulatorBuffer2!;
            userIsInTheMiddleOfTyping = brain.userIsInTheMiddleOfTyping;
        }
        
        /*userIsInTheMiddleOfTyping = false;
        }*/
    }
    
    
    
    
    
}

