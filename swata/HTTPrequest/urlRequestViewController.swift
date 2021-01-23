//
//  urlRequest.swift
//  swata
//
//  Created by imps on 1/13/21.
//  Copyright © 2021 imps. All rights reserved.
//

import UIKit

class urlRequestViewController: UIViewController {
    
    var URLData: [dataRec]?
    var URLMsgCode: [msgCode]?
    override func viewDidLoad() {
           super.viewDidLoad()
    }
   func URLfunc(email :String, pass: String, url: String, code: String) {
    self.URLData = [dataRec]()
    self.URLMsgCode = [msgCode]()
               var request = URLRequest(url: URL(string: url)!)
               request.httpMethod = "POST"
            var postString: String?
           if code == ""{
               postString = "email=\(email)&password=\(pass)"
           }else {
               postString = "email=\(email)&code=\(code)"
               
           }
           request.httpBody = postString!.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            
            
 guard let dataResponse = data, error == nil else {
                        print(error?.localizedDescription ?? "Response Error")
                        return }
                do{
                    //here dataResponse received from a network request
                    let jsonResponse = try JSONSerialization.jsonObject(with:
                        dataResponse, options: [])
                    
                    guard let jsonDictionary = jsonResponse as? [String : Any] else {
                        return
                    }
                    
                   
                    let code = jsonDictionary["code"]!
                    let msg = jsonDictionary["msg"]!
                    let jsonData = jsonDictionary["data"] as? [String:Any]
//
                    if jsonData != nil{
                    let data: dataRec = dataRec(valueDictionary: jsonData!)
//              
                   self.URLData?.append(data)
                        let msgCo: msgCode = msgCode(Code: code, Msg: msg)
                        self.URLMsgCode?.append(msgCo)
                        
                    }else{
                        let data: msgCode = msgCode(Code: code, Msg: msg)
                        self.URLMsgCode?.append(data)
                    }
                    
                    
                } catch let parsingError {
                    print("Error", parsingError)
                }
            }

            
            
    task.resume()
    }
}
