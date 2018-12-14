//
//  ApplicationConstants.swift
//  Runner
//
//  Created by 创客工场 on 2018/12/13.
//  Copyright © 2018年 The Chromium Authors. All rights reserved.
//

import Foundation

struct ApplicationConstants {
    
    static let ResourceId  = "https://graph.microsoft.com"
    static let kAuthority  = "https://login.microsoftonline.com/common"
    static let kGraphURI   = "https://graph.microsoft.com/v1.0/me/"
    static let kScopes: [String] = ["https://graph.microsoft.com/Files.ReadWrite","https://graph.microsoft.com/User.Read","https://graph.microsoft.com/Files.ReadWrite.AppFolder"]
    
    /**
     Simple construct to encapsulate NSError. This could be expanded for more types of graph errors in future.
     */
    enum MSGraphError: Error {
        case nsErrorType(error: NSError)
        
    }
    
}
