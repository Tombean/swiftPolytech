//
//  WallViewController.swift
//  Zboobee
//
//  Created by Tom SOMERVILLE-ROBERTS on 22/02/2017.
//  Copyright © 2017 Laure MARCHAL. All rights reserved.
//

// A LIRE

import UIKit

class WallViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var tittleLabel: UILabel!
    @IBOutlet weak var channelPicker: UIPickerView!
    @IBOutlet weak var messageToPostLabel: UILabel!
    @IBOutlet weak var messageTF: UITextField!
    @IBOutlet weak var messagesTable: UITableView!
    @IBOutlet weak var searchToolbar: UIToolbar!
    @IBOutlet weak var menuToolbar: UIToolbar!
    // Temporary :  needs to be changed with channel allowed from DB
    let pickerData = ["All","Class","Class - Teachers","Class - Office"]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.channelPicker.dataSource = self
        self.channelPicker.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    //MARK: - Delegates and data sources
    //MARK: Data Sources
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return 1
    }
    
    //MARK: Delegates
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected objec
    }
}
