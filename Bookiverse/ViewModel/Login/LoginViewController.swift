//
//  LoginViewController
//  Bookiverse
//
//  Created by Obed Martinez on 21/12/23
//



import UIKit
import FirebaseAnalytics
import FirebaseCore
import GoogleSignIn
import FirebaseAuth
import LocalAuthentication

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var biometricsBtn: UIButton!
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var loginGoogleBtn: GIDSignInButton!
    @IBOutlet weak var eyeBtn: UIButton!
    
    // MARK: Variables
    let loader = Loader()
    var delay = 0.0
    var isHidePass = true
    let configurationImage = UIImage.SymbolConfiguration(pointSize: 14)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Inicio de sesión"
        
        setupInputs()
    }
    
    func setupInputs() {
        configureView(emailView)
        configureView(passwordView)
        configureTextField(emailTxt)
        configureTextField(passwordTxt)
        configureButton(loginBtn, cornerRadius: 10)
        loginGoogleBtn.layer.cornerRadius = 20
        configureEyeButton()
        checkBiometricsAvailability()
    }

    func configureView(_ view: UIView) {
        let borderColor = UIColor.lightGray.cgColor
        view.layer.borderWidth = 0.5
        view.layer.borderColor = borderColor
        view.layer.cornerRadius = 10
    }

    func configureTextField(_ textField: UITextField) {
        textField.layer.cornerRadius = 10
    }

    func configureButton(_ button: UIButton, cornerRadius: CGFloat) {
        button.layer.cornerRadius = cornerRadius
    }

    func configureEyeButton() {
        self.eyeBtn.setImage(UIImage(systemName: "eye.fill", withConfiguration: configurationImage), for: .normal)
    }

    func checkBiometricsAvailability() {
        if UserDefaults.standard.string(forKey: UserDefaultEnum.logedBefore.rawValue) != nil {
            let context = LAContext()
            var error: NSError?
            
            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
                self.biometricsBtn.isHidden = false
            }
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goHome" {
            guard segue.destination is HomeTableViewController else {return}
        } else if segue.identifier == "register" {
            guard segue.destination is RegisterViewController else {return}
        }
    }

    @IBAction func loginWithEmail(_ sender: Any) {
        loader.show(in: self)
        // Validations
        guard let email = emailTxt.text, let password = passwordTxt.text else {
            CommonUtils.alert(message: "Todos los campos son requeridos.", title: "Warning", origin: self, delay: 0)
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
        
        Auth.auth().signIn(withEmail: email, password: password){ [weak self] authResult, error in
            guard let strongSelf = self else { return }
            
            if let error = error {
                self?.showAlert(message: "\(error.localizedDescription)", title: "Error al iniciar sesión")
            }
            strongSelf.goHome(id: authResult?.user.uid ?? "")
        }
    }
    
    @IBAction func loginAnon(_ sender: Any) {
        Auth.auth().signInAnonymously { [weak self] authResult, error in
            guard let strongSelf = self else { return }
            if let error = error {
                self?.showAlert(message: "\(error.localizedDescription)", title: "Error al iniciar sesión")
            }
            strongSelf.goHome(id: authResult?.user.uid ?? "")
        }
    }
    
    @IBAction func googleSignIn(_ sender: Any) {
        loader.show(in: self)
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        // Start the sign in flow!
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { [unowned self] result, error in
            guard error == nil else {
                loader.hide()
                return
            }
            
            guard let user = result?.user,
                  let idToken = user.idToken?.tokenString
            else {
                return
            }
            Analytics.logEvent("Login con Google", parameters: ["user":"\(user)"])
            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                           accessToken:
                                                            user.accessToken.tokenString)
            Auth.auth().signIn(with: credential)
            self.goHome(id: user.userID ?? "")
        }
    }
    
    @IBAction func loginWithBiometrics(_ sender: Any) {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Por favor autentica con Face ID para continuar."
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { (success, error) in
                if success {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                        self.performSegue(withIdentifier: "goToHome", sender: self)
                    })
                } else {
                    if let error = error as? LAError {
                        CommonUtils.alert(message: error.localizedDescription, title: "Error", origin: self, delay: 0)
                    }
                }
            }
        }
    }
    
    func goHome(id: String){
        UserDefaults.standard.set(id, forKey: UserDefaultEnum.idUser.rawValue)
        loader.hide()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            self.performSegue(withIdentifier: "goToHome", sender: self)
        })
    }
    
    @IBAction func showHidePass(_ sender: Any) {
        self.isHidePass.toggle()
        let imageName = self.isHidePass ? "eye.fill" : "eye.slash.fill"
        self.eyeBtn.setImage(UIImage(systemName: imageName, withConfiguration: configurationImage), for: .normal)
        self.passwordTxt.isSecureTextEntry = self.isHidePass
    }
    
    @IBAction func register(_ sender: Any) {
        self.performSegue(withIdentifier: "register", sender: self)
    }
    
    func showAlert(message:String, title: String){
        CommonUtils.alert(message: message, title: title, origin: self, delay: 0)
    }
}
