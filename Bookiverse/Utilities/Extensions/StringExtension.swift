//
//  StringExtension
//  Bookiverse
//
//  Created by Obed Martinez on 20/12/23
//



import Foundation

extension String {
    func stringByStrippingHTML() -> String {
        do {
            let regex = try NSRegularExpression(pattern: "<[^>]+>", options: .caseInsensitive)
            let range = NSMakeRange(0, self.utf16.count)
            return regex.stringByReplacingMatches(in: self, options: [], range: range, withTemplate: "")
        } catch {
            return self
        }
    }
}
