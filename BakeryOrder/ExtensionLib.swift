//
//  ExtendCore.swift
//  shot_doctor
//
//  Created by Admin on 5/17/17.
//  Copyright © 2017 BenzCruise. All rights reserved.
//

import Foundation
import UIKit


/**************** Device Extention ***********************/


public extension UIDevice {
    
    var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        switch identifier {
        case "iPod5,1":                                 return "iPod Touch 5"
        case "iPod7,1":                                 return "iPod Touch 6"
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
        case "iPhone4,1":                               return "iPhone 4s"
        case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
        case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
        case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
        case "iPhone7,2":                               return "iPhone 6"
        case "iPhone7,1":                               return "iPhone 6 Plus"
        case "iPhone8,1":                               return "iPhone 6s"
        case "iPhone8,2":                               return "iPhone 6s Plus"
        case "iPhone9,1", "iPhone9,3":                  return "iPhone 7"
        case "iPhone9,2", "iPhone9,4":                  return "iPhone 7 Plus"
        case "iPhone8,4":                               return "iPhone SE"
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
        case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad 3"
        case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad 4"
        case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
        case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
        case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad Mini"
        case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad Mini 2"
        case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad Mini 3"
        case "iPad5,1", "iPad5,2":                      return "iPad Mini 4"
        case "iPad6,3", "iPad6,4", "iPad6,7", "iPad6,8":return "iPad Pro"
        case "AppleTV5,3":                              return "Apple TV"
        case "i386", "x86_64":                          return "Simulator"
        default:                                        return identifier
        }
    }
    
}

struct ScreenSize
{
    static let SCREEN_WIDTH         = UIScreen.main.bounds.size.width
    static let SCREEN_HEIGHT        = UIScreen.main.bounds.size.height
    static let SCREEN_MAX_LENGTH    = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
    static let SCREEN_MIN_LENGTH    = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
}

/****************** Data Model Extention ******************************/

extension String {
    func index(of string: String, options: CompareOptions = .literal) -> Int {
        if string == ""{
            return 0
        }
        if let index = range(of: string, options: options)?.lowerBound{
            return distance(from: startIndex, to: index)
        }
        return -1;
    }
    func endIndex(of string: String, options: CompareOptions = .literal) -> Index? {
        return range(of: string, options: options)?.upperBound
    }
    func indexes(of string: String, options: CompareOptions = .literal) -> [Index] {
        var result: [Index] = []
        var start = startIndex
        while let range = range(of: string, options: options, range: start..<endIndex) {
            result.append(range.lowerBound)
            start = range.upperBound
        }
        return result
    }
    
    func trim() -> String
    {
        return self.trimmingCharacters(in: NSCharacterSet.whitespaces)
    }
    
    func index(from: Int) -> Index {
        return self.index(startIndex, offsetBy: from)
    }
    
    func substring(from: Int) -> String {
        let fromIndex = index(from: from)
        return substring(from: fromIndex)
    }
    
    func substring(to: Int) -> String {
        let toIndex = index(from: to)
        return substring(to: toIndex)
    }
    
    func substring(with r: Range<Int>) -> String {
        let startIndex = index(from: r.lowerBound)
        let endIndex = index(from: r.upperBound)
        return substring(with: startIndex..<endIndex)
    }
    
    subscript(i: Int) -> Character {
        return self[index(startIndex, offsetBy: i)]
    }
    
    subscript(i: Int) -> String {
        return String(self[i] as Character)
    }
    
    subscript(r: Range<Int>) -> String {
        let start = index(startIndex, offsetBy: r.lowerBound)
        let end = index(startIndex, offsetBy: r.upperBound - r.lowerBound)
        return self[Range(start ..< end)]
    }
    
    
    func ranges(of string: String, options: CompareOptions = .literal) -> [Range<Index>] {
        var result: [Range<Index>] = []
        var start = startIndex
        while let range = range(of: string, options: options, range: start..<endIndex) {
            result.append(range)
            start = range.upperBound
        }
        return result
    }
    func addingPercentEncodingForURLQueryValue() -> String? {
        let allowedCharacters = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-._~")
        
        return self.addingPercentEncoding(withAllowedCharacters: allowedCharacters)
    }
    
    func toDate(format: String)->Date{
        //format: "yyyy-MM-dd hh:mm:ss Z", "yyyy-MM-dd"
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.date(from: self)!
    }
    
    init(date: Date, format: String){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format;
        self = dateFormatter.string(from: date)
    }
    
    func isValidEmail() -> Bool {
        print("validate emilId: \(self)")
        let emailRegEx = "^(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?(?:(?:(?:[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+(?:\\.[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+)*)|(?:\"(?:(?:(?:(?: )*(?:(?:[!#-Z^-~]|\\[|\\])|(?:\\\\(?:\\t|[ -~]))))+(?: )*)|(?: )+)\"))(?:@)(?:(?:(?:[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)(?:\\.[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)*)|(?:\\[(?:(?:(?:(?:(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))\\.){3}(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))))|(?:(?:(?: )*[!-Z^-~])*(?: )*)|(?:[Vv][0-9A-Fa-f]+\\.[-A-Za-z0-9._~!$&'()*+,;=:]+))\\])))(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?$"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let result = emailTest.evaluate(with: self)
        return result
    }
    
    func isValidatePhone() -> Bool {
        let PHONE_REGEX = "^\\d{3}-\\d{3}-\\d{4}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result =  phoneTest.evaluate(with: self)
        return result
    }
    
    var length: Int {
        return self.characters.count
    }
    
    func spliteEmoji()->[String]{
        var emojis: [String] = []
        enumerateSubstrings(in: startIndex ..< endIndex, options: .byComposedCharacterSequences) {emoji, _, _, _  in
            if emoji != nil{
                emojis.append(emoji!)
            }
        }
        return emojis;
    }
    
    var isEmoji: Bool {
        for scalar in unicodeScalars {
            switch scalar.value {
            case 0x1F600...0x1F64F, // Emoticons
            0x1F300...0x1F5FF, // Misc Symbols and Pictographs
            0x1F680...0x1F6FF, // Transport and Map
            0x2600...0x26FF,   // Misc symbols
            0x2700...0x27BF,   // Dingbats
            0xFE00...0xFE0F,   // Variation Selectors
            0x1F900...0x1F9FF,  // Supplemental Symbols and Pictographs
            0x1F1E6...0x1F1FF: //Flag
                return true
            default:
                continue
            }
        }
        return false
    }
    
    func convertHtmlString()->NSAttributedString{
        do {
            let attrStr = try NSAttributedString(
                data: self.data(using: String.Encoding.unicode, allowLossyConversion: true)!,
                options: [ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType],
                documentAttributes: nil)
            return attrStr;
        } catch let error {
            print(error.localizedDescription);
            return NSAttributedString();
        }
    }
    
}


extension Dictionary {
    
    func stringFromHttpParameters() -> String {
        let parameterArray = self.map { (key, value) -> String in
            let percentEscapedKey = (key as! String).addingPercentEncodingForURLQueryValue()!
            let percentEscapedValue = (value as! String).addingPercentEncodingForURLQueryValue()!
            return "\(percentEscapedKey)=\(percentEscapedValue)"
        }
        
        return parameterArray.joined(separator: "&")
    }
    
}

extension NSMutableData {
    func appendString(_ string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: false)
        append(data!)
    }
}


extension UIColor{
    convenience init(hex:String) {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        if ((cString.characters.count) != 6) {
            self.init(white: 1, alpha: 1)
            return;
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        let red = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0;
        let green = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0;
        let blue = CGFloat(rgbValue & 0x0000FF) / 255.0;
        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    func toHexString() -> String {
        let rgb = self.toInt();
        return NSString(format:"#%06x", rgb) as String
    }
    
    func toInt()->Int{
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        
        getRed(&r, green: &g, blue: &b, alpha: &a)
        
        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        return rgb;
    }
    
    func getRvalue()->CGFloat{
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: &a)
        return r;
    }
    func getGvalue()->CGFloat{
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: &a)
        return g;
    }
    func getBvalue()->CGFloat{
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: &a)
        return b;
    }
}

/********************* UIKit Extention *********************/

extension UIViewController: UIGestureRecognizerDelegate {
    
    func presentDetail(_ viewControllerToPresent: UIViewController) {
        DispatchQueue.main.async {
            let transition = CATransition()
            transition.duration = 0.25
            transition.type = kCATransitionPush
            transition.subtype = kCATransitionFromRight
            self.view.window!.layer.add(transition, forKey: kCATransition)
            self.present(viewControllerToPresent, animated: false, completion: nil);
        }
    }
    
    func dismissDetail() {
        
        let transition = CATransition()
        transition.duration = 0.25
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromLeft
        self.view.window!.layer.add(transition, forKey: kCATransition)
        self.dismiss(animated: false, completion: nil)
    }
    
    func dismiss(){
        self.dismiss(animated: true, completion: nil)
    }
    
    func setDismissKeyboard(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap))
        tap.delegate = self
        self.view.addGestureRecognizer(tap)
    }
    
    func handleTap(sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
}

@IBDesignable
class GradientView: UIView {
    
    @IBInspectable var startColor:   UIColor = .black { didSet { updateColors() }}
    @IBInspectable var endColor:     UIColor = .white { didSet { updateColors() }}
    @IBInspectable var startLocation: Double =   0.05 { didSet { updateLocations() }}
    @IBInspectable var endLocation:   Double =   0.95 { didSet { updateLocations() }}
    @IBInspectable var horizontalMode:  Bool =  false { didSet { updatePoints() }}
    @IBInspectable var diagonalMode:    Bool =  false { didSet { updatePoints() }}
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    @IBInspectable var borderColor: UIColor? {
        didSet {
            layer.borderColor = borderColor?.cgColor
        }
    }
    
    override class var layerClass: AnyClass { return CAGradientLayer.self }
    
    var gradientLayer: CAGradientLayer { return layer as! CAGradientLayer }
    
    func updatePoints() {
        if horizontalMode {
            gradientLayer.startPoint = diagonalMode ? CGPoint(x: 1, y: 0) : CGPoint(x: 0, y: 0.5)
            gradientLayer.endPoint   = diagonalMode ? CGPoint(x: 0, y: 1) : CGPoint(x: 1, y: 0.5)
        } else {
            gradientLayer.startPoint = diagonalMode ? CGPoint(x: 0, y: 0) : CGPoint(x: 0.5, y: 0)
            gradientLayer.endPoint   = diagonalMode ? CGPoint(x: 1, y: 1) : CGPoint(x: 0.5, y: 1)
        }
    }
    func updateLocations() {
        gradientLayer.locations = [startLocation as NSNumber, endLocation as NSNumber]
    }
    func updateColors() {
        gradientLayer.colors    = [startColor.cgColor, endColor.cgColor]
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updatePoints()
        updateLocations()
        updateColors()
    }
}


class DialogView: UIView {
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    @IBInspectable var borderColor: UIColor? {
        didSet {
            layer.borderColor = borderColor?.cgColor
        }
    }
    @IBInspectable var shadowSize: CGFloat = 2{
        didSet{
            self.layer.masksToBounds = false
            
            self.layer.shadowColor = UIColor.black.cgColor
            self.layer.shadowOpacity = 0.5
            self.layer.shadowOffset = CGSize(width: 2, height: 2)
            self.layer.shadowRadius = shadowSize;
            
            // self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
            //self.layer.shouldRasterize = true
        }
    }
    
    public func show(){
        self.isHidden = false
        self.alpha = 0;
        UIView.animate(withDuration: 0.5, delay: 0.1, options: [],
                       animations: {
                        self.alpha = 1
        }, completion: {finished in
            
        })
    }
    
    public func hide(){
        UIView.animate(withDuration: 0.3, delay: 0.1, options: [],
                       animations: {
                        self.alpha = 0
        }, completion: {finished in
            self.isHidden = true
        })
    }
    
}

extension UITableView {
    func scrollToBottom(animated: Bool) {
        let y = contentSize.height - frame.size.height
        setContentOffset(CGPoint(x: 0, y: (y<0) ? 0 : y), animated: animated)
    }
}

import UIKit
@IBDesignable
class EffectView: UIView {
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    @IBInspectable var borderColor: UIColor? {
        didSet {
            layer.borderColor = borderColor?.cgColor
        }
    }
    
    @IBInspectable var shawdowColor: UIColor = UIColor.black {
        didSet {
            self.layer.shadowColor = shawdowColor.cgColor;
        }
    }
    
    @IBInspectable var shawdowOpacity: Float = 0.3 {
        didSet {
            self.layer.shadowOpacity = shawdowOpacity
        }
    }
    
    @IBInspectable var shawdowX: CGFloat = 0.3 {
        didSet {
            self.layer.shadowOffset = CGSize(width: shawdowX, height: shawdowY)
        }
    }
    
    @IBInspectable var shawdowY: CGFloat = 0.3 {
        didSet {
            self.layer.shadowOffset = CGSize(width: shawdowX, height: shawdowY)
        }
    }
    
    @IBInspectable var shadowSize: CGFloat = 2{
        didSet{
            self.layer.masksToBounds = false
            self.layer.shadowRadius = shadowSize
            
            // self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
            //self.layer.shouldRasterize = true
        }
    }
    
    
    
    public func show(){
        self.isHidden = false
        UIView.animate(withDuration: 0.3, delay: 0.1, options: [],
                       animations: {
                        self.alpha = 1
        }, completion: {finished in
            
        })
    }
    
    public func hide(){
        UIView.animate(withDuration: 0.3, delay: 0.1, options: [],
                       animations: {
                        self.alpha = 0
        }, completion: {finished in
            self.isHidden = true
        })
    }
    
}


class ExtentionImageView: UIImageView{
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    @IBInspectable var borderColor: UIColor? {
        didSet {
            layer.borderColor = borderColor?.cgColor
        }
    }
    @IBInspectable var shadowSize: CGFloat = 2{
        didSet{
            self.layer.masksToBounds = false
            self.layer.shadowColor = UIColor.black.cgColor
            self.layer.shadowOpacity = 0.5
            self.layer.shadowOffset = CGSize(width: 2, height: 2)
            self.layer.shadowRadius = shadowSize;
        }
    }
}

extension Date{
    public static func getCurrentMillis()->Int64 {
        return Int64(Date().timeIntervalSince1970 * 1000)
    }
}

extension UIImageView {
    func rotateImage(duration: CFTimeInterval=5, completionDelegate: CAAnimationDelegate?=nil) {
        
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotationAnimation.fromValue = 0.0
        rotationAnimation.toValue = CGFloat(.pi * 8.0)
        rotationAnimation.duration = duration
        
        if let delegate: CAAnimationDelegate = completionDelegate  {
            rotationAnimation.delegate = delegate
        }
        
        self.layer.add(rotationAnimation, forKey: nil)
    }
    
    func fadeIn() {
        UIImageView.animate(withDuration:1.5, delay: 0.0, options: UIViewAnimationOptions.curveEaseIn, animations:{
            self.alpha = 1.0
        }, completion: nil)
    }
    
    func fadeOut() {
        UIImageView.animate(withDuration: 1.5, delay: 0.0, options: UIViewAnimationOptions.curveEaseIn, animations: {
            self.alpha = 0.0
        }, completion: nil)
    }
}

class UILabelDeviceClass : UILabel {
    
    @IBInspectable var iPhoneFontSize:CGFloat = 0 {
        didSet {
            overrideFontSize(fontSize: iPhoneFontSize)
        }
    }
    
    func overrideFontSize(fontSize: CGFloat){
        let currentFontName = self.font.fontName
        var calculatedFont: UIFont?
        let bounds = UIScreen.main.bounds
        let height = bounds.size.height
        switch height {
        case 480.0: //Iphone 3,4,SE => 3.5 inch
            calculatedFont = UIFont(name: currentFontName, size: fontSize * 0.7)
            self.font = calculatedFont
            break
        case 568.0: //iphone 5, 5s => 4 inch
            calculatedFont = UIFont(name: currentFontName, size: fontSize * 0.8)
            self.font = calculatedFont
            break
        case 667.0: //iphone 6, 6s => 4.7 inch
            calculatedFont = UIFont(name: currentFontName, size: fontSize * 0.9)
            self.font = calculatedFont
            break
        case 736.0: //iphone 6s+ 6+ => 5.5 inch
            calculatedFont = UIFont(name: currentFontName, size: fontSize)
            self.font = calculatedFont
            break
        default:
            print("not an iPhone")
            break
        }
    }
    
}

extension NSLayoutConstraint {
    func constraintWithMultiplier(_ multiplier: CGFloat) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: self.firstItem, attribute: self.firstAttribute, relatedBy: self.relation, toItem: self.secondItem, attribute: self.secondAttribute, multiplier: multiplier, constant: self.constant)
    }
}


class PlaceHolderTextField: UITextField {
    
    @IBInspectable var placehoderColor: UIColor = UIColor.white {
        didSet {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSForegroundColorAttributeName: self.placehoderColor])
        }
    }
    
    @IBInspectable var cursorColor: UIColor = UIColor.white {
        didSet {
            self.tintColor = cursorColor;
        }
    }
}

class TextField: UITextField {
    @IBInspectable var insetX: CGFloat = 0
    @IBInspectable var insetY: CGFloat = 0
    
    // placeholder position
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: insetX, dy: insetY);
    }
    
    // text position
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: insetX, dy: insetY);
    }
}


func round(_ value: Double, toNearest: Double) -> Double {
    return Darwin.round(value / toNearest) * toNearest
}









