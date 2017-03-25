//
//  DialogBoxHelper
//  Zboobee
//
//  Created by Tom SOMERVILLE-ROBERTS on 02/03/2017.
//  Copyright © 2017 Laure MARCHAL. All rights reserved.
//

import Foundation
import UIKit

/// Class with all the function to lunch a message box
class DialogBoxHelper{
    

    /// function to display a simple message
    ///
    /// - Parameters:
    ///   - view: view where the box must be seen
    ///   - title: title of the box
    ///   - message: message in the box that display the information
    class func alert(view: UIViewController, withTitle title : String, andMessage message: String = ""){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(cancelAction)
        view.present(alert, animated: true)
    }
    
    /// function to display a message and do action on the ok
    ///
    /// - Parameters:
    ///   - view: view where the box must be seen
    ///   - title: title of the box
    ///   - message: message in the box that display the information
    ///   - action: action did when click on OK
    class func alert(view: UIViewController, withTitle title : String, andMessage message: String = "", action: UIAlertAction){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(action)
        view.present(alert, animated: true)
    }
    
    /// function to display a error message
    ///
    /// - Parameters:
    ///   - view: view where the box must be seen
    ///   - error: error happened
    class func alert(view : UIViewController, error : NSError){
        self.alert(view : view, withTitle : "\(error)", andMessage: "\(error.userInfo)")
    }
    
    
    /// function to display a message and do actions on the buttons
    ///
    /// - Parameters:
    ///   - view: view where the box must be seen
    ///   - title: title of the box
    ///   - message: message in the box that display the information
    ///   - actions: tab of actions did when click on buttons
    class func alert(view: UIViewController, withTitle title : String, andMessage message : String = "",actions:[UIAlertAction]){
        let alert = UIAlertController(title:title, message: message, preferredStyle: .alert)
        alert.addAction(actions[0])
        alert.addAction(actions[1])
        view.present(alert, animated:true)

    }
    
    
}
