//
//  AppDelegate.swift
//  Flextop
//
//  Created by Chris Schilling on 12/19/16.
//  Copyright © 2016 Chris Schilling. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, NSPopoverDelegate{

    static let statusItem: NSStatusItem = NSStatusBar.system().statusItem(withLength: 24)
    static var popover: NSPopover = NSPopover()
    static var popoverMonitor: Any?
 
    override init(){
        super.init()
        AppDelegate.popover.contentViewController = PopupViewController()
        setupStatusButton()
    }
    
    func setupStatusButton(){
        if let statusButton = AppDelegate.statusItem.button {
            statusButton.image = NSImage(named: "Status")
            statusButton.alternateImage = NSImage(named: "StatusHighlighted")
            
            let dummyControl = DummyControl()
            dummyControl.frame = statusButton.bounds
            statusButton.addSubview(dummyControl)
            //statusButton.superview!.subviews = [statusButton, dummyControl]
            dummyControl.action = #selector(AppDelegate.onPress)
            dummyControl.target = self
        }
    }

    func onPress(sender: Any){
        if AppDelegate.popover.isShown == false{
            AppDelegate.openPopover()
        }else{
            AppDelegate.closePopover()
        }
    }
    
    class func openPopover(){
        if let statusButton = statusItem.button {
            statusButton.highlight(true)
            AppDelegate.popover.show(relativeTo: NSZeroRect, of: statusButton, preferredEdge: NSRectEdge.minY)
            AppDelegate.popoverMonitor = NSEvent.addGlobalMonitorForEvents(matching: .leftMouseDown, handler: { (event: NSEvent!) -> Void in AppDelegate.closePopover()})
            let window = AppDelegate.popover.contentViewController?.view.window
            window?.parent?.removeChildWindow(window!)
            
        }
    }
    
    class func closePopover(){
        AppDelegate.popover.close()
        if let statusButton = AppDelegate.statusItem.button {
            statusButton.highlight(false)
        }
        if let monitor : Any = AppDelegate.popoverMonitor {
            NSEvent.removeMonitor(monitor)
            AppDelegate.popoverMonitor = nil
        }
    }
    

}

