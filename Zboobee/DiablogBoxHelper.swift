//
//  DialogBoxHelper
//  Zboobee
//
//  Created by Tom SOMERVILLE-ROBERTS on 02/03/2017.
//  Copyright © 2017 Laure MARCHAL. All rights reserved.
//

import Foundation
import UIKit

class DialogBoxHelper{
    
    //shows an alert box with 2 messages
    
    
    class func alert(view: UIViewController, withTitle title : String, andMessage message: String = ""){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(cancelAction)
        view.present(alert, animated: true)
    }
    
    class func alert(view: UIViewController, withTitle title : String, andMessage message: String = "", action: UIAlertAction){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(action)
        view.present(alert, animated: true)
    }
    
    //shows an alert to inform about an error
    class func alert(view : UIViewController, error : NSError){
        self.alert(view : view, withTitle : "\(error)", andMessage: "\(error.userInfo)")
    }
    
    
    //shows alert with 2 actions possible
    
    class func alert(view: UIViewController, withTitle title : String, andMessage message : String = "",actions:[UIAlertAction]){
        let alert = UIAlertController(title:title, message: message, preferredStyle: .alert)
        alert.addAction(actions[0])
        alert.addAction(actions[1])
        view.present(alert, animated:true)

    }
    
    
}
