//
//  AppDelegate.swift
//  Lyricsify
//
//  Created by Mohamad Jahani on 11/22/16.
//  Copyright © 2016 Mohamad Jahani. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    let popover = NSPopover()
    let statusItem = NSStatusBar.system().statusItem(withLength: NSVariableStatusItemLength)
    var eventMonitor: EventMonitor?

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        statusItem.image = #imageLiteral(resourceName: "StatusIcon")
        statusItem.toolTip = "Lyricsify"
        popover.contentViewController = LyricsViewController(
            nibName: "LyricsViewController",
            bundle: nil
        )
        popover.behavior = .transient

        if let button = statusItem.button {
            button.action = #selector(self.togglePopover(sender:))
            button.sendAction(on: [.leftMouseUp, .rightMouseUp])
        }

        eventMonitor = EventMonitor(mask: [.leftMouseDown, .leftMouseUp]) { event in
            if self.popover.isShown {
                self.closePopover(sender: event)
            }
        }
        eventMonitor?.start()
    }

    func showPopover(sender: AnyObject?) {
        if let button = statusItem.button {
            popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
        }
        eventMonitor?.start()
    }

    func closePopover(sender: AnyObject?) {
        popover.performClose(sender)
        eventMonitor?.stop()
    }

    @objc func togglePopover(sender: AnyObject?) {
        if popover.isShown {
            closePopover(sender: sender)
        } else {
            showPopover(sender: sender)
        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
}
