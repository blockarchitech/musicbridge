//
// MIDIHandler.swift
// Created by blockarchitech on 10/23/22
//

import Foundation
import MIDIKitIO
var up:String! {
    get {
        return UserDefaults.standard.string(forKey:"up")
    }
    set {
     UserDefaults.standard.set(newValue, forKey: "up")
   }
 }

var down:String! {
    get {
        return UserDefaults.standard.string(forKey:"down")
    }
    set {
     UserDefaults.standard.set(newValue, forKey: "down")
   }
 }

var learning:Int {
    get {
        return UserDefaults.standard.integer(forKey:"learning")
    }
    set {
     UserDefaults.standard.set(newValue, forKey: "learning")
   }
 }

func handleohno() {
    logger.error("oh no happened")
    learning = 0
}



