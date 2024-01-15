//
//  ShoePackageChooseDateAndRegionViewController.swift
//  TemizOperasyon
//
//  Created by Furkan Bekil on 22.10.2018.
//  Copyright © 2018 Furkan Bekil. All rights reserved.
//

import UIKit

class chooseDateAndRegion: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    // Fields
    @IBOutlet weak var dateField: UITextField!
    @IBOutlet weak var hourField: UITextField!
    @IBOutlet weak var hourFieldTop: NSLayoutConstraint!
    @IBOutlet weak var regionField: UITextField!
    
    // Views
    @IBOutlet weak var regionSelectionView: UIView!
    @IBOutlet weak var hourSelectionView: UIView!
    
    
    // Cargo History
    @IBOutlet weak var cargoHistory: UISwitch!
    @IBOutlet weak var cargoHistoryLbl: UILabel!
    
    
    // Pickers
    let datePicker = UIDatePicker()
    var hourPicker = UIPickerView()
    var regionPicker = UIPickerView()
    
    // Arrays
    var hours = ["Seçiniz", "Sabah","Akşam", "E-Ticaret"]
    var regions = ["Seçiniz", "Anadolu","Avrupa", "Üsküdar", "Kargo", "Bakırköy", "Nike"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // gestureRecognizer for keyboard
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(chooseDateAndRegion.hideKeyboard))
        view.addGestureRecognizer(tap)

        
        adjustViews()
        adjustToolbar()
        createDatePicker()
        adjustPickers()
        
    }
    
    func adjustViews() {
        
        self.cargoHistory.isHidden = true
        self.cargoHistoryLbl.isHidden = true
        self.hourFieldTop.constant = 20
        
        navigationItem.title = "Zaman Seçin"
        
    }
    
    func adjustPickers() {
        
        hourPicker.delegate = self
        hourPicker.dataSource = self
        
        regionPicker.delegate = self
        regionPicker.dataSource = self
        
        hourField.inputView = hourPicker
        regionField.inputView = regionPicker
        
    }
    
    func createDatePicker() {
        
        datePicker.datePickerMode = .date
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
        
        let dateStart = NSDate.init(timeIntervalSince1970: 1609489837)
        let dateEnd = NSDate.init(timeIntervalSince1970: 1640995200)
        
        datePicker.minimumDate = dateStart as Date
        datePicker.maximumDate = dateEnd as Date
        
        
        
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        
        let doneBtn = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(chooseDateAndRegion.donePressed))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        
        toolbar.setItems([spaceButton,doneBtn], animated: false)
        
        dateField.inputAccessoryView = toolbar
        
        dateField.inputView = datePicker
        
        
    }
    
    func adjustToolbar() {
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Tamam", style: UIBarButtonItemStyle.plain, target: self, action: #selector(chooseDateAndRegion.hideKeyboard))
        doneButton.tintColor = UIColor(rgb: 0x2DC34B)
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: Selector(("cancelPressed")))
        cancelButton.tintColor = UIColor(rgb: 0x2981D9)
        
        // Toolbar Assigning
        toolBar.setItems([spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        // Toolbar Field Assigning
        hourField.inputAccessoryView = toolBar
        regionField.inputAccessoryView = toolBar
        
    }
    
    // Hide Heyboard
    @objc func hideKeyboard() {
        self.view.endEditing(true)
    }
    
    @objc func donePressed() {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale(identifier: "tr_TR")
        
        dateFormatter.dateFormat = "dd-MM-yyyy"
        
        dateField.text = dateFormatter.string(from: datePicker.date)

        
        
        self.view.endEditing(false)
        
    }

    @IBAction func closePressed(_ sender: Any) {
        
        self.performSegue(withIdentifier: "goHome", sender: nil)
        
    }
    
    // Picker Functions
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if pickerView == hourPicker {
            return hours.count
        } else if pickerView == regionPicker {
            return regions.count
        }  else {
            return 0
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if pickerView == hourPicker {
            return hours[row]
        } else if pickerView == regionPicker {
            return regions[row]
        }  else {
            return ""
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        
        if pickerView == hourPicker {
            
            hourField.text = hours[row]
            
        } else if pickerView == regionPicker {
            
            regionField.text = regions[row]
            if regionField.text == "Kargo" {
                
                self.hourSelectionView.isHidden = false
                self.cargoHistory.isHidden = false
                self.cargoHistoryLbl.isHidden = false
                self.hourFieldTop.constant = 70
                
                
            } else if regionField.text == "E-Ticaret" {
                
                self.hourSelectionView.isHidden = true
                
            } else {
                
                self.cargoHistory.isHidden = true
                self.cargoHistoryLbl.isHidden = true
                self.hourSelectionView.isHidden = false
                self.hourFieldTop.constant = 20
                
            }
            
        }  else {
            
        }
        
        
    }
    
    // Cargo Switch Pressed
    
    @IBAction func cargoSwitchPressed(_ sender: Any) {
        
        if self.cargoHistory.isOn {
           
            DataManager.cargoHistory = 1
            
        } else {
            
            DataManager.cargoHistory = 0
            
        }
        
    }
    

    // Submit Pressed
    
    @IBAction func submitPressed(_ sender: Any) {
        
        print("istediğim \(regionField.text)")
        
        
        if hourField.text == "E-Ticaret" {
            
            
                
            if dateField.text == "" || regionField.text == "" || hourField.text == "" {
                showFieldAlert()
            } else {
                DataManager.shoeOrderListDate = dateField.text!
                DataManager.shoeOrderListArea = regionField.text!
                
                performSegue(withIdentifier: "goECommerceList", sender: nil)
            }
                
            
            
        } else {
            
            if dateField.text == "" || regionField.text == "" || hourField.text == "" {
                
                
                showFieldAlert()
                
                
            } else {
                
                DataManager.shoeOrderListDate = dateField.text!
                DataManager.shoeOrderListArea = regionField.text!
                DataManager.shoeOrderListType = hourField.text!
                
                performSegue(withIdentifier: "goList", sender: nil)
                
            }

        }
        
        
        
        
        
        
    }
    
    func showFieldAlert () {
        
        let alert = UIAlertController(title: "", message: "Herhangi bir alanı boş bırakmayın", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            
            self.view.endEditing(true)
            
        }))
        self.present(alert, animated: true, completion: nil)
        
    }
    
}
