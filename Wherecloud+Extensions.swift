//
//  Wherecloud+Extensions.swift
//  AnyRun
//
//  Created by Nathaniel Blumer on 2016-02-04.
//  Copyright © 2016 Wherecloud Inc. All rights reserved.
//

import UIKit


enum ViewSide {
    case right
    case left
    case top
    case bottom
}

enum ScreenType: String {
    case iPhone4
    case iPhone5
    case iPhone6
    case iPhone6Plus
    case iPad
    case Unknown
}

extension UIViewController {
    
    func presentViewControllerOverContext(_ viewController: UIViewController, animated: Bool, completion: (() -> Void)?) {
        viewController.modalPresentationStyle = .overCurrentContext
        viewController.modalTransitionStyle = .crossDissolve
        self.present(viewController, animated: animated, completion: completion)
        
    }
    
    func registerForPushNotifications() {
        let settings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
        UIApplication.shared.registerUserNotificationSettings(settings)
        UIApplication.shared.registerForRemoteNotifications()
    }
    
    func isRootChildViewController() -> Bool {
        if let nav = self.navigationController, let rootChild = nav.childViewControllers.first, rootChild == self {
            return true
        } else {
            return false
        }
    }
    
    var className: String {
        return NSStringFromClass(self.classForCoder).components(separatedBy: ".").last!
    }
}

extension UIViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func showImagePickerController() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePickerController.sourceType = .camera
            imagePickerController.showsCameraControls = true
            imagePickerController.cameraCaptureMode = .photo
            imagePickerController.cameraFlashMode = .auto
        } else {
            imagePickerController.sourceType = .photoLibrary
        }
        
        imagePickerController.view.frame = self.view.frame
        
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: NSLocalizedString("Camera", comment:""), style: .default) { [weak self] (action) -> Void in
            imagePickerController.sourceType = .camera
            self?.present(imagePickerController, animated: true, completion: nil)
        }
        
        let libraryAction = UIAlertAction(title: NSLocalizedString("Photos", comment: "Photos"), style: .default) { [weak self] (action) -> Void in
            imagePickerController.sourceType = .photoLibrary
            self?.present(imagePickerController, animated: true, completion: nil)
        }
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) == true { //&& (AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo) != .denied)) {
            alertController.addAction(cameraAction)
        }
        
        alertController.addAction(libraryAction)
        alertController.addCancelAction()
        self.present(alertController, animated: true, completion: nil)
        
        if UI_USER_INTERFACE_IDIOM() == .pad {
            alertController.popoverPresentationController?.sourceView = self.view
        }
    }
}

extension URL {
    static func openTwitter(_ username:String) {
        let url = URL(string: "twitter://user?screen_name=\(username)")!
        if (UIApplication.shared.openURL(url) == false) {
            UIApplication.shared.openURL(URL(string: "https://twitter.com/\(username)")!)
        }
    }
    
    static func openFacebook(_ username:String) {
        let url = URL(string: "https://www.facebook.com/\(username)")!
        if (UIApplication.shared.openURL(url) == false) {
            UIApplication.shared.openURL(URL(string: "https://facebook.com/\(username)")!)
        }
    }
}

extension UIAlertController {
    func addCancelAction() {
        self.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: "Cancel"), style: .default, handler: nil)) //Mark likes when the Cancel is not bolder
    }
}

extension UINavigationController {
    func styleInvisible() {
        self.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationBar.shadowImage = UIImage()
        self.navigationBar.isTranslucent = true
        self.view.backgroundColor = UIColor.clear
    }
    
    func styleVisible() {
        self.navigationBar.setBackgroundImage(nil, for: .default)
        self.navigationBar.shadowImage = nil
        self.navigationBar.isTranslucent = false
        self.view.backgroundColor = UIColor.clear
    }
}

extension Array {
    
    mutating func indexOfObject<T: Equatable>(_ object: T) -> Int? {
        var index: Int?
        for (idx, objectToCompare) in self.enumerated() {
            if let to = objectToCompare as? T{
                if object == to {
                    index = idx
                }
            }
        }
        
        return index
    }
    
    mutating func removeObject<U: Equatable>(_ object: U) {
        var index: Int?
        for (idx, objectToCompare) in self.enumerated() {
            if let to = objectToCompare as? U {
                if object == to {
                    index = idx
                }
            }
        }
        
        if(index != nil) {
            self.remove(at: index!)
        }
    }
}

extension Date {
    
    func toString(_ format:String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}

extension String{
    var length: Int {
        return characters.count
    }
    
    func digitsOnly() -> String {
        return self.components(
            separatedBy: CharacterSet.decimalDigits.inverted).joined(separator: "")
    }
    
    func alphanumericOnly() -> String {
        return self.components(
            separatedBy: CharacterSet.alphanumerics.inverted).joined(separator: "")
    }
    
    func isValidPostalCode() -> Bool {
        let postalRegex: String = "(^[a-zA-Z][0-9][a-zA-Z][- ]*[0-9][a-zA-Z][0-9]$)"
        let postalTest: NSPredicate = NSPredicate(format: "SELF MATCHES %@", postalRegex)
        let postal = self.clearWhiteSpace()
        return postalTest.evaluate(with: postal) && self.isEmpty == false
        
    }
    func isValidEmail() -> Bool {
        let emailRegex: String = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest: NSPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        let email = self.clearWhiteSpace()
        return emailTest.evaluate(with: email) && self.isEmpty == false
    }
    
    ///Remove the white space characters at the end/start of the sentence
    func clearWhiteSpace() -> String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
//    subscript (r: Range<Int>) -> String {
//        get {
//            let startIndex = self.characters.index(self.startIndex, offsetBy: r.lowerBound)
//            let endIndex = String.CharacterView.index(startIndex, offsetBy: r.upperBound - r.lowerBound)
//            
//            return self[startIndex..<endIndex]
//        }
//    }
}

extension UIView {
    func fadeInAnimation() {
        self.alpha = 0.0
        UIView.animate(withDuration: 0.75, animations: { () -> Void in
            self.alpha = 1.0
        })
    }
    
    func addGradient(fromColor color: UIColor, atPoint start: CGPoint? = nil, toColor color2: UIColor, atPoint end: CGPoint? = nil, vertically isVertical: Bool = true, withAlpha alpha: Float = 1.0) -> CAGradientLayer {
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bounds
        gradientLayer.opacity = alpha
        
        gradientLayer.colors = [color.cgColor, color2.cgColor]
        
        if isVertical == true {
            gradientLayer.startPoint = start ?? CGPoint(x: 0, y: 0)
            gradientLayer.endPoint = end ?? CGPoint(x: 0, y: 1)
        } else {
            gradientLayer.startPoint = start ?? CGPoint(x: 0, y: 0)
            gradientLayer.endPoint = end ?? CGPoint(x: 1, y: 0)
        }
        self.layer.insertSublayer(gradientLayer, at: 0)
        
        self.clipsToBounds = true
        return gradientLayer
    }
    
    func addDropShadow(_ color: UIColor = UIColor.black, onSide side: ViewSide = .bottom, withAlpha alpha: Float = 0.4) {
        self.layer.shadowColor = color.cgColor
        self.layer.shadowRadius = 5
        
        switch side {
        case .bottom: self.layer.shadowOffset = CGSize(width: 0, height: 1.5)
        case .top: self.layer.shadowOffset = CGSize(width: 0, height: -1.5)
        case .right: self.layer.shadowOffset = CGSize(width: 1.5, height: 0)
        case .left: self.layer.shadowOffset = CGSize(width: -1.5, height: 0)
        }
        
        self.layer.shadowOpacity = alpha
        self.clipsToBounds = false
    }
    
    func removeDropShadow() {
    
        self.layer.shadowColor = UIColor.clear.cgColor
        self.layer.shadowOpacity = 0.0
        self.clipsToBounds = false
    }
    
    func addBlurView(_ style : UIBlurEffectStyle, sendToBack:Bool) -> UIVisualEffectView {
        let blurView:UIVisualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: style))
        blurView.frame = self.bounds
        self.clipsToBounds = true
        self.addSubview(blurView)
        
        self.backgroundColor = UIColor.clear
        
        if (sendToBack) {
            self.sendSubview(toBack: blurView)
        } else {
            self.addSubview(blurView)
        }
        return blurView
    }
    
    func addUnderline(_ lineWidth: CGFloat, color: UIColor?) {
        let bezier = UIBezierPath()
        
        let bottomLeft = CGPoint(x: self.bounds.origin.x, y: self.bounds.origin.y + self.bounds.height)
        bezier.move(to: bottomLeft)
        bezier.addLine(to: CGPoint(x: self.bounds.size.width, y: self.bounds.origin.y + self.bounds.height))

        let layer = CAShapeLayer()
        layer.path = bezier.cgPath
        
        layer.lineWidth = lineWidth
        if let cgColor = color?.cgColor {
            layer.strokeColor = cgColor
        }
        layer.frame = self.bounds
        self.layer.addSublayer(layer)
        self.clipsToBounds = true
    }
    
    func addTopBorder(_ lineWidth: CGFloat, color: UIColor?) {
        let bezier = UIBezierPath()
        
        let bottomLeft = CGPoint(x: self.bounds.origin.x, y: self.bounds.origin.y)
        bezier.move(to: bottomLeft)
        bezier.addLine(to: CGPoint(x: self.bounds.size.width, y: self.bounds.origin.y))
        
        let layer = CAShapeLayer()
        layer.path = bezier.cgPath
        
        layer.lineWidth = lineWidth
        if let cgColor = color?.cgColor {
            layer.strokeColor = cgColor
        }
        layer.frame = self.bounds
        self.layer.addSublayer(layer)
        self.clipsToBounds = true
    }
    
    ///Crop a circle in the current view
    func addCircularBorder() {
        self.addCircularBorder(UIColor.clear, width: 0.5)
    }
    
    ///Crop a circle in the current view w/ a color and width
    func addCircularBorder(_ color:UIColor, width:CGFloat) {
        self.addBorder(self.frame.height/2, color: color, width: width)
        self.layer.masksToBounds = true
    }
    
    ///Add rounded corners to a view
    func addCornerRadius(_ radius: CGFloat) {
        self.addBorder(radius, color: UIColor.clear, width: 1.0)
        self.layer.masksToBounds = true
    }
    
    ///Add a border of any radius, color & width
    func addBorder(_ cornerRadius:CGFloat, color:UIColor, width:CGFloat) {
        self.layer.borderWidth = width
        self.layer.borderColor = color.cgColor
        self.layer.cornerRadius = cornerRadius
        self.clipsToBounds = true
    }
    
    func clearBorder() {
        self.layer.borderWidth = 0
        self.layer.borderColor = UIColor.clear.cgColor
    }
    
    ///Remove all gesture recognizers from the view
    func removeGestureRecognizers() {
        for gesture in self.gestureRecognizers! {
            self.removeGestureRecognizer(gesture)
        }
    }

}

extension UITableView {
    
    ///Hide all cells that are never dequeued under the 'last' item in the table
    func hideExtraCells() {
        self.tableFooterView = UIView(frame: CGRect.zero)
    }
}

extension UIImageView {
    
    func downloadImageFromStringURL(_ stringUrl: String?, completion: @escaping (_ image: UIImage?) -> Void) {
        
        let dispatchImage: DispatchQueue = DispatchQueue(label: "GET_IMAGE", attributes: [])
        dispatchImage.async { () -> Void in
            
            var image: UIImage?
            if let string = stringUrl, let url = URL(string: string), let data = try? Data(contentsOf: url), let newImage = UIImage(data: data) {
                image = newImage
            }
            
            // Download image
            DispatchQueue.main.async(execute: { () -> Void in
                completion(image)
            })
        }
        
    }
    
}

extension UITextView {
    func removeAllPadding() {
        self.textContainerInset = UIEdgeInsets.zero;
        self.textContainer.lineFragmentPadding = 0;
    }
}

extension Bundle {
    class func versionNumber() -> String {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
        
    }
    
    class func buildNumber() -> String {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as! String
    }
}

extension Locale {
    
    ///Canadian version: "en" || "fr" only
    static func baseLocale() -> String {
        
        let locale = Locale.preferredLanguages.first
        if locale == "fr" || locale == "fr-CA" {
            return "fr"
            
        } else {
            return "en"
        }
    }
}

extension UIBarButtonItem {
    
    class func flexibleSpace () -> UIBarButtonItem {
        let flex = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        return flex
    }
}

extension UIDevice {
    
    class var iPhone: Bool {
        return UIDevice().userInterfaceIdiom == .phone
    }
    
    class var screenType: ScreenType {
        guard iPhone else { return .iPad}
        switch UIScreen.main.nativeBounds.height {
        case 960:
            return .iPhone4
        case 1136:
            return .iPhone5
        case 1334:
            return .iPhone6
        case 2208:
            return .iPhone6Plus
        default:
            return .Unknown
        }
    }
    
}

extension UIWindow {
    public var visibleViewController: UIViewController? {
        return UIWindow.getVisibleViewControllerFrom(self.rootViewController)
    }
    
    public static func getVisibleViewControllerFrom(_ viewController: UIViewController?) -> UIViewController? {
        if let navigationController = viewController as? UINavigationController {
            return UIWindow.getVisibleViewControllerFrom(navigationController.visibleViewController)
        } else if let tabBarController = viewController as? UITabBarController {
            return UIWindow.getVisibleViewControllerFrom(tabBarController.selectedViewController)
        } else {
            if let presentedViewController = viewController?.presentedViewController {
                return UIWindow.getVisibleViewControllerFrom(presentedViewController)
            } else {
                return viewController
            }
        }
    }
}

