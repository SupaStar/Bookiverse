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
    
    func isValidEmail() -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: self)
    }
}
