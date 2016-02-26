//
//  main.swift
//  RemoveOptimizelyId
//
//  Created by Mijo Gracanin on 15/12/15.
//  Copyright © 2015 Mijo Gracanin. All rights reserved.
//

import Foundation

let processDirectory = NSURL(fileURLWithPath:Process.arguments[0]).URLByDeletingLastPathComponent!.path!
let projectDirectory = Process.arguments.count == 2 ? Process.arguments[1] : processDirectory

let fm = NSFileManager.defaultManager()
let files = fm.subpathsAtPath(projectDirectory)

let regex1 = try NSRegularExpression(pattern:">\\s*<userDefinedRuntimeAttributes>\\s+<.*optimizelyId.*>\\s*<\\/userDefinedRuntimeAttributes>",
    options: NSRegularExpressionOptions(rawValue: 0))

let regex2 = try NSRegularExpression(pattern:">\\s*<userDefinedRuntimeAttribute\\s.*optimizelyId.*\\/>",
    options: NSRegularExpressionOptions(rawValue: 0))

for file in files! {
    let path = projectDirectory + "/" + file
    
    if file.hasPrefix(".") || (!file.hasSuffix(".xib") && !file.hasSuffix(".storyboard")) {
        continue
    }
    
    var content = try String(contentsOfFile: path, encoding:NSUTF8StringEncoding)
    
    content = regex1.stringByReplacingMatchesInString(content,
        options:NSMatchingOptions(rawValue: 0),
        range: NSRange(location: 0, length: content.utf16.count), withTemplate:">")
    
    content = regex2.stringByReplacingMatchesInString(content,
        options:NSMatchingOptions(rawValue: 0),
        range: NSRange(location: 0, length: content.utf16.count), withTemplate:">")
    
    try content.writeToFile(path, atomically: true, encoding:NSUTF8StringEncoding)
}
