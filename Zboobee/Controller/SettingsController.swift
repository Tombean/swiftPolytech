//
//  SettingsController.swift
//  Zboobee
//
//  Created by Laure MARCHAL on 22/03/2017.
//  Copyright © 2017 Laure MARCHAL. All rights reserved.
//

import Foundation
import UIKit

class SettingsController : UIViewController, UITableViewDataSource,UITableViewDelegate{
    
    var userloged : User?
    
    @IBOutlet weak var titleStudents: UILabel!
    @IBOutlet weak var titleTeachers: UILabel!
    @IBOutlet weak var studTable: UITableView!
    @IBOutlet weak var teachTable: UITableView!
    
    @IBAction func desactivateButton(_ sender: Any) {
    }
    @IBAction func activateButton(_ sender: Any) {
    }
    
    //sign out
    @IBAction func logoutButton(_ sender: Any) {
        let dismissAction = UIAlertAction(title: "Ok", style: .default, handler: self.dismissSelf)
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        DialogBoxHelper.alert(view: self, withTitle: "Confirmation", andMessage: "Are you sure you want to log out ?", actions: [dismissAction,cancelAction])
    }
    
    private func dismissSelf(_ :UIAlertAction) -> Void{
        UserSession.instance.user = nil
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        self.userloged = UserSession.instance.user
        guard self.userloged != nil else{
            fatalError("No user selected!!!")
        }
        super.viewDidLoad()
        guard ((self.userloged is Teacher) || (self.userloged is Office)) else{
            let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
            DialogBoxHelper.alert(view: self, withTitle: "Unauthorized feature", andMessage: "User settings are only for techers and office", action: cancelAction )
            return
        }
    }
    
    //MARK: - Delegates and data sources
    //MARK: Data Sources tableview
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //self.updateMessages()
        let cell = self.studTable.dequeueReusableCell(withIdentifier: "studentCell", for: indexPath) as! studentTableViewCell
//        let message = self.messagesFetched.object(at: indexPath)
//        cell.messageLabel.text = message.content!
//        let userM = message.isPosted!
//        cell.userLabel.text = userM.lastname
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
//        guard let section = self.messagesFetched.sections?[section] else {
//            fatalError("unexpected section number")
//        }
//        return section.numberOfObjects
        return 0
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
}
