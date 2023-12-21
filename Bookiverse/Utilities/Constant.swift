//
//  Constant
//  Bookiverse
//
//  Created by Obed Martinez on 19/12/23
//

import Foundation
import UIKit

// API
let apiURL = "https://www.googleapis.com/books/v1/volumes"

func makeURL(search: String, parameters: [String:String]) -> URL? {
    var baseURL = "\(apiURL)?q=\(search)&"
    let queryItems = parameters.map { (key, value) in
        return "\(key)=\(value)"
    }
    baseURL += queryItems.joined(separator: "&")
    if let url = URL(string: baseURL) {
        return url
    } else {
        return nil
    }
}


// DEVICE
func getDeviceUUID() -> String {
    if let uuid = UIDevice.current.identifierForVendor?.uuidString {
        return uuid
    } else {
        // En caso de que no se pueda obtener el UUID del dispositivo se asigna uno por default
        return "0000"
    }
}

// UX

