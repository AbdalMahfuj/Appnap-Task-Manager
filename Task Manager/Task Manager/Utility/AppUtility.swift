//
//  AppUtility.swift
//  Task Manager
//
//  Created by Mahfuz on 27/6/24.
//


import UIKit
import AVFoundation


class AppUtility: NSObject {

    static let shared = AppUtility()
    

    private let activityData = ActivityData(type: NVActivityIndicatorType.lineScalePulseOut, color:  UIColor.link.withAlphaComponent(0.5), backgroundColor: UIColor.black.withAlphaComponent(0.1))

    private override init() {
        super.init()
    }
 
    
    static func showOkAlert(_ title: String? = nil, message: String? = nil, completion:(()->())? = nil) {
        showAlert(title, message: message, buttons: ["OK"]) { _ in
            completion?()
        }
    }
    
    static func showWarningAlert(_ title: String = "Warning", message: String? = nil, completion:(()->())? = nil) {
        showAlert(title, message: message, buttons: ["OK"]) { _ in
            completion?()
        }
    }
    
    static func showFailAlert(_ title: String = "Failed", message: String? = nil, completion:(()->())? = nil) {
        showAlert(title, message: message, buttons: ["OK"]) { _ in
            completion?()
        }
    }
    
    static func showConfirmationAlert(_ title: String = "Confirmation", message: String? = nil, yes: String = "Yes", cancel: String = "No", completion:((Bool)->())? = nil) {
        showAlert(title, message: message, buttons: [yes], cancel: cancel) { btn in
            completion?(btn == yes)
        }
    }
    
    static func showSuccessAlert(_ title: String = "Success", message: String? = nil, completion:(()->())? = nil) {
        showAlert(title, message: message, buttons: ["OK"]) { _ in
            completion?()
        }
    }

    
    static func showAlert(_ title: String? = nil, message: String? = nil, buttons: [String], cancel: String? = nil, style: UIAlertController.Style = .alert, completion:((String)->())?) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
                
        for str in buttons {
            alertController.addAction(UIAlertAction(title: str, style: .default, handler: { _ in
                completion?(str)
            }))
        }
        
        if let cancel = cancel {
            alertController.addAction(UIAlertAction(title: cancel, style: style == .alert ? .destructive : .cancel, handler: { _ in
                completion?(cancel)
            }))
        }
        
        presentViewController(alertController, animated: true)
    }
    
    
    static func presentViewController(_ vc: UIViewController, animated: Bool = true, completion:(()->())? = nil){
        if #available(iOS 13, *) {
            vc.modalPresentationStyle = .overFullScreen
        }
        else {
            vc.modalPresentationStyle = .overCurrentContext
        }
        
        if let topVC = getTopViewController(){
            topVC.present(vc, animated: animated, completion: {
                completion?()
            })
        }
    }
    
    static func getTopViewController()->UIViewController! {
        var topVC = UIApplication.shared.currentWindow?.rootViewController
        
        if topVC?.presentedViewController != nil {
            topVC = UIApplication.shared.currentWindow?.rootViewController?.presentedViewController
            
            while topVC?.presentedViewController != nil {
                topVC = topVC?.presentedViewController
            }
        }
        
        return topVC
    }
    
    static func dismissAllVC(animated: Bool = true,  completion:(()->())? = nil) {
        UIApplication.shared.currentWindow?.rootViewController?.dismiss(animated: animated, completion: {
            completion?()
        })
    }
    
    static func dismissVC(animated: Bool = true,  completion: (()->())? = nil) {
        if let topVC = getTopViewController() {
            topVC.dismiss(animated: animated) {
                completion?()
            }
        }
    }  
    
    func showLoader() {
        UIApplication.shared.currentWindow?.isUserInteractionEnabled = false
        
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData, NVActivityIndicatorView.DEFAULT_FADE_IN_ANIMATION)
    }
    
    func hideLoader() {
        UIApplication.shared.currentWindow?.isUserInteractionEnabled = true
        
        NVActivityIndicatorPresenter.sharedInstance.stopAnimating(NVActivityIndicatorView.DEFAULT_FADE_OUT_ANIMATION)
    }
}

