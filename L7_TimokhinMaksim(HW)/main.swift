//
//  main.swift
//  L7_TimokhinMaksim(HW)
//
//  Created by Максим Тимохин on 07.08.2020.
//  Copyright © 2020 Максим Тимохин. All rights reserved.
//

import Foundation

//1. Придумать класс, методы которого могут создавать непоправимые ошибки. Реализовать их с помощью try/catch.
//
//2. Придумать класс, методы которого могут завершаться неудачей. Реализовать их с использованием Error.

struct Product {
    let name: String
}

struct Item {
    var price: Int
    var volume: Int
    var product: Product
    
}
//
enum RefuelingError: Error {
    case invalidSelection
    case outOfStock
    case insufficientFunds(coinsNeeded: Int)
}
class Refueling {
    private var inventory = [
        "Propane": Item(price: 100, volume: 1000, product: Product(name: "Propane")),
        "Petrol": Item(price: 100, volume: 1000, product: Product(name: "Petrol")),
        "Diesel fuel": Item(price: 100, volume: 1000, product: Product(name: "Diesel fuel"))
    ]
    var coinsDeposited = 0
    
    func vend(itemNamed name: String) throws -> Product {
        guard let item = inventory[name] else {
            throw RefuelingError.invalidSelection
        }
        guard item.volume > 0 else {
            throw RefuelingError.outOfStock
        }
        guard item.price <= coinsDeposited else {
            throw RefuelingError.insufficientFunds(coinsNeeded: item.price - coinsDeposited)
        }
        
        coinsDeposited -= item.price
        var newItem = item
        newItem.volume -= 1
        inventory[name] = newItem
        
        print("Returing \(name)")
        return newItem.product
    }
    func buyFavourite() throws -> Product {
        return try vend(itemNamed: "Petrol")
    }
}

let refueling = Refueling()

do { // так делать правильнее всего!
    refueling.coinsDeposited = 200
    try refueling.vend(itemNamed: "Petrol")
}
catch RefuelingError.invalidSelection {
    print("Нет такого вида топлива")
}
catch RefuelingError.outOfStock {
    print("Данный вид топлива закончился")
}
catch RefuelingError.insufficientFunds(let needed) {
    print("Недостаточно денег нужно еще \(needed) денег")
}
catch let error {
    print(error.localizedDescription)
}
