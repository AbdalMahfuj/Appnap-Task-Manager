//
//  Extensions.swift
//  Task Manager
//
//  Created by Mahfuz on 27/6/24.
//

import UIKit

extension UIStoryboard {
    convenience init(storyboard: Storyboard, bundle: Bundle? = nil) {
        self.init(name: storyboard.filename, bundle: bundle)
    }
    
    func instantiateVC<T: UIViewController>() -> T {
        let id = String(describing: T.self)
        
        guard let viewController = self.instantiateViewController(withIdentifier: id) as? T else {
            fatalError("Couldn't instantiate view controller with identifier \(id) ")
        }
        
        return viewController
    }
}






