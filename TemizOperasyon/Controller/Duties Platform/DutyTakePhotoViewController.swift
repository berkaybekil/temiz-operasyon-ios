//
//  DutyTakePhotoViewController.swift
//  TemizOperasyon
//
//  Created by Furkan Bekil on 18.02.2020.
//  Copyright © 2020 Furkan Bekil. All rights reserved.
//

import UIKit
import SwiftyCam
import AVFoundation

class DutyTakePhotoViewController: SwiftyCamViewController, SwiftyCamViewControllerDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    // Take Picture Button
        @IBOutlet weak var takePictureButton: UIButton!
        
        // Taken Image View
        @IBOutlet weak var takenImageView: UIImageView!
        
        // Close Buttons
        @IBOutlet weak var closePageButton: UIButton!
        @IBOutlet weak var closeImageButton: UIButton!
        @IBOutlet weak var approveImageView: UIView!
        
        // Album Button
        @IBOutlet weak var albumButton: UIButton!
        

        override func viewDidLoad() {
            super.viewDidLoad()

            // Do any additional setup after loading the view.
            self.cameraDelegate = self
            self.approveImageView.layer.cornerRadius = 25
            
            
        }
        
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            
            UIApplication.shared.isStatusBarHidden = true
            
            if DataManager.selectedSupportImage != nil {
                
                self.takenImageView.image = DataManager.selectedSupportImage
                self.takenImageView.isHidden = false
                
                self.closeImageButton.isHidden = false
                self.approveImageView.isHidden = false
                self.closePageButton.isHidden = true
                self.takePictureButton.isHidden = true
                self.albumButton.isHidden = true
            } else {
                self.adjustViews()
            }
            
        }
        
        override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
            UIApplication.shared.isStatusBarHidden = false
        }
        
        func adjustViews() {
            
            self.closeImageButton.isHidden = true
            self.approveImageView.isHidden = true
            self.closePageButton.isHidden = false
            self.takePictureButton.isHidden = false
            self.albumButton.isHidden = false
            self.takenImageView.isHidden = true
            
        }
        
        func swiftyCam(_ swiftyCam: SwiftyCamViewController, didTake photo: UIImage) {
            // Called when takePhoto() is called or if a SwiftyCamButton initiates a tap gesture
            // Returns a UIImage captured from the current session
            self.takenImageView.image = photo
            self.takenImageView.isHidden = false
            
            self.closeImageButton.isHidden = false
            self.approveImageView.isHidden = false
            self.closePageButton.isHidden = true
            self.takePictureButton.isHidden = true
            self.albumButton.isHidden = true
            
            
        }
        
        func swiftyCam(_ swiftyCam: SwiftyCamViewController, didBeginRecordingVideo camera: SwiftyCamViewController.CameraSelection) {
            // Called when startVideoRecording() is called
            // Called if a SwiftyCamButton begins a long press gesture
        }
        
        func swiftyCam(_ swiftyCam: SwiftyCamViewController, didFinishRecordingVideo camera: SwiftyCamViewController.CameraSelection) {
            // Called when stopVideoRecording() is called
            // Called if a SwiftyCamButton ends a long press gesture
        }
        
        func swiftyCam(_ swiftyCam: SwiftyCamViewController, didFinishProcessVideoAt url: URL) {
            // Called when stopVideoRecording() is called and the video is finished processing
            // Returns a URL in the temporary directory where video is stored
        }
        
        func swiftyCam(_ swiftyCam: SwiftyCamViewController, didFocusAtPoint point: CGPoint) {
            // Called when a user initiates a tap gesture on the preview layer
            // Will only be called if tapToFocus = true
            // Returns a CGPoint of the tap location on the preview layer
        }
        
        func swiftyCam(_ swiftyCam: SwiftyCamViewController, didChangeZoomLevel zoom: CGFloat) {
            // Called when a user initiates a pinch gesture on the preview layer
            // Will only be called if pinchToZoomn = true
            // Returns a CGFloat of the current zoom level
        }
        
        func swiftyCam(_ swiftyCam: SwiftyCamViewController, didSwitchCameras camera: SwiftyCamViewController.CameraSelection) {
            // Called when user switches between cameras
            // Returns current camera selection
        }
        
        // Take Picture Button Action
        
        @IBAction func takePicturePressed(_ sender: Any) {
            
            takePhoto()
            
        }
        
        // Album Pressed
        @IBAction func albumPressed(_ sender: Any) {
            
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.sourceType = .photoLibrary
            imagePickerController.modalPresentationStyle = .fullScreen
            self.present(imagePickerController, animated: true, completion: nil)
            
        }
        
        
    
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
            
            let tempImage = info[UIImagePickerControllerOriginalImage] as! UIImage
            DataManager.selectedSupportImage = tempImage
            self.dismiss(animated: true, completion: nil)
            
        }
        
        
        // Close Actions
        
        @IBAction func closeImagePressed(_ sender: Any) {
            
            self.takenImageView.isHidden = true
            self.takenImageView.image = UIImage.init()
            DataManager.selectedSupportImage = nil
            self.closeImageButton.isHidden = true
            self.approveImageView.isHidden = true
            self.closePageButton.isHidden = false
            self.takePictureButton.isHidden = false
            self.albumButton.isHidden = false
        }
        
        @IBAction func closePagePressed(_ sender: Any) {
            
            self.navigationController?.popViewController(animated: true)
            
        }
        
        @IBAction func approveImagePressed(_ sender: Any) {
            
            DataManager.selectedSupportImage = self.takenImageView.image
            self.navigationController?.popViewController(animated: true)
            
        }
        


}


