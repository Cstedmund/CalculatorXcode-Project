//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Chi Shing Tse on 20/10/2019.
//  Copyright © 2019 EIE. All rights reserved.
//
//EIE3109 Lab 1 Tse Chi Shing 17063375d

import Foundation

private var pendingBinaryOperation: PendingBinaryOperation? = nil;
private var pendingBinaryOperation2: PendingBinaryOperation2? = nil;

private enum Operation {
    case constant(Double)
    case binaryOperation((Double,Double)->Double)
    case binaryOperation2((Double,Double)->Double)
    case trigonometric((Double)->Double)
    case uniary((Double)->Double)
    case equals
    case clear}

private var operations: Dictionary<String, Operation> = [
    "π": Operation.constant(Double.pi),
    "e": Operation.constant(M_E),
    "+": Operation.binaryOperation(add),
    "-": Operation.binaryOperation(sub),
    "*": Operation.binaryOperation2(mul),
    "/": Operation.binaryOperation2(divide),
    "^": Operation.binaryOperation({pow($0,$1)}),
    "sin": Operation.trigonometric(sine),
    "cos": Operation.trigonometric(cosine),
    "log":  Operation.uniary({log10($0)}),
    "ln":  Operation.uniary({log($0)}),
    "=": Operation.equals,
    "c": Operation.clear
    ]

func add(op1:Double, op2:Double) -> Double{return op1+op2;}

func sub(op1:Double, op2:Double) -> Double{return op1-op2}

func mul(op1:Double, op2:Double) -> Double{return op1*op2}

func divide(op1:Double, op2:Double) -> Double{return op1/op2}

func sine(op1:Double) -> Double{return sin(op1*Double.pi/180)}

func cosine(op1:Double) -> Double{return cos(op1*Double.pi/180)}

// for + - * /
private struct PendingBinaryOperation{
    let function: (Double,Double)->Double;
    let firstOperand: Double;
    
    func perform(with secondOperand: Double)->Double {
        return function(firstOperand,secondOperand)}}

private struct PendingBinaryOperation2{
    let function: (Double,Double)->Double;
    let firstOperand: Double;
    
    func perform(with secondOperand: Double)->Double {
        return function(firstOperand,secondOperand)}}

struct CalculatorBrain{
    
    var userIsInTheMiddleOfTyping:Bool = true;
    private var check:Bool = false;
    private var checkout:Bool = false;
    
    private var accumulator: Double?
    
    //for equal
    private mutating func performPendingBinaryOperation(){
        if pendingBinaryOperation != nil && pendingBinaryOperation2 != nil && accumulator != nil && checkout{
            accumulator = pendingBinaryOperation2!.perform(with:accumulator!);
            accumulator = pendingBinaryOperation!.perform(with:accumulator!);
            pendingBinaryOperation = nil;
            pendingBinaryOperation2 = nil;
            userIsInTheMiddleOfTyping = false;
            checkout = false;
        }
        
        else if pendingBinaryOperation == nil && pendingBinaryOperation2 != nil && accumulator != nil{
            accumulator = pendingBinaryOperation2!.perform(with:accumulator!);
            pendingBinaryOperation2 = nil;
            userIsInTheMiddleOfTyping = false;}

        else if (pendingBinaryOperation != nil && pendingBinaryOperation2 == nil && accumulator != nil) {
            accumulator = pendingBinaryOperation!.perform(with: accumulator!);
            pendingBinaryOperation = nil;
            userIsInTheMiddleOfTyping = false;}
        
    }
    
    mutating func performOperation(_ symbol:String){
        if let operation = operations[symbol]{
            switch operation{
            case .constant(let value):
                accumulator = value;
                
            case .binaryOperation(let function):
                if accumulator != nil{
                    if pendingBinaryOperation2 != nil {
                        checkout = true
                        check = true
                    }
                    performPendingBinaryOperation();
                    pendingBinaryOperation = PendingBinaryOperation(function: function,firstOperand:accumulator!);
                    accumulator = nil;
                    userIsInTheMiddleOfTyping = false;
                }
                
            case .binaryOperation2(let function):
                if accumulator != nil{
                    if pendingBinaryOperation2 != nil{
                        check = true;
                        performPendingBinaryOperation();}
                    
                    pendingBinaryOperation2 = PendingBinaryOperation2(function: function, firstOperand: accumulator!);
                    accumulator = nil;
                    userIsInTheMiddleOfTyping = false;
                }
                
            case .trigonometric(let function):
                accumulator = function(accumulator!)
                userIsInTheMiddleOfTyping = false;
            case .uniary(let function):
                accumulator = function(accumulator!)
                userIsInTheMiddleOfTyping = false;
                
            case .equals:
                checkout = true;
                performPendingBinaryOperation();
                
            case .clear:
                accumulator = 0;
                check = false;
                checkout = false;
                pendingBinaryOperation = nil;
                userIsInTheMiddleOfTyping = false;

            }}
    }
    
    mutating func setOperand(_ operand: Double){
        accumulator = operand;
    }
    
    var result: Double?{
        get{return accumulator;}
    }
    
}
