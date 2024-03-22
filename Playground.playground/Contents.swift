//: A Cocoa based Playground to present user interface

import Foundation
import SwiftData

import AppKit
import PlaygroundSupport

struct Transaction: CustomStringConvertible {
    var amount: String = ""
    var date: String = ""
    var id: String

    init(amount: String, date: String) {
        self.id = UUID().uuidString
        self.amount = amount
        self.date = date
    }
}

let nibFile = NSNib.Name("MyView")
var topLevelObjects : NSArray?

Bundle.main.loadNibNamed(nibFile, owner:nil, topLevelObjects: &topLevelObjects)
let views = (topLevelObjects as! Array<Any>).filter { $0 is NSView }

// Present the view in Playground
PlaygroundPage.current.liveView = views[0] as! NSView

