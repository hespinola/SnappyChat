//
//  CameraVC.swift
//  SnappySnap
//
//  Created by Isomi on 4/23/17.
//  Copyright © 2017 Humberto Espinola. All rights reserved.
//

import UIKit
import Panel
import CameraManager

class CameraVC: UIViewController {

    // MARK: - UI Elements
    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var snapButton: UIButton!
    @IBOutlet weak var changeCameraButton: UIButton!
    @IBOutlet weak var flashButton: UIButton!
    @IBOutlet weak var leftPanelButton: UIButton!
    @IBOutlet weak var rightPanelButton: UIButton!
    
    // MARK: - Class Members
    private let cameraManager = CameraManager()
    private var flashActivatedImage: UIImage!
    private var flashAutoImage: UIImage!
    var panelDelegate: PanelViewControllerDelegate?
    
    // MARK: - Override controller life-cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        _ = cameraManager.addPreviewLayerToView(cameraView, newCameraOutputMode: .stillImage)
        cameraManager.cameraOutputQuality = .high
        cameraManager.flashMode = .auto
        cameraManager.writeFilesToPhoneLibrary = false
        cameraManager.shouldRespondToOrientationChanges = false
        
        flashActivatedImage = UIImage(named: "flash_btn")
        flashAutoImage = UIImage(named: "flash_auto_btn")
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if cameraManager.currentCameraStatus() == .accessDenied ||
            cameraManager.currentCameraStatus() == .noDeviceFound ||
            cameraManager.currentCameraStatus() == .notDetermined {
            let alert = UIAlertController(title: "Oops!", message: "Camera is disabled", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }
        
        cameraManager.resumeCaptureSession()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        cameraManager.stopCaptureSession()
    }
    
    @IBAction func snapButtonTapped(_ sender: Any) {
        if cameraManager.cameraIsReady {
            cameraManager.capturePictureWithCompletion({ (image, error) in
                if let image = image {
                    self.performSegue(withIdentifier: "EditImageVC", sender: image)
                }
            })
        } else {
            let alert = UIAlertController(title: "Oops!", message: "Camera is not available", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func changeCameraButtonTapped(_ sender: Any) {
        if !cameraManager.hasFrontCamera { return }
        cameraManager.cameraDevice = cameraManager.cameraDevice == .back ? .front : .back
    }
    
    @IBAction func flashButtonTapped(_ sender: Any) {
        
        // Check if device can use flash
        if !cameraManager.hasFlash {
            let alert = UIAlertController(title: "Oops!", message: "Can't use flash", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }
        
        switch (cameraManager.changeFlashMode()) {
            case .off:
                flashButton.setImage(flashActivatedImage, for: .normal)
                flashButton.alpha = 0.5
                break
            
            case .on:
                flashButton.setImage(flashActivatedImage, for: .normal)
                flashButton.alpha = 1
                break
            
            case .auto:
                flashButton.setImage(flashAutoImage, for: .normal)
                flashButton.alpha = 1
                break
        }
    }
    
    @IBAction func leftPanelButtonTapped(_ sender: Any) {
        panelDelegate?.PanelViewControllerAnimateTo(panel: .left)
    }
    
    @IBAction func rightPanelButtonTapped(_ sender: Any) {
        panelDelegate?.PanelViewControllerAnimateTo(panel: .right)
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "EditImageVC" {
            if let editImageVC = segue.destination as? EditImageVC {
                if let image = sender as? UIImage {
                    editImageVC.image = image
                }
            }
        }
    }
 

}
