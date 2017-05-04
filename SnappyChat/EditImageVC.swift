//
//  EditImageVC.swift
//  SnappySnap
//
//  Created by Isomi on 4/23/17.
//  Copyright © 2017 Humberto Espinola. All rights reserved.
//

import UIKit

class EditImageVC: UIViewController, UITextViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    // MARK: - UI Elements
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var imageCaption: UITextView!
    @IBOutlet weak var timerButton: UIButton!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var downloadSnap: UIButton!
    @IBOutlet weak var timePicker: UIPickerView!
    @IBOutlet weak var timePickerBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageCaptionYConstraint: NSLayoutConstraint!
    
    // MARK: - Class Members
    var image: UIImage?
    private var pickerData: [String] = [String]()
    private var timer = 1
    private let TEXT_VIEW_CHARACTER_LIMIT = 40

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // MARK: - View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let tapImage = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        imageView.addGestureRecognizer(tapImage)
        imageView.isUserInteractionEnabled = true
        imageView.image = image
        imageCaption.delegate = self
        imageCaption.isHidden = true
        
        let panImageCaptionGesture = UIPanGestureRecognizer(target: self, action: #selector(shouldDragImageCaption))
        imageCaption.addGestureRecognizer(panImageCaptionGesture)
        
        timerLabel.text = "\(timer)"
        
        timePicker.delegate = self
        timePicker.dataSource = self
        pickerData = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10"]
        timePickerBottomConstraint.constant = -256
    }
    
    // MARK: - TextView Delegate
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if text == "\n" {
            shouldHideImageCaption()
            return false
        }
        
        return (textView.text.characters.count) + text.characters.count <= TEXT_VIEW_CHARACTER_LIMIT
    }
    
    // MARK: - PickerView Delegate
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    // MARK: - UI Actions
    @IBAction func cancelButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func sendButtonTapped(_ sender: Any) {
        let newImage = imageCaption.isHidden ? image! : createExportableImage(image: image!, text: imageCaption.text as NSString)
        
        print(newImage.debugDescription)
    }
    
    @IBAction func timerButtonTapped(_ sender: Any) {
        UIView.animate(withDuration: 0.5, animations: {
            self.timePickerBottomConstraint.constant = 0
            self.view.layoutIfNeeded()
        })
    }
    
    @IBAction func downloadSnapButtonTapped(_ sender: Any) {
        downloadSnap.isEnabled = false
        
        let newImage = imageCaption.isHidden ? image! : createExportableImage(image: image!, text: imageCaption.text as NSString)
        UIImageWriteToSavedPhotosAlbum(newImage, nil, nil, nil)
    }
    
    // MARK: - Class Methods
    func imageTapped(sender: UITapGestureRecognizer) {
        // Check if Time Picker is on screen
        if timePickerBottomConstraint.constant == 0 {
            
            timer = (pickerData[timePicker.selectedRow(inComponent: 0)] as NSString).integerValue
            timerLabel.text = "\(timer)"
            
            UIView.animate(withDuration: 0.5, animations: {
                self.timePickerBottomConstraint.constant = -256
                self.view.layoutIfNeeded()
            })
            
            return
        }
        
        // Show or hide Keyboard and Image Caption
        if imageCaption.isFirstResponder {
            shouldHideImageCaption()
        } else {
            shouldShowImageCaption()
        }
    }
    
    func shouldDragImageCaption(sender: UIPanGestureRecognizer) {
        // Check if imageCaption is visible
        if imageCaption.isHidden { return }
        shouldHideImageCaption()
        
        let currentPosition = imageCaption.frame.origin
        
        let translation = sender.translation(in: self.view)
        
        if currentPosition.y > self.view.frame.minY && currentPosition.y < (self.view.frame.maxY - imageCaption.frame.height) {
            sender.view?.center = CGPoint(x: (sender.view?.center.x)!, y: (sender.view?.center.y)! + translation.y)
            sender.setTranslation(CGPoint.zero, in: self.view)
        }
    }
    
    // Dismiss Keyboard and check if Image Caption needs to hide
    func shouldHideImageCaption() {
        imageCaption.resignFirstResponder()
        
        if imageCaption.text.characters.count < 1 {
            imageCaption.isHidden = true
        }
    }
    
    // Show Keyboard and Image Caption
    func shouldShowImageCaption() {
        if imageCaption.isHidden {
            imageCaption.isHidden = false
        }
        
        imageCaption.becomeFirstResponder()
        
        if imageCaptionYConstraint.constant != 0 {
            UIView.animate(withDuration: 0.7, animations: {
                self.imageCaptionYConstraint.constant = 0
                self.imageCaption.layoutIfNeeded()
            })
        }
    }
    
    func createExportableImage(image: UIImage, text: NSString) -> UIImage {
        
        let newFontSizePercent = convertValueToPercent(value: 20, maxValue: view.frame.height)
        let newFontSize = convertPercentToValue(percent: newFontSizePercent, maxValue: image.size.height)
        
        let stringAttributes: [String: Any] = [
            NSFontAttributeName: imageCaption.font!.withSize(newFontSize),
            NSForegroundColorAttributeName: UIColor.white]
        
        let imageRect = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
        
        let positionPercent = convertValueToPercent(value: imageCaption.center.y, maxValue: view.frame.height)
        let newPosition = convertPercentToValue(percent: positionPercent, maxValue: image.size.height)
        
        let heightPercent = convertValueToPercent(value: 30, maxValue: view.frame.height)
        let newHeight = convertPercentToValue(percent: heightPercent, maxValue: image.size.height)
        
        let textRect = CGRect(x: (image.size.width / 2) - (text.size(attributes: stringAttributes).width / 2), y: newPosition, width: imageRect.width, height: newHeight)
        
        UIGraphicsBeginImageContext(image.size)
        image.draw(in: imageRect)
        UIColor.black.withAlphaComponent(0.7).set()
        UIBezierPath(rect: CGRect(x: 0, y: newPosition, width: imageRect.width, height: newHeight)).fill()
        text.draw(in: textRect, withAttributes: stringAttributes)
        
        let transformedImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return transformedImage
    }
    
    func convertValueToPercent(value: CGFloat, maxValue: CGFloat) -> CGFloat {
        return value / maxValue * 100
    }
    
    func convertPercentToValue(percent: CGFloat, maxValue: CGFloat) -> CGFloat {
        return maxValue * percent / 100
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
