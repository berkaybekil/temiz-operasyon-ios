//
//  ProductListViewController.swift
//  TemizOperasyon
//
//  Created by Furkan Bekil on 26.12.2018.
//  Copyright © 2018 Furkan Bekil. All rights reserved.
//

import UIKit
import CollieGallery

class ProductListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // Table View
    @IBOutlet weak var tableView: UITableView!
    
    // All Products Array
    var allProductsArray = [ProductModel]()
    var selectedProduct: ProductModel!
    var filteredProductsArray = [ProductModel]()
    
    // Search Field
    @IBOutlet weak var searchField: UITextField!
    
    // Loading View
    @IBOutlet weak var loadingView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Ürün seç"
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        searchField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        getReasons()
        adjustToolBar()
        
    }
    
    // Get Products
    
    func getReasons() {
        
        
        
        var parameters = [
            
            "token": DataManager.userToken,
            "order_id": DataManager.selectedOrderId!,
            
            
            ] as [String : Any]
        
        
        
        fetchData(endpoint: "prices/list", parameters: parameters as [String : AnyObject]?) { response in
            
            
            
            if let json = response.object as? Dictionary<String, AnyObject> {
                
                print(json)
                
                if let barcodes = json["barcodes"] as? [Dictionary<String, AnyObject>] {
                    
                    for x in 0 ..< barcodes.count  {
                        
                        let product_images_id = barcodes[x]["product_images_id"] as! Int
                        let barcode = barcodes[x]["barcode"] as! String
                        let image_source = barcodes[x]["image_source"] as! String
                        
                        let item = ProductModel.init(id: product_images_id, name: barcode, image: image_source)
                        self.allProductsArray.append(item)
                        
                    }
                    
                }
                
                if let data = json["data"] as? [Dictionary<String, AnyObject>] {
                    
                    print("count \(data.count)")
                    
                    for x in 0 ..< data.count {
                        
                        let id = data[x]["id"] as! Int
                        let name = data[x]["name"] as! String
                        let item = ProductModel.init(id: id, name: name, image: "")
                        self.allProductsArray.append(item)
                        
                    }
                    self.filteredProductsArray = self.allProductsArray
                    self.tableView.reloadData()
                    self.loadingView.isHidden = true
                    
                }
                
                
                
            }
            
            
        }
        
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        print("text field changed")
        self.filteredProductsArray = [ProductModel]()
        
        if searchField.text != nil && searchField.text != "" {
            for x in 0 ..< self.allProductsArray.count {
                
                var controlString = "\(self.allProductsArray[x].name)"
                controlString = controlString.lowercased()
                
                controlString = controlString.replacingOccurrences(of: "ı", with: "i")
                controlString = controlString.replacingOccurrences(of: "ö", with: "o")
                controlString = controlString.replacingOccurrences(of: "ü", with: "u")
                controlString = controlString.replacingOccurrences(of: "ş", with: "s")
                controlString = controlString.replacingOccurrences(of: "ğ", with: "g")
                controlString = controlString.replacingOccurrences(of: "ç", with: "c")
                
                print(controlString)
                
                var searchString = searchField.text!.lowercased()
                searchString = searchString.replacingOccurrences(of: "ı", with: "i")
                searchString = searchString.replacingOccurrences(of: "ö", with: "o")
                searchString = searchString.replacingOccurrences(of: "ü", with: "u")
                searchString = searchString.replacingOccurrences(of: "ş", with: "s")
                searchString = searchString.replacingOccurrences(of: "ğ", with: "g")
                searchString = searchString.replacingOccurrences(of: "ç", with: "c")
                
                
                
                if controlString.contains(searchString) {
                    
                    self.filteredProductsArray.append(self.allProductsArray[x])
                    
                }
                
            }
            
        } else {
            self.filteredProductsArray = self.allProductsArray
        }
        
        if filteredProductsArray.count == 0 {
            
            // No product
            print("ürün bulunamadı")
            
        }
        
        self.tableView.reloadData()
        
    }
    
    func adjustToolBar() {
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: #selector(ProductListViewController.hideKeyboard))
        doneButton.tintColor = UIColor(rgb: 0x2DC34B)
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action: Selector(("cancelPressed")))
        cancelButton.tintColor = UIColor(rgb: 0x2981D9)
        
        // Toolbar Assigning
        toolBar.setItems([spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        // Toolbar Field Assigning
        searchField.inputAccessoryView = toolBar
        
    }
    
    
    
    @objc func hideKeyboard() {
        
        view.endEditing(true)
    }
    
    // Table View Delegate Functions
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.filteredProductsArray.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "productCell", for: indexPath) as! productCell
        
        cell.mainImgButton.tag = indexPath.row
        
        let item = filteredProductsArray[indexPath.row]
        
        cell.configureCell(item: item)
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.selectedProduct = filteredProductsArray[indexPath.row]
        self.hideKeyboard()
        
    }
    
    @IBAction func shoeImagePressed(_ sender: UIButton) {
        
        let mainView = UIImageView.init()
        
        let url = URL(string: filteredProductsArray[sender.tag].image)
        mainView.kf.setImage(with: url)
        
        var pictures = [CollieGalleryPicture.init(image: mainView.image!)]
        let gallery = CollieGallery(pictures: pictures)
        gallery.presentInViewController(self)
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if filteredProductsArray[indexPath.row].image != nil && filteredProductsArray[indexPath.row].image != "" {
            return 100
        } else {
            return 50
        }
        
        
    }
    
    
    @IBAction func closePressed(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func submitPressed(_ sender: Any) {
        
        if self.selectedProduct == nil {
            
            let alert = UIAlertView()
            alert.message = "Önce bir ürün seçin"
            alert.addButton(withTitle: "Tamam")
            alert.show()
            
        } else {
            
            self.loadingView.isHidden = false
            
            if selectedProduct.image == "" {
               
                let imageData = UIImageJPEGRepresentation(DataManager.takenImage, 0.25)
                let imageStr = imageData?.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
                
                var parameters = [
                    
                    "token": DataManager.userToken,
                    "order_id": DataManager.selectedOrderId!,
                    "demage_category_id": DataManager.demage_category_id,
                    "image": imageStr!,
                    "message": DataManager.otherReasonText,
                    "price_id": self.selectedProduct.id
                    
                    
                    
                    
                    ] as [String : Any]
                
                
                fetchData(endpoint: "orders/demage/add", parameters: parameters as [String : AnyObject]?) { response in
                    
                    
                    
                    
                    
                    if let json = response.object as? Dictionary<String, AnyObject> {
                        
                        self.loadingView.isHidden = true
                        self.performSegue(withIdentifier: "takePictureAgain", sender: nil)
                        
                        
                    }
                    
                    
                    
                    
                }
                
            } else {
                
                self.loadingView.isHidden = true
                DataManager.selectedProductFromPriceList = self.selectedProduct
                performSegue(withIdentifier: "goRepair", sender: nil)
                
            }
            
        }
        
        
        
    }
    

   

}
