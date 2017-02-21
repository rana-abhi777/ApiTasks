
import UIKit
import Alamofire
import ObjectMapper

class ViewController: UIViewController,UITextFieldDelegate {

    var printMessage=""
    var buttonPress=0
    var username:String?
    var passwordVal:String?
    var name:String?
    var email:String?
    var birthday:String?
    var phone:String?
    var country:String?
    var city:String?
    
    @IBOutlet weak var tfUserName: UITextField!
    
    
    @IBOutlet weak var tfPassword: UITextField!
    
    
    
    @IBOutlet weak var btnSignUp: UIButton!
    
    
    @IBOutlet weak var btnRemember: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tfUserName.delegate=self
        tfPassword.delegate=self
     
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        self.view.endEditing(true)
    }

    @IBAction func btnSignUpAction(_ sender: Any) {
    }
    @IBAction func btnSignInAction(_ sender: Any) {
         username=tfUserName.text
         passwordVal=tfPassword.text
        if( (username?.isEmpty)! || (passwordVal?.isEmpty)!  )
        {
            printMessage="All fields are Mandatory"
            ValidationAlertViewController.doAlert(messageReceived:printMessage, obj:self)
        }
        else if !(ValidationAlertViewController.validateEmail(Your: tfUserName.text!))
        {
            printMessage="Invalid Username"
            ValidationAlertViewController.doAlert(messageReceived:printMessage, obj:self)
        }
        else if((passwordVal?.characters.count)! < 5)
        {
            printMessage="password should contain at least 5 digits"
            ValidationAlertViewController.doAlert(messageReceived:printMessage, obj:self)
        }
            self.fetchData()
    }
    @IBAction func btnRememberAction(_ sender: Any) {
        if(buttonPress==0)
        {
            buttonPress=1
            btnRemember.setImage(#imageLiteral(resourceName: "done_white"), for: .normal)
        }
        
        else if(buttonPress==1)
        {
            buttonPress=0
            btnRemember.setImage(#imageLiteral(resourceName: "undone"), for: .normal)
        }
    }
    
    func fetchData()
    {
        let param:[String:Any] = ["email":username ?? "", "password":passwordVal ?? "", "flag":"1"]
        
        ApiHandler.fetchData(urlStr: "login", parameters: param) { (jsonData) in
             print(jsonData!)
            let userModel = Mapper<UserLoginModel>().map(JSONObject: jsonData)
            
            print(userModel?.msg ?? "")
            print(userModel?.profile?.username ?? "")
            print(userModel?.profile?.phone ?? "")
            print(userModel?.profile?.birthday ?? "")
            self.name=userModel?.profile?.username ?? ""
            self.email=userModel?.profile?.email ?? ""
            self.birthday=userModel?.profile?.birthday ?? ""
            self.city=userModel?.profile?.city ?? ""
            self.phone=userModel?.profile?.phone ?? ""
            self.country=userModel?.profile?.country ?? ""
            
          self.performSegue(withIdentifier: "id", sender: self)
    }
    
}
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if(segue.identifier=="id")
        {
        let DestViewController : ThirdViewController = segue.destination as! ThirdViewController
        DestViewController.name =  self.name ?? ""
        DestViewController.email = self.email ?? ""
        DestViewController.birthday = self.birthday ?? ""
        DestViewController.city = self.city ?? ""
        DestViewController.country = self.country ?? ""
        DestViewController.phone = self.phone ?? ""
        
        }
    }

}
/*
 let param : [String : Any] = ["username": txtFieldName.text ?? "",
 "email" : txtFieldEmailAddress.text ?? "",
 "password" : txtFieldPassword.text ?? "",
 "phone" : txtFieldPhoneNumber.text ?? "",
 "country" : txtFieldCountry.text ?? "",
 "city" : txtFieldCity.text ?? "",
 "address" : txtFieldAddress.text ?? "",
 "flag" : 1,
 "birthday" : "09/02/1994",
 "country_code" : "91",
 "postal_code" : "134109",
 "country_iso3" : "IND",
 "state" : "HARYANA"]
 ApiHandler.fetchData(urlStr: "signup", parameters: param) { (jsonData) in
 let userModel = Mapper<User>().map(JSONObject : jsonData)
 print(userModel?.msg ?? "")
 print(userModel?.profile?.username ?? "")
 print(userModel?.profile?.phone ?? "")
 */
