//
//  CommonUtils
//  Bookiverse
//
//  Created by Obed Martinez on 19/12/23
//



import Foundation
import UIKit

final class CommonUtils {
    
    private init() {}
    
    static func alert(message: String, title: String, origin: UIViewController, delay: Double = 1.0) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
            // Code in this block will trigger when OK button tapped.
        }
        alertController.addAction(OKAction)
        DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: {
            origin.present(alertController, animated: true, completion:nil)
        })
    }
    
    static func formatDateString(date:String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        if let date = dateFormatter.date(from: date) {
            let outputDateFormatter = DateFormatter()
            outputDateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            
            let formattedDate = outputDateFormatter.string(from: date)
            
            return formattedDate
        } else {
            return nil
        }
    }
    static func formatDateStringShort(date:String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        if let date = dateFormatter.date(from: date) {
            let outputDateFormatter = DateFormatter()
            outputDateFormatter.dateFormat = "MM-dd"
            
            let formattedDate = outputDateFormatter.string(from: date)
            
            return formattedDate
        } else {
            return nil
        }
    }
}
