//
//  ViewController.swift
//  swata
//
//  Created by imps on 1/9/21.
//  Copyright © 2021 imps. All rights reserved.
//

import UIKit
import SystemConfiguration
import SystemConfiguration.CaptiveNetwork
import NetworkExtension

@available(iOS 13.0, *)
class ViewController: urlRequestViewController, UITextFieldDelegate{
    
    
    @IBOutlet weak var btnsCons: NSLayoutConstraint!
//    @IBOutlet weak var btns: UIView!
//    var result1: Any?
//    var code: String?
    @IBOutlet weak var mainView: UIScrollView!
//    let httpReq = urlRequest()
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var pass: UITextField!
    @IBOutlet weak var confirmPass: UITextField!
    @IBOutlet weak var bluebtn: UIButton!
    @IBOutlet weak var whitebtn: UIButton!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.URLData = [urlDataFull]()
        self.email.delegate = self as UITextFieldDelegate
        self.pass.delegate = self as UITextFieldDelegate
        self.confirmPass.delegate = self as UITextFieldDelegate
        keyboardHide()
        logINView()
        mainView.layer.cornerRadius = 8
        indicatorView.transform = CGAffineTransform.init(scaleX: 2, y: 2)
        indicatorView.color = UIColor(rgb: 0x2667BF)
        loadingOut()
        bluebtn.setTitle("LOG IN", for: .normal)
        whitebtn.setTitle("REGISTER", for: .normal)
        confirmPass.isHidden = true
        
    }
    @objc func tap(sender: UITapGestureRecognizer){
         view.endEditing(true)
     }
    @objc func adjustForKeyboard(notification: Notification) {
           guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
           let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = self.view.convert(keyboardScreenEndFrame, from: self.view.window)

           if notification.name == UIResponder.keyboardWillHideNotification {
               mainView.contentInset = .zero
           } else {
            mainView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - self.view.safeAreaInsets.bottom, right: 0)
           }

           mainView.scrollIndicatorInsets = mainView.contentInset

       }
    
    func keyboardHide(){
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap)))
    }
    
    override func viewDidAppear(_ animated: Bool) {
 
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    @IBAction func blueAction(_ sender: Any) {
        if bluebtn.titleLabel?.text == "LOG IN"{
            logINView()
            loadingIn()
            URLfunc(email :email.text!, pass: pass.text!, url: "http://pet-me.me/water/login.php", code: "")
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                self.proccedLogIn()
            }
//        }
        }else if bluebtn.titleLabel?.text == "REGISTER"{
            regView()
            loadingIn()
            if pass.text == confirmPass.text{
                URLfunc(email :email.text!, pass: pass.text!, url: "http://pet-me.me/water/register.php", code: "")
//              DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
//                    let msgCode = String(describing: self.httpReq.msgcode)
                
                
//                print("msgcode2 = \(msgCode)")
//                if msgCode == "Optional(1)"{
////                    let result2 = String(describing: self.httpReq.logInId)
//                    
//                    print("success: \(result2)")
//                    self.AlertVerif(text: "code sent, check your mail")
//                    self.loadingOut()
//                }else if msgCode == "Optional(-1)"{
//                       self.Alert(msg:"Missing Fields")
//                    }else if msgCode == "Optional(-2)"{
////                    self.Alert(msg:"User already exists")
//                    self.AlertVerif(text: "Code sent, check your mail")
//                }
//                }
            }else {
                Alert(msg: "Password not matched")
            }
        }
    }
    @IBAction func whiteAction(_ sender: Any) {
        if whitebtn.titleLabel?.text == "REGISTER"{
            regView()
            bluebtn.layoutIfNeeded()
    }else if whitebtn.titleLabel?.text == "LOG IN"{
            logINView()
    }
    
    }
    
    
    func logINView(){
        confirmPass.isHidden = true
        bluebtn.setTitle("LOG IN", for: .normal)
        whitebtn.setTitle("REGISTER", for: .normal)
        DispatchQueue.main.async {
               self.btnsCons.constant = -30
               self.bluebtn.layoutIfNeeded()
           }
        
}
    func regView(){
        confirmPass.isHidden = false
        bluebtn.setTitle("REGISTER", for: .normal)
        whitebtn.setTitle("LOG IN", for: .normal)
        DispatchQueue.main.async {
            self.btnsCons.constant = 20
            self.bluebtn.layoutIfNeeded()
        }
}
    
    func Alert(msg: String){
        
       let Loginalert = UIAlertController(title: "Notice", message: msg, preferredStyle: UIAlertController.Style.alert)
        Loginalert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { (action: UIAlertAction!) in
           Loginalert.view.tintColor = UIColor(rgb: 0x2667BF)
        
        self.loadingOut()
       }))
       self.present(Loginalert, animated: true, completion: nil)
        
    }
    func AlertVerif(text: String){
//       self.httpReq.URLFunc(email:self.email.text!, pass:"", url:"https://pet-me.me/water/resendVerification.php", code:"")
        let alert = UIAlertController(title: text, message: "Verify your account", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Enter your code here!"
        }
        alert.addAction(UIAlertAction(title: "Resend Code", style: UIAlertAction.Style.default, handler: { (action: UIAlertAction!) in
            self.AlertVerif(text: "code sent, check your mail")
         self.loadingOut()
            
//            self.httpReq.URLFunc(email:self.email.text!, pass:"", url:"https://pet-me.me/water/resendVerification.php", code:"")
//            print("Text field: \(String(describing: alertTextField!.text))")
        }))
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
//                    let alertTextField = alert?.textFields![0]
                    
//            self.httpReq.URLFunc(email:self.email.text!, pass:"", url:"https://pet-me.me/water/verify.php", code: alertTextField!.text!)
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                self.proccedLogIn()
            }
                }))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func proccedLogIn(){
        
        
        //         msgCode = String("")
//        print(URLData)
//                 print("msgcode2 = \(msgCode)")
//                 if msgcode == "1"{
////                    let code = urlData[1]
////
////                     print("success: \(result2)")
//        let viewController : homeViewController = (self.storyboard?.instantiateViewController(identifier: "homeViewController"))!
//        self.navigationController?.pushViewController(viewController, animated: true)
//        }
//                     self.loadingOut()
//                 }else if msgCode == "Optional(-2)"{
//                     print("wrong credentials")
//                     self.Alert(msg:"Make sure your email or password are correct!")
//                 }else if msgCode == "Optional(-4)"{
//                        self.Alert(msg:"Missing Fields")
//                     }else if msgCode == "Optional(-1)"{
//                    self.AlertVerif(text: "code sent, Check your mail again")
//                 }else{
//                    Alert(msg: "Verified, try to Log IN")
//        }
    }
 func textFieldShouldReturn(_ textField: UITextField) -> Bool {
     self.switchBasedNextTextField(textField)
    if (textField.returnKeyType==UIReturnKeyType.go)
     {
        blueAction(AnyObject.self)
    }
        return true
 }
    private func switchBasedNextTextField(_ textField: UITextField) {
        switch textField {
        case self.email:
            self.pass.becomeFirstResponder()
        case self.pass:
            self.confirmPass.becomeFirstResponder()
        default:
            self.email.resignFirstResponder()
        }
    }
    func loadingIn(){
        indicatorView.isHidden = false
        self.indicatorView.startAnimating()
        bluebtn.isEnabled = false
        whitebtn.isEnabled = false
        email.isEnabled = false
        pass.isEnabled = false
        confirmPass.isEnabled = false
    }
    func loadingOut(){
        email.isEnabled = true
        pass.isEnabled = true
        confirmPass.isEnabled = true
        self.bluebtn.isEnabled = true
        self.whitebtn.isEnabled = true
        self.indicatorView.isHidden = true
        self.indicatorView.stopAnimating()
    }
}



    extension UIColor {
       convenience init(red: Int, green: Int, blue: Int) {
           assert(red >= 0 && red <= 255, "Invalid red component")
           assert(green >= 0 && green <= 255, "Invalid green component")
           assert(blue >= 0 && blue <= 255, "Invalid blue component")

           self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
       }

       convenience init(rgb: Int) {
           self.init(
               red: (rgb >> 16) & 0xFF,
               green: (rgb >> 8) & 0xFF,
               blue: rgb & 0xFF
           )
       }
    }


