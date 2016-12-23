//
//  DummyControl.swift
//  Flextop
//
//  Created by Chris Schilling on 12/19/16.
//  Copyright © 2016 Chris Schilling. All rights reserved.
//

import Cocoa

class DummyControl: NSControl {

    override func mouseDown(with theEvent: NSEvent){
        superview!.mouseDown(with: theEvent)
        sendAction(action, to: target)
    }
    

}
