//
//  Loader
//  Bookiverse
//
//  Created by Obed Martinez on 20/12/23
//



import Foundation
import UIKit

class Loader {
    private var alertController: UIAlertController?
    
    init() {
        alertController = UIAlertController(title: nil, message: "Cargando...", preferredStyle: .alert)
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.medium
        loadingIndicator.startAnimating()
        alertController?.view.addSubview(loadingIndicator)
    }
    
    func show(in viewController: UIViewController) {
        viewController.present(alertController ?? UIAlertController(), animated: true, completion: nil)
    }
    
    func hide() {
        alertController?.dismiss(animated: true, completion: nil)
    }
}
