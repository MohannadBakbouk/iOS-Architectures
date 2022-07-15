//
//  Extentions.swift
//  MVVMArchitecture
//
//  Created by Mohannad on 12/06/21.
//

import Foundation
import UIKit


extension UIViewController
{
    class func instantiateFromStoryboard(_ name: String = "Main") -> Self
    {
        return instantiateFromStoryboardHelper(name)
    }

    fileprivate class func instantiateFromStoryboardHelper<T>(_ name: String) -> T
    {
        let storyboard = UIStoryboard(name: name, bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: String(describing: self)) as! T
        return controller
    }
}



extension  UIView {
    
    func anchor(top : NSLayoutYAxisAnchor? , paddingTop : CGFloat , bottom : NSLayoutYAxisAnchor? , paddingBottom : CGFloat , left: NSLayoutXAxisAnchor?, paddingLeft: CGFloat, right: NSLayoutXAxisAnchor?, paddingRight: CGFloat, width: CGFloat, height: CGFloat){
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: paddingBottom).isActive = true
        }
        
        if let left = left {
            leadingAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }
        
        if let right = right {
            trailingAnchor.constraint(equalTo: right, constant: paddingRight).isActive = true
        }
        
        if  width != 0 {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        if  height != 0 {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        
        }
    }
    
    func proportionalSize(width : NSLayoutDimension? , widthPercent : CGFloat,
                          height : NSLayoutDimension? , heightPercent : CGFloat)  {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if  let width = width {
            widthAnchor.constraint(equalTo: width , multiplier: widthPercent).isActive = true
        }
        
        if  let height = height {
            heightAnchor.constraint(equalTo: height , multiplier: heightPercent).isActive = true
        }
    }
    
    
    
    
    func setSize( width : CGFloat ,  height : CGFloat)  {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if  width != 0 {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        if  height != 0 {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        
        }
    }
    
    
    func center(centerX : NSLayoutXAxisAnchor? , centerY : NSLayoutYAxisAnchor?)  {
        
        self.center(centerX: centerX, paddingX: 0, centerY: centerY, paddingY: 0)
       
    }
    
    func center(centerX : NSLayoutXAxisAnchor? , paddingX : CGFloat   , centerY : NSLayoutYAxisAnchor? , paddingY : CGFloat)  {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let centerX = centerX {
         centerXAnchor.constraint(equalTo: centerX , constant: paddingX).isActive = true
        }
        
        if let centerY = centerY {
         centerYAnchor.constraint(equalTo: centerY , constant: paddingY).isActive = true
        }
        

    }
    
    
    
    
    
}


extension UICollectionView {
    
    func setMessage(_ message : String , icon : String){
        
        let view = UIView()
        let size = self.frame
        self.backgroundView = view
        
        let msgLab = UILabel()
        msgLab.textAlignment = .center
        msgLab.textColor = .lightGray
        msgLab.numberOfLines = 2
        msgLab.text = message
        view.addSubview(msgLab)

     
        let img  = UIImageView()
        img.image = UIImage(systemName: icon)!
        img.tintColor = .lightGray
        img.contentMode = .scaleAspectFit
        view.addSubview(img)
        
        img.translatesAutoresizingMaskIntoConstraints = false
        msgLab.translatesAutoresizingMaskIntoConstraints = false

        img.setSize(width: 50, height: 50)
        img.center(centerX: view.centerXAnchor , paddingX: 0 , centerY: view.centerYAnchor , paddingY: -50)
        msgLab.anchor(top: img.bottomAnchor, paddingTop: 10, bottom: nil, paddingBottom: 0, left: view.leadingAnchor, paddingLeft: 10, right: view.trailingAnchor, paddingRight: -10, width: 0, height: 30)
    
    }
    
    func toggleActivityIndicator()  {
        
        if let indicator = backgroundView as? UIActivityIndicatorView {
            indicator.stopAnimating()
            indicator.removeFromSuperview()
        }
        else {
            let indicator = UIActivityIndicatorView()
            indicator.style = .whiteLarge
            indicator.color = .red
            indicator.hidesWhenStopped = true
            backgroundView = indicator
            indicator.startAnimating()
        }
    }
}
