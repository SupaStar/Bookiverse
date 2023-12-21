//
//  RegisterViewController
//  Bookiverse
//
//  Created by Obed Martinez on 21/12/23
//



import UIKit
import FirebaseAuth


class RegisterViewController: UIViewController {

    @IBOutlet weak var registerBtn: UIButton!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passwordConfirmTxt: UITextField!
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var passwordConfirmView: UIView!
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var showHidePasswordBtn: UIButton!
    @IBOutlet weak var showHidePasswordConfirmBtn: UIButton!
    
    // MARK: INJECTIONS
    let loader = Loader()
    let configurationImage = UIImage.SymbolConfiguration(pointSize: 14)
    var isHidePass = true
    var isHidePassConfirm = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.isNavigationBarHidden = false
        
        self.setupInputs()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
            view.addGestureRecognizer(tapGesture)
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func setupInputs() {
        let borderColor = UIColor.lightGray.cgColor
        
        applyBorderStyle(to: emailView, with: borderColor)
        applyBorderStyle(to: passwordView, with: borderColor)
        applyBorderStyle(to: passwordConfirmView, with: borderColor)
        
        configureShowHideButton(self.showHidePasswordBtn)
        configureShowHideButton(self.showHidePasswordConfirmBtn)
        
        applyCornerRadius(to: emailTxt)
        applyCornerRadius(to: passwordTxt)
    }

    func applyBorderStyle(to view: UIView, with color: CGColor) {
        view.layer.borderWidth = 0.5
        view.layer.borderColor = color
        view.layer.cornerRadius = 10
    }

    func configureShowHideButton(_ button: UIButton) {
        button.setImage(UIImage(systemName: "eye.fill", withConfiguration: configurationImage), for: .normal)
    }

    func applyCornerRadius(to textField: UITextField) {
        textField.layer.cornerRadius = 10
    }

    @IBAction func register(_ sender: Any) {
        guard let email = emailTxt.text, let password = passwordTxt.text else {
            CommonUtils.alert(message: "Todos los campos son requeridos.", title: "Advertencia", origin: self, delay: 0)
            return
        }
        if email == "" || password == "" {
            CommonUtils.alert(message: "Todos los campos son requeridos.", title: "Advertencia", origin: self, delay: 0)
            return
        }
        if !email.isValidEmail(){
            CommonUtils.alert(message: "El correo electrónico no es válido.", title: "Advertencia", origin: self, delay: 0)
            return
        }
        
        if passwordTxt.text != passwordConfirmTxt.text {
            CommonUtils.alert(message: "Las contraseñas no coinciden.", title: "Advertencia", origin: self, delay: 0)
            return
        }
        loader.show(in: self)
        Auth.auth().createUser(withEmail: email, password: password){ authResult, error in
            guard error == nil else {
                CommonUtils.alert(message: "\(error!.localizedDescription)", title: "Error", origin: self, delay: 0)
                return
            }
            self.loader.hide()
            self.closeView()
        }
    }

    
    func closeView() {
        let alert = UIAlertController(title: "Éxito", message: "Usuario creado exitosamente. Por favor, inicia sesión.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Acción predeterminada"), style: .default, handler: { _ in
            _ = self.navigationController?.popViewController(animated: true)
        }))
        self.present(alert, animated: true, completion: nil)
    }

    
    @IBAction func showHidePassword(_ sender: Any) {
        togglePasswordVisibility(isHidePass: &isHidePass, button: showHidePasswordBtn, textField: passwordTxt)
    }

    @IBAction func showHidePasswordConfirm(_ sender: Any) {
        togglePasswordVisibility(isHidePass: &isHidePassConfirm, button: showHidePasswordConfirmBtn, textField: passwordConfirmTxt)
    }

    func togglePasswordVisibility(isHidePass: inout Bool, button: UIButton, textField: UITextField) {
        isHidePass.toggle()
        let imageName = isHidePass ? "eye.fill" : "eye.slash.fill"
        button.setImage(UIImage(systemName: imageName, withConfiguration: configurationImage), for: .normal)
        textField.isSecureTextEntry = isHidePass
    }
}
