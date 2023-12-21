//
//  ViewController
//  Bookiverse
//
//  Created by Obed Martinez on 18/12/23
//



import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        home(self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goHome" {
            guard segue.destination is HomeTableViewController else {return}
        }
    }

    @IBAction func home(_ sender: Any) {
        self.performSegue(withIdentifier: "goHome", sender: self)
    }
    
}

