//
//  CalculatorModel.swift
//  Calculator
//
//  Created by vlad landa on 01/12/2016.
//  Copyright © 2016 vlad landa. All rights reserved.
//

import Foundation

func multiply(opt1: Double,opt2: Double) -> Double{
    return opt1*opt2
}

class CalculatorModel
{
    private var acc = 0.0
    private var internalProgram =  [AnyObject]()
    
    private var bindingOpt: BindingOperationInfo?
    
    private var operators: Dictionary<String,Operators> = [
        "π" : Operators.Consts(M_PI),//M_PI
        "e" : Operators.Consts(M_E),//M_E
        "√" : Operators.UnaryOp(sqrt),//sqrt
        "cos" : Operators.UnaryOp(cos),
        "*" : Operators.BinaryOp(multiply),
        "/" : Operators.BinaryOp(/),
        "+" : Operators.BinaryOp({$0 + $1}),
        "-" : Operators.BinaryOp(-),
        "=" : Operators.Equals
    ]
    
    private enum Operators {
        case Consts(Double)
        case UnaryOp((Double)->Double)
        case BinaryOp((Double,Double) -> Double)
        case Equals
    }
    
    private func executeBindingOpt(){
        if bindingOpt != nil{
            acc = bindingOpt!.fun(bindingOpt!.oper1,acc)
        }
    }
    
    private struct BindingOperationInfo{
        var fun: (Double,Double)->Double
        var oper1:Double
    }
    
    func setOperand(operand: Double){
        acc = operand
        internalProgram.append(operand as AnyObject)
    }
    
    func performOperation(symbol: String){
        internalProgram.append(symbol as AnyObject)
        if let operation = operators[symbol]{
            switch operation {
            case .Consts(let value):
                acc = value
            case .BinaryOp(let fun):
                executeBindingOpt()
                bindingOpt = BindingOperationInfo(fun: fun,oper1: acc)
            case .UnaryOp(let fun):
                acc = fun(acc)
            case .Equals:
                executeBindingOpt()
            }
        }
    }
    //Creates new type 'PropertyList' same type as AnyObject type, like typedef in c or c++
    typealias PropertyList = AnyObject
    
    var program: PropertyList {
        get{
            return internalProgram as PropertyList
        }
        set{
            clear()
            if let arrOfOps = newValue as? [AnyObject]{
                for op in arrOfOps{
                    if let operand = op as? Double{
                        setOperand(operand: operand)
                    }
                    else if let  operation = op as? String{
                         performOperation(symbol: operation)
                    }
                    
                }
            }
        }
    }
    private func clear(){
        acc = 0.0
        bindingOpt = nil;
        internalProgram.removeAll()
    }
    //by implementing only the "get" it will behave like READ ONLY
    var result: Double {
        get{
            return acc
        }
    }
}
