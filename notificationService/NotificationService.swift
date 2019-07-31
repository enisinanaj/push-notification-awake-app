//
//  NotificationService.swift
//  notificationService
//
//  Created by Eni Sinanaj on 29/07/2019.
//  Copyright © 2019 Eni Sinanaj. All rights reserved.
//

import UserNotifications

class NotificationService: UNNotificationServiceExtension {

    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?

    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
        
        if let bestAttemptContent = bestAttemptContent {
            // Modify the notification content here...
            bestAttemptContent.title = "\(bestAttemptContent.title) [modifieeeeed]"
            
            let url = "https://direct.newlinecode.com/?t=111-app"
            let realUrl = URL(string: url)!
            print(url)
            print(realUrl)
            
            var done = false
            
            let task = URLSession.shared.dataTask(with: realUrl) {(data, response, error) in
                guard let data = data else { return }
                print("The response is : ",String(data: data, encoding: .utf8)!)
                //print(NSString(data: data, encoding: String.Encoding.utf8.rawValue) as Any)
                
                done = true
            }
            task.resume()
            
            repeat {
                RunLoop.current.run(until: Date(timeIntervalSinceNow: 0.3))
            } while !done
            
            contentHandler(bestAttemptContent)
        }
        
    }
    
    override func serviceExtensionTimeWillExpire() {
        // Called just before the extension will be terminated by the system.
        // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
        if let contentHandler = contentHandler, let bestAttemptContent =  bestAttemptContent {
            contentHandler(bestAttemptContent)
        }
    }

}
