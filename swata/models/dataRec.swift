//
//  dataRec.swift
//  swata
//
//  Created by imps on 1/19/21.
//  Copyright © 2021 imps. All rights reserved.
//

import UIKit

public class dataRec: NSObject {
    var user_id: String
    var verified: String
    init(valueDictionary: [String:Any?]){
           self.user_id = valueDictionary["user_id"] as! String
           self.verified = valueDictionary["verified"] as! String
    }
}

public class msgCode: NSObject{
    var code: Any
    var msg: Any
    init(Code: Any, Msg: Any){
        self.code = Code
        self.msg = Msg
    }
}
