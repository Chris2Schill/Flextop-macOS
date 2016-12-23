//
//  BashShell.swift
//  Flextop
//
//  Created by Chris Schilling on 12/22/16.
//  Copyright © 2016 Chris Schilling. All rights reserved.
//

import Cocoa

class BashShell{
    
    class func executeAndPrint(launchPath: String, arguments: [String]){
        let output = execute(launchPath: launchPath, arguments: arguments)
        print(output)
    }
    
    class func execute(launchPath: String, arguments: [String] = []) -> (String? , Int32) {
        let task = Process()
        task.launchPath = launchPath
        task.arguments = arguments
        
        let pipe = Pipe()
        task.standardOutput = pipe
        task.standardError = pipe
        task.launch()
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: .utf8)
        task.waitUntilExit()

        return (output, task.terminationStatus)
    }
}
