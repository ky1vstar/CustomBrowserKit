//
//  SwiftViewController.swift
//  CustomBrowserKit_Example
//
//  Created by KY1VSTAR on 26.03.18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import CustomBrowserKit

extension UIImage {
    
    func resizedTo(newSize: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0)
        draw(in: CGRect(origin: .zero, size: newSize))
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
    
}

class SwiftViewController: UIViewController {
    
    @IBOutlet var goBarButtonItem: UIBarButtonItem!
    @IBOutlet var textField: UITextField!
    @IBOutlet var tableView: UITableView!
    
    let availableBrowsers = BKManager.availableBrowsers
    var selectedBrowser = BKBrowser.safari
    var currentURL: URL!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        textFieldDidChange()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - TextField
    
    @IBAction func textFieldDidChange() {
        if let text = textField.text, !text.isEmpty, let url = URL(string: text) {
            currentURL = url
            goBarButtonItem.isEnabled = true
        } else {
            currentURL = nil
            goBarButtonItem.isEnabled = false
        }
    }
    
    // MARK: - Button
    
    @IBAction func goButtonClicked() {
        textField.endEditing(true)
        
        if BKManager.open(currentURL, with: selectedBrowser) {
            return
        }
        
        let alertController = UIAlertController(title: "Error", message: "Failed to open URL", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - Keyboard
    
    @objc func keyboardWillShow(_ notification: Notification) {
        handleKeyboard(notification: notification, willShow: true)
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        handleKeyboard(notification: notification, willShow: false)
    }
    
    func handleKeyboard(notification: Notification, willShow: Bool) {
        let keyboardHeight = willShow ? (notification.userInfo![UIKeyboardFrameEndUserInfoKey]! as AnyObject).cgRectValue.height : 0
        let animationDuration = (notification.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        let animationCurve = (notification.userInfo![UIKeyboardAnimationCurveUserInfoKey] as! NSNumber).intValue << 16
        
        UIView.animate(withDuration: animationDuration, delay: 0, options: UIViewAnimationOptions(rawValue: UInt(animationCurve)), animations: {
            self.tableView.contentInset.bottom = keyboardHeight
            self.tableView.scrollIndicatorInsets.bottom = keyboardHeight
        }, completion: nil)
    }

}

// MARK: - UITableViewDelegate

extension SwiftViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let previouslySelectedBrowserIndex = availableBrowsers.index(of: selectedBrowser)!
        if let cell = tableView.cellForRow(at: IndexPath(row: previouslySelectedBrowserIndex, section: 0)) {
            cell.accessoryType = .none
        }
        
        let cell = tableView.cellForRow(at: indexPath)!
        cell.accessoryType = .checkmark
        
        selectedBrowser = availableBrowsers[indexPath.row]
    }
    
}

// MARK: - UITableViewDataSource

extension SwiftViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return availableBrowsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let browser = availableBrowsers[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        
        cell.imageView!.image = browser.thumbnail?.resizedTo(newSize: CGSize(width: 32, height: 32))
        cell.imageView!.layer.cornerRadius = 32 * 0.157
        cell.imageView!.layer.borderColor = UIColor.lightGray.cgColor
        cell.imageView!.layer.borderWidth = 1 / UIScreen.main.scale
        cell.imageView!.clipsToBounds = true
        
        cell.textLabel!.text = browser.name
        
        cell.accessoryType = browser == selectedBrowser ? .checkmark : .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Browsers"
    }
    
}
