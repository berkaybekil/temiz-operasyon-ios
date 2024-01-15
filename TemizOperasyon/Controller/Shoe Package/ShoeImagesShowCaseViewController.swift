//
//  ShoeImagesShowCaseViewController.swift
//  TemizOperasyon
//
//  Created by Furkan Bekil on 22.10.2018.
//  Copyright © 2018 Furkan Bekil. All rights reserved.
//

import UIKit
import Kingfisher

class ShoeImagesShowCaseViewController: UIViewController, UIScrollViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    // Container View Width
    @IBOutlet weak var scrollContainerView: UIView!
    @IBOutlet weak var containerViewWidth: NSLayoutConstraint!
    
    // Change Status View
    @IBOutlet weak var changeStatusView: UIView!
    @IBOutlet weak var changeStatusField: UITextField!
    
    // Scroll View
    @IBOutlet weak var scrollView: UIScrollView!
    
    // Page Control
    @IBOutlet weak var pageControl: UIPageControl!
    
    // Status Picker
    var statusPicker = UIPickerView()
    var currentStatus: statusItem!
    
    // Loading View
    @IBOutlet weak var loadingView: UIView!
    
    // Image Views
    var allImageViews = [ImageView]()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Sipariş Listeleme"
        
        statusPicker.delegate = self
        statusPicker.dataSource = self

        scrollView.delegate = self
        
        adjustToolBar()
        addImages()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        
        
    }
    
    func adjustToolBar() {
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Tamam", style: UIBarButtonItemStyle.plain, target: self, action: #selector(ShoeImagesShowCaseViewController.changeStatus))
        doneButton.tintColor = UIColor(rgb: 0x2DC34B)
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: Selector(("cancelPressed")))
        cancelButton.tintColor = UIColor(rgb: 0x2981D9)
        
        // Toolbar Assigning
        toolBar.setItems([spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        // Toolbar Field Assigning
        changeStatusField.inputAccessoryView = toolBar
        
        statusPicker.delegate = self
        statusPicker.dataSource = self
        
        changeStatusField.inputView = statusPicker
        
    }
    
    func adjustViews() {
        
        changeStatusView.layer.cornerRadius = 4
        changeStatusField.text = DataManager.imageShowCaseArray[DataManager.imageShowCaseSelectionIndex].product_status
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { // in half a second...
            self.scrollView.setContentOffset(CGPoint(x: CGFloat(DataManager.imageShowCaseSelectionIndex) * self.view.frame.width, y: 0.0), animated: true)
        }
        
        pageControl.currentPage = DataManager.imageShowCaseSelectionIndex
        
    }
    
    func addImages() {
        
        for x in 0 ..< DataManager.imageShowCaseArray.count {
            
            let shoeImageView = UIImageView()
            shoeImageView.contentMode = .scaleAspectFit
            let url = URL(string: DataManager.imageShowCaseArray[x].image)
            shoeImageView.kf.setImage(with: url)
            shoeImageView.frame = CGRect.init(x: CGFloat((x)) * self.view.frame.width, y: 20.0, width: self.view.frame.width, height: self.view.frame.height - 145)
            scrollContainerView.addSubview(shoeImageView)
            
            let barcodeLbl = UILabel.init()
            barcodeLbl.text = DataManager.imageShowCaseArray[x].barcode + " / " + DataManager.imageShowCaseArray[x].rack
            barcodeLbl.frame = CGRect.init(x: (CGFloat((x)) * self.view.frame.width) + ((self.view.frame.width - 200) / 2), y: 60, width: 200, height: 20)
            barcodeLbl.textColor = UIColor(rgb: 0x00AB66)
            barcodeLbl.textAlignment = .center
            barcodeLbl.font = UIFont.systemFont(ofSize: 20, weight: .bold)
            barcodeLbl.adjustsFontSizeToFitWidth = true
            
            scrollContainerView.addSubview(barcodeLbl)
            self.allImageViews.append(shoeImageView)
            
            
        }
        
        containerViewWidth.constant = CGFloat.init(self.view.frame.width)  * CGFloat.init(DataManager.imageShowCaseArray.count)
        pageControl.numberOfPages = DataManager.imageShowCaseArray.count
        adjustViews()
        
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let pageWidth = scrollView.frame.size.width
        let page = Int(floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1)
        
        print("page sayısı = \(page)")
        
        self.changeStatusField.text = DataManager.imageShowCaseArray[page].product_status
        
        self.pageControl.currentPage = page
        
        
    }
    
    // Picker View Functions
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return DataManager.allStatuses.count
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return DataManager.allStatuses[row].name
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        self.changeStatusField.text = DataManager.allStatuses[row].name
        self.currentStatus = DataManager.allStatuses[row]
        
    }
    
    @objc func changeStatus() {
        
        
        self.loadingView.isHidden = false
        self.view.endEditing(true)
        
        let parameters = [
            
            "token": DataManager.userToken,
            "barcode": DataManager.imageShowCaseArray[pageControl.currentPage].barcode,
            "status_id": currentStatus.id
            
            
            
            ] as [String : Any]
        
        fetchData(endpoint: "product/set/status", parameters: parameters as [String : AnyObject]?) { response in
            
            
            
            if let json = response.object as? Dictionary<String, AnyObject> {
                
                print(json)
                self.loadingView.isHidden = true
                
                let errorCode = json["errorCode"] as! String
                let message = json["message"] as! String
                
                if errorCode == "00" {
                    
                    DataManager.imageShowCaseArray[self.pageControl.currentPage].product_status = self.currentStatus.name
                    self.changeStatusField.text = self.currentStatus.name
                    
                    
                } else {
                    
                    let alert = UIAlertController(title: "", message: message, preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                        
                        self.view.endEditing(true)
                        
                    }))
                    self.present(alert, animated: true, completion: nil)
                    
                }
                
                
                
                
                
            }
            
            
        }
        
    }
    
    @IBAction func goDetailPressed(_ sender: Any) {
        
        DataManager.detailCode = DataManager.imageShowCaseArray[pageControl.currentPage].barcode
        performSegue(withIdentifier: "goDetail", sender: nil)
        
    }
    
    
    @IBAction func closePressed(_ sender: Any) {
        
        DataManager.imageShowCaseArray = [ShoeDetailModel]()
        DataManager.imageShowCaseSelectionIndex = 0
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
    

}
