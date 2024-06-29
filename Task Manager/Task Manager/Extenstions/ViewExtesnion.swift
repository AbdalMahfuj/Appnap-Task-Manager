//
//  ViewExtesnion.swift
//  Task Manager
//
//  Created by Mahfuz on 27/6/24.
//

import Foundation
import UIKit

extension UIApplication {
    
    var currentWindow: UIWindow? {
        UIApplication.shared.windows.first{ $0.isKeyWindow }
    }
}

@IBDesignable extension UIView {
    
    @IBInspectable var borderColor:UIColor? {
        set { layer.borderColor = newValue!.cgColor }
        get {
            if let color = layer.borderColor {  return UIColor(cgColor:color) }
            else { return nil }
        }
    }
    
    @IBInspectable var borderWidth:CGFloat {
        set { layer.borderWidth = newValue }
        get { return layer.borderWidth }
    }
    
    @IBInspectable var cornerRadius:CGFloat {
        set {
            layer.cornerRadius = newValue
            clipsToBounds = newValue > 0
        }
        get { return layer.cornerRadius }
    }
}


extension UIView {
    static var viewId: String {
        String(describing: self)
    }
    
    static func nib() -> UINib {
        UINib.init(nibName: viewId, bundle: nil)
    }   
}



extension UITableView {
    func registerCellNib(_ cell: UITableViewCell.Type) {
        self.register(cell.nib(), forCellReuseIdentifier: cell.viewId)
    }
    
    func dequeueCell<T: UITableViewCell>(path: IndexPath? = nil) -> T? {
        if let path = path {
            return self.dequeueReusableCell(withIdentifier: T.viewId, for: path) as? T
        }
        else {
          return self.dequeueReusableCell(withIdentifier: T.viewId) as? T
        }
    }
    
    func registerHeaderFooterNib(_ view: UITableViewHeaderFooterView.Type) {
        self.register(view.nib(), forHeaderFooterViewReuseIdentifier: view.viewId)
    }
    
    func dequeueHeaderFooter<T: UITableViewHeaderFooterView>() -> T? {
        self.dequeueReusableHeaderFooterView(withIdentifier: T.viewId) as? T
    }
}

extension UICollectionView {
    func registerCellNib(_ cell: UICollectionViewCell.Type) {
        self.register(cell.nib(), forCellWithReuseIdentifier: cell.viewId)
    }
    
    func dequeueCell<T: UICollectionViewCell>(path: IndexPath) -> T? {
        self.dequeueReusableCell(withReuseIdentifier: T.viewId, for: path) as? T
    }
}

extension UITextField{
    
    func hideKeyboardInputAssitant(){
        let assistant = self.inputAssistantItem
        assistant.leadingBarButtonGroups = []
        assistant.trailingBarButtonGroups = []
    }
}





