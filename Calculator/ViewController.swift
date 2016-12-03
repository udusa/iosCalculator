//
//  ViewController.swift
//  Calculator
//
//  Created by vlad landa on 29/11/2016.
//  Copyright © 2016 vlad landa. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var userIsTyping: Bool = false
    
    @IBOutlet weak private var display: UILabel!
    
    private var calculator: CalculatorModel = CalculatorModel()
    
    //new type of value that represent whats going on on the display in a convenient way
    private var displayValue: Double{
        get{
            return Double(display.text!)!
        }
        set{
            display.text = String(newValue)
        }
    }

    @IBAction private func btnClicked(_ sender: UIButton) {
        let digit = sender.currentTitle!
        print("Clicked Digit : \(digit)")
        let displayText = display.text!
        if userIsTyping {
            display.text = displayText + digit
        }else{
            display.text = digit
        }
        userIsTyping = true
    }


    @IBAction private func mathAction(_ sender: UIButton) {
        if userIsTyping {
            calculator.setOperand(operand: displayValue)
            userIsTyping = false
        }
        if let mathSymbol = sender.currentTitle{
            calculator.performOperation(symbol: mathSymbol)
        }
        displayValue = calculator.result
    }
    var savedProgram: CalculatorModel.PropertyList?
    @IBAction func save() {
        savedProgram = calculator.program
    }
    
    @IBAction func restore() {
        if savedProgram != nil{
            calculator.program = savedProgram!
            displayValue = calculator.result
        }
    }
    
    
}

