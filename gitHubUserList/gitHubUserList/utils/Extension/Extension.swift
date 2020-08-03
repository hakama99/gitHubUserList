import UIKit
import ImageIO
import SwiftyJSON

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
    
    convenience init(hex: String) {
        let str = hex.replace2(target: "#",withString: "")
        
        let r = str.substring(from: 0,count: 2).strHex2Int()
        let g = str.substring(from: 2,count: 2).strHex2Int()
        let b = str.substring(from: 4,count: 2).strHex2Int()
         //let str = hex.replace2(target: "#",withString: "0x")
        self.init(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: 1.0)
    }
}
extension Array{
    var last: Element?{
        guard self.count>0 else{
            return nil
        }
        return self[self.endIndex-1]
    }
}
extension String{
    func replace2(target: String, withString: String) -> String
    {
        return self.replacingOccurrences(of: target, with: withString, options: NSString.CompareOptions.literal, range: nil)
    }
    

    func strHex2Int() -> Int
    {
        if !self.isEmpty && self.count>0{
            let int = Int(self, radix: 16)
            return int!
        }
        else{
            return 0
        }
    }
    
    func IntValue() -> Int
    {
        if !self.isEmpty,
            self.count>0,
            let int = Int(self, radix: 10){
            return int
        }
        else{
            return 0
        }
    }
    
    public func substring(from index: Int) -> String {
        if !self.isEmpty && index>=0 && self.count > index {
            let startIndex = self.index(self.startIndex, offsetBy: index)
            let subString = self[startIndex..<self.endIndex]
            
            return String(subString)
        } else {
            return self
        }
    }
    
    public func substring(from index: Int,count:Int) -> String {
        if !self.isEmpty && index>=0 && count>0 && self.count > index {
            if self.count > index+count{
                let startIndex = self.index(self.startIndex, offsetBy: index)
                let endIndex = self.index(self.startIndex, offsetBy: index+count)
                let subString = self[startIndex..<endIndex]
                
                return String(subString)
            }else{
                let startIndex = self.index(self.startIndex, offsetBy: index)
                let subString = self[startIndex..<self.endIndex]
                return String(subString)
            }
        } else {
            return self
        }
    }
    
    func urlEncoded()->String{
        let encodeUrlString = self.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        return encodeUrlString ?? ""
    }
    
    func urlDecoded()->String{
        return self.removingPercentEncoding ?? ""
    }

    func index(of char: Character) -> Int?{
        let index = self.firstIndex(of: char)
        if index != nil{
            return self.distance(from: startIndex, to: index!)
        }
        return nil
    }
    
    func toAttr()->NSMutableAttributedString{
        return NSMutableAttributedString.init(string: self)
    }
    
    func textSize(font:UIFont,width:CGFloat=0)->CGSize
    {
        let label:UILabel=UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat(MAXFLOAT)))
        label.numberOfLines=width==0 ? 1 : 0
        label.lineBreakMode=NSLineBreakMode.byWordWrapping
        label.font=font
        label.text=self
        label.sizeToFit()
        
        return label.frame.size
    }
    
    func weekDay()->Int?{
        if Calendar.current.shortWeekdaySymbols.contains(self){
            return Calendar.current.shortWeekdaySymbols.index(of: self)
        }
        if Calendar.current.weekdaySymbols.contains(self){
            return Calendar.current.weekdaySymbols.index(of: self)
        }
        return nil
    }
}

extension NSAttributedString{
    func textSize(font:UIFont,width:CGFloat=0)->CGSize
    {
        let label:UILabel=UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat(MAXFLOAT)))
        label.numberOfLines=width==0 ? 1 : 0
        label.lineBreakMode=NSLineBreakMode.byWordWrapping
        label.font=font
        label.attributedText=self
        label.sizeToFit()
        
        return label.frame.size
    }
}

extension Int{

    func Int2strHex()-> String
    {
        let str = String(self, radix: 16)
        return str
    }
    
    
    func StrValue(_ count:Int)-> String
    {
        return String(format: "%0"+String(count)+"d", self)
    }
}

extension NSMutableAttributedString{
    func foreColor(color:UIColor)->NSMutableAttributedString{
        self.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: self.allRange())
        return self
    }
    func font(font:UIFont)->NSMutableAttributedString{
        self.addAttribute(NSAttributedString.Key.font, value: font, range: self.allRange())
        return self
    }
    func underline()->NSMutableAttributedString{
        self.addAttribute(NSAttributedString.Key.underlineStyle, value: 1, range: self.allRange())
        return self
    }
    func align(align:NSTextAlignment)->NSMutableAttributedString{
        let para = NSMutableParagraphStyle.init()
        para.alignment = align
        self.addAttribute(NSAttributedString.Key.paragraphStyle, value: para, range: self.allRange())
        return self
    }
    func allRange()->NSRange{
        return NSMakeRange(0, self.length)
    }
}


class GeneralExtension{

    static func DateToStr(date:Date,format:String = "yyyy/MM/dd HH:mm:ss")->(String){
        let timeFormatter = DateFormatter()
        //timeFormatter.locale = Locale.init(identifier: "zh_Hant_TW")
        //timeFormatter.timeZone=TimeZone.init(identifier: "Asia/Taipei")
        timeFormatter.dateFormat = format
        
        let nowTimestr = timeFormatter.string(from: date)
        return nowTimestr
    }
    

    static func StrToDate(dateStr:String,format:String = "yyyy/MM/dd HH:mm:ss")->(Date){
        var cbDate:Date = Date()
        if(!dateStr.isEmpty){
            do {
                let dateFormatter=DateFormatter()
                //dateFormatter.locale = Locale.init(identifier: "zh_Hant_TW")
                //dateFormatter.timeZone=TimeZone.init(identifier: "Asia/Taipei")
                dateFormatter.dateFormat=format
                let tmpDate = dateFormatter.date(from: dateStr)
                if let tmpDate = tmpDate{
                    cbDate = tmpDate
                }
            }catch{
                print(error)
                return cbDate
            }
        }
        return cbDate
    }
    
    static func isSameDay(date1:Date, date2: Date) -> Bool {
        if date1.year() == date2.year(),
            date1.month() == date2.month(),
            date1.day() == date2.day(){
            return true
        }
        return false
    }

    
    static func daysBetweenDate(fromDate:Date, toDate: Date) -> Int {
        let components = Calendar.current.dateComponents([.day], from: fromDate, to: toDate)
        return components.day ?? 0
    }
    
    static func AttributeColor(str:String, color:UIColor) -> NSMutableAttributedString{
        let myMutableString = NSMutableAttributedString(string: str)
        myMutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: NSRange(location: 0, length: str.count))
            return myMutableString
    }
    
    static func imageWithColor(color:UIColor)->UIImage{
        let rect = CGRect.init(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context=UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.addRect(rect)
        let theImage=UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return theImage!
    }
}




extension UIImageView {
    
    public func loadGif(name: String) {
        DispatchQueue.global().async {
            let image = UIImage.gif(name: name)
            DispatchQueue.main.async {
                self.image = image
            }
        }
    }
    
    @available(iOS 9.0, *)
    public func loadGif(asset: String) {
        DispatchQueue.global().async {
            let image = UIImage.gif(asset: asset)
            DispatchQueue.main.async {
                self.image = image
            }
        }
    }
    func downloaded(from url: URL, defaultImg: String = "", contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else {
                    guard
                        let image = UIImage(named: defaultImg) else{return}
                        DispatchQueue.main.async() {
                            self.image = image
                        }
                    return
            }
            DispatchQueue.main.async() {
                self.image = image
            }
            }.resume()
    }
    func downloaded(from link: String, defaultImg: String = "", reSize : CGSize) {
        contentMode = .center
        guard let url = URL(string: link) else {
            guard
                let image = UIImage(named: defaultImg) else{return}
            self.image = image
            return
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else {
                    guard
                        let image = UIImage(named: defaultImg) else{return}
                        DispatchQueue.main.async() {
                            self.image = image.reSizeImage(reSize: reSize)
                        }
                    return
            }
            DispatchQueue.main.async() {
                self.image = image.reSizeImage(reSize: reSize)
            }
            }.resume()
    }
    func downloaded(from link: String, defaultImg: String = "", contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else {
            guard
                let image = UIImage(named: defaultImg) else{return}
            self.image = image
            return
        }
        downloaded(from: url, defaultImg: defaultImg, contentMode: mode)
    }


}

extension UIImage {
    /**

     */
    func reSizeImage(reSize:CGSize)->UIImage {
        //UIGraphicsBeginImageContext(reSize);
        UIGraphicsBeginImageContextWithOptions(reSize,false,UIScreen.main.scale);
        self.draw(in: CGRect(x: 0, y: 0, width: reSize.width, height: reSize.height));
        let reSizeImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!;
        UIGraphicsEndImageContext();
        return reSizeImage;
    }
     
    /**
 
     */
    func scaleImage(scaleSize:CGFloat)->UIImage {
        let reSize = CGSize(width: self.size.width * scaleSize, height: self.size.height * scaleSize)
        return reSizeImage(reSize: reSize)
    }
    
    public class func gif(data: Data) -> UIImage? {
        // Create source from data
        guard let source = CGImageSourceCreateWithData(data as CFData, nil) else {
            print("SwiftGif: Source for the image does not exist")
            return nil
        }
        
        return UIImage.animatedImageWithSource(source)
    }
    
    public class func gif(url: String) -> UIImage? {
        // Validate URL
        guard let bundleURL = URL(string: url) else {
            print("SwiftGif: This image named \"\(url)\" does not exist")
            return nil
        }
        
        // Validate data
        guard let imageData = try? Data(contentsOf: bundleURL) else {
            print("SwiftGif: Cannot turn image named \"\(url)\" into NSData")
            return nil
        }
        
        return gif(data: imageData)
    }
    
    public class func gif(name: String) -> UIImage? {
        // Check for existance of gif
        guard let bundleURL = Bundle.main
            .url(forResource: name, withExtension: "gif") else {
                print("SwiftGif: This image named \"\(name)\" does not exist")
                return nil
        }
        
        // Validate data
        guard let imageData = try? Data(contentsOf: bundleURL) else {
            print("SwiftGif: Cannot turn image named \"\(name)\" into NSData")
            return nil
        }
        
        return gif(data: imageData)
    }
    
    @available(iOS 9.0, *)
    public class func gif(asset: String) -> UIImage? {
        // Create source from assets catalog
        guard let dataAsset = NSDataAsset(name: asset) else {
            print("SwiftGif: Cannot turn image named \"\(asset)\" into NSDataAsset")
            return nil
        }
        
        return gif(data: dataAsset.data)
    }
    
    internal class func delayForImageAtIndex(_ index: Int, source: CGImageSource!) -> Double {
        var delay = 0.1
        
        // Get dictionaries
        let cfProperties = CGImageSourceCopyPropertiesAtIndex(source, index, nil)
        let gifPropertiesPointer = UnsafeMutablePointer<UnsafeRawPointer?>.allocate(capacity: 0)
        defer {
            gifPropertiesPointer.deallocate()
        }
        let unsafePointer = Unmanaged.passUnretained(kCGImagePropertyGIFDictionary).toOpaque()
        if CFDictionaryGetValueIfPresent(cfProperties, unsafePointer, gifPropertiesPointer) == false {
            return delay
        }
        
        let gifProperties: CFDictionary = unsafeBitCast(gifPropertiesPointer.pointee, to: CFDictionary.self)
        
        // Get delay time
        var delayObject: AnyObject = unsafeBitCast(
            CFDictionaryGetValue(gifProperties,
                                 Unmanaged.passUnretained(kCGImagePropertyGIFUnclampedDelayTime).toOpaque()),
            to: AnyObject.self)
        if delayObject.doubleValue == 0 {
            delayObject = unsafeBitCast(CFDictionaryGetValue(gifProperties,
                                                             Unmanaged.passUnretained(kCGImagePropertyGIFDelayTime).toOpaque()), to: AnyObject.self)
        }
        
        if let delayObject = delayObject as? Double, delayObject > 0 {
            delay = delayObject
        } else {
            delay = 0.1 // Make sure they're not too fast
        }
        
        return delay
    }
    
    internal class func gcdForPair(_ lhs: Int?, _ rhs: Int?) -> Int {
        var lhs = lhs
        var rhs = rhs
        // Check if one of them is nil
        if rhs == nil || lhs == nil {
            if rhs != nil {
                return rhs!
            } else if lhs != nil {
                return lhs!
            } else {
                return 0
            }
        }
        
        // Swap for modulo
        if lhs! < rhs! {
            let ctp = lhs
            lhs = rhs
            rhs = ctp
        }
        
        // Get greatest common divisor
        var rest: Int
        while true {
            rest = lhs! % rhs!
            
            if rest == 0 {
                return rhs! // Found it
            } else {
                lhs = rhs
                rhs = rest
            }
        }
    }
    
    internal class func gcdForArray(_ array: [Int]) -> Int {
        if array.isEmpty {
            return 1
        }
        
        var gcd = array[0]
        
        for val in array {
            gcd = UIImage.gcdForPair(val, gcd)
        }
        
        return gcd
    }
    
    internal class func animatedImageWithSource(_ source: CGImageSource) -> UIImage? {
        let count = CGImageSourceGetCount(source)
        var images = [CGImage]()
        var delays = [Int]()
        
        // Fill arrays
        for index in 0..<count {
            // Add image
            if let image = CGImageSourceCreateImageAtIndex(source, index, nil) {
                images.append(image)
            }
            
            // At it's delay in cs
            let delaySeconds = UIImage.delayForImageAtIndex(Int(index),
                                                            source: source)
            delays.append(Int(delaySeconds * 1000.0)) // Seconds to ms
        }
        
        // Calculate full duration
        let duration: Int = {
            var sum = 0
            
            for val: Int in delays {
                sum += val
            }
            
            return sum
        }()
        
        // Get frames
        let gcd = gcdForArray(delays)
        var frames = [UIImage]()
        
        var frame: UIImage
        var frameCount: Int
        for index in 0..<count {
            frame = UIImage(cgImage: images[Int(index)])
            frameCount = Int(delays[Int(index)] / gcd)
            
            for _ in 0..<frameCount {
                frames.append(frame)
            }
        }
        
        // Heyhey
        let animation = UIImage.animatedImage(with: frames,
                                              duration: Double(duration) / 1000.0)
        return animation
    }
    
    
    internal class func imageWithSource(_ source: CGImageSource) -> [UIImage]? {
        let count = CGImageSourceGetCount(source)
        var images = [CGImage]()
        var delays = [Int]()
        
        // Fill arrays
        for index in 0..<count {
            // Add image
            if let image = CGImageSourceCreateImageAtIndex(source, index, nil) {
                images.append(image)
            }
            
            // At it's delay in cs
            let delaySeconds = UIImage.delayForImageAtIndex(Int(index),
                                                            source: source)
            delays.append(Int(delaySeconds * 1000.0)) // Seconds to ms
        }
        
        // Calculate full duration
        let duration: Int = {
            var sum = 0
            
            for val: Int in delays {
                sum += val
            }
            
            return sum
        }()
        
        // Get frames
        let gcd = gcdForArray(delays)
        var frames = [UIImage]()
        
        var frame: UIImage
        var frameCount: Int
        for index in 0..<count {
            frame = UIImage(cgImage: images[Int(index)])
            frameCount = Int(delays[Int(index)] / gcd)
            
            for _ in 0..<frameCount {
                frames.append(frame)
            }
        }
        
        // Heyhey
        //let animation = UIImage.animatedImage(with: frames,duration: Double(duration) / 1000.0)
        return frames
    }
}

extension UIButton {
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }}
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }}
    
    @IBInspectable var borderColor: UIColor? {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }    
}

extension UIView {
        
    @IBInspectable var viewCornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }}
    
    @IBInspectable var viewBorderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }}
    
    @IBInspectable var viewBorderColor: UIColor? {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
    
    func findViewController() -> UIViewController? {
        if let nextResponder = self.next as? UIViewController {
            return nextResponder
        } else if let nextResponder = self.next as? UIView {
            return nextResponder.findViewController()
        } else {
            return nil
        }
    }
    //
    func setViewShadow(shadowOffset: CGSize, shadowColor: CGColor, shadowOpacity: Float = 1.0,  shadowRadius: CGFloat? = nil, cornerRadius: CGFloat? = nil){
        if let cornerRadius = cornerRadius{
            layer.cornerRadius = cornerRadius
        }
        if let shadowRadius = shadowRadius{
            layer.shadowRadius = shadowRadius
        }
        layer.shadowOpacity = shadowOpacity
        layer.shadowOffset = shadowOffset
        layer.shadowColor = shadowColor
    }
    //
    func customCorners(corners: CACornerMask, radius: CGFloat, bounds: Bool? = nil){
        if bounds != nil{
            clipsToBounds = bounds!
        }
        layer.cornerRadius = radius
        if #available(iOS 11.0, *) {
            layer.maskedCorners = corners
        } else {
            // Fallback on earlier versions
        }
    }
}

extension Date {
    func daysBetweenDate(toDate: Date) -> Int {
        let components = Calendar.current.dateComponents([.day], from: self, to: toDate)
        return components.day ?? 0
    }
    
    func hoursBetweenDate(toDate: Date) -> Int {
        let components = Calendar.current.dateComponents([.hour], from: self, to: toDate)
        return components.hour ?? 0
    }
    
    //MARK:
    func year() ->Int {
        let calendar = NSCalendar.current
        let com = calendar.dateComponents([.year,.month,.day], from: self)
        return com.year!
    }
    //MARK:
    func month() ->Int {
        let calendar = NSCalendar.current
        let com = calendar.dateComponents([.year,.month,.day], from: self)
        return com.month!
        
    }
    //MARK:
    func day() ->Int {
        let calendar = NSCalendar.current
        let com = calendar.dateComponents([.year,.month,.day], from: self)
        return com.day!
        
    }
    //MARK:
    func hour() ->Int {
        let calendar = NSCalendar.current
        let com = calendar.dateComponents([.year,.month,.day,.hour], from: self)
        return com.hour!
        
    }

    func weekDay()->Int{
        let interval = Int(self.timeIntervalSince1970)+NSTimeZone.local.secondsFromGMT()
        let days = Int(interval/86400) // 24*60*60
        let weekday = ((days + 4)%7+7)%7
        return weekday
    }

    func countOfDaysInMonth() ->Int {
        let calendar = Calendar(identifier:Calendar.Identifier.gregorian)
        let range = (calendar as NSCalendar?)?.range(of: NSCalendar.Unit.day, in: NSCalendar.Unit.month, for: self)
        return (range?.length)!
        
    }

    func firstWeekDay() ->Int {
        //1.Sun. 2.Mon. 3.Thes. 4.Wed. 5.Thur. 6.Fri. 7.Sat.
        let calendar = Calendar(identifier:Calendar.Identifier.gregorian)
        let firstWeekDay = (calendar as NSCalendar?)?.ordinality(of: NSCalendar.Unit.weekday, in: NSCalendar.Unit.weekOfMonth, for: self)
        return firstWeekDay! - 1
        
    }

    func isToday()->Bool {
        let calendar = NSCalendar.current
        let com = calendar.dateComponents([.year,.month,.day], from: self)
        let comNow = calendar.dateComponents([.year,.month,.day], from: Date())
        return com.year == comNow.year && com.month == comNow.month && com.day == comNow.day
    }

    func isYesterday()->Bool {
        let calendar = NSCalendar.current
        let com = calendar.dateComponents([.year,.month,.day], from: self)
        let comNow = calendar.dateComponents([.year,.month,.day], from: Date())
        return com.year == comNow.year && com.month == comNow.month && com.day == (comNow.day! - 1)
    }

    func isThisMonth()->Bool {
        let calendar = NSCalendar.current
        let com = calendar.dateComponents([.year,.month,.day], from: self)
        let comNow = calendar.dateComponents([.year,.month,.day], from: Date())
        return com.year == comNow.year && com.month == comNow.month
    }
    func convertToString(dateFormat: String) -> String{
        let dateFormatter = DateFormatter.init()
        dateFormatter.dateFormat = dateFormat
        let dateStr = dateFormatter.string(from: self)
        return dateStr
    }
}

extension Float
{
    func format(f:String) ->String
    {
        return String(format:"%\(f)f",self)
    }
}

extension UITextField{
    func setLeftIcon(_ icon: UIImage,_ padding:Int,_ size:Int){
        let outerView = UIView(frame:CGRect(x: 0,y: 0,width: size+padding,height: size))
        let iconView = UIImageView(frame: CGRect(x: padding,y: 0,width: size,height: size))
        iconView.image = icon
        outerView.addSubview(iconView)
        
        leftView = outerView
        leftViewMode = .always
    }

    func unsetLeftIcon(){
        leftView = nil
        leftViewMode = .never
    }

    func setRightIcon(_ icon: UIImage,_ padding:Int,_ size:Int){
        let outerView = UIView(frame:CGRect(x: 0,y: 0,width: size+padding,height: size))
        let iconView = UIImageView(frame: CGRect(x: padding,y: 0,width: size,height: size))
        iconView.image = icon
        outerView.addSubview(iconView)
        
        rightView = outerView
        rightViewMode = .always
    }

    func unsetRightIcon(){
        rightView = nil
        rightViewMode = .never
    }

    func setButtomBorder(color: CGColor, backgroundColor: CGColor = UIColor.white.cgColor){
        self.borderStyle = .none
        self.layer.backgroundColor = backgroundColor
        
        self.layer.masksToBounds = false
        self.layer.shadowColor = color
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
    }
    ///placeholder color
    @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: newValue!])
        }
    }
    
    @IBInspectable var textFieldCornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }}
    
    @IBInspectable var textFieldBorderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }}
    
    @IBInspectable var textFieldBorderColor: UIColor? {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
    @IBInspectable var paddingLeftCustom: CGFloat {
        get {
            return leftView!.frame.size.width
        }
        set {
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: newValue, height: frame.size.height))
            leftView = paddingView
            leftViewMode = .always
        }
    }
    
    @IBInspectable var paddingRightCustom: CGFloat {
        get {
            return rightView!.frame.size.width
        }
        set {
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: newValue, height: frame.size.height))
            rightView = paddingView
            rightViewMode = .always
        }
    }
}

extension UIViewController {
    class func current(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return current(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            return current(base: tab.selectedViewController)
        }
        if let presented = base?.presentedViewController {
            return current(base: presented)
        }
        return base
    }
}


public enum DeviceModel: String {
    //case Simulator = "Simulator/sandbox",
    case Simulator = "Simulator",
    iPod1          = "iPod 1",
    iPod2          = "iPod 2",
    iPod3          = "iPod 3",
    iPod4          = "iPod 4",
    iPod5          = "iPod 5",
    iPod6          = "iPod 6",
    iPad2          = "iPad 2",
    iPad3          = "iPad 3",
    iPad4          = "iPad 4",
    iPhone1G       = "iPhone 1G",
    iPhone3G       = "iPhone 3G",
    iPhone3GS      = "iPhone 3GS",
    iPhone4        = "iPhone 4",
    iPhone4S       = "iPhone 4S",
    iPhone5        = "iPhone 5",
    iPhone5S       = "iPhone 5S",
    iPhone5C       = "iPhone 5C",
    iPadMini1      = "iPad Mini 1",
    iPadMini2      = "iPad Mini 2",
    iPadMini3      = "iPad Mini 3",
    iPadMini4      = "iPad Mini 4",
    iPadAir1       = "iPad Air 1",
    iPadAir2       = "iPad Air 2",
    iPadPro        = "iPad Pro",
    iPhone6        = "iPhone 6",
    iPhone6plus    = "iPhone 6 Plus",
    iPhone6S       = "iPhone 6S",
    iPhone6Splus   = "iPhone 6S Plus",
    AppleTV        = "Apple TV",
    Unknown        = "Unknown"
}

extension UIDevice {
    
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
        case "iPhone10,1", "iPhone10,4":                return "iPhone 8"
        case "iPhone10,3", "iPhone10,6":                return "iPhone X"
        case "iPhone11,8":                              return "iPhone XR"
        case "iPhone11,2":                              return "iPhone XS"
        case "iPhone11,6", "iPhone11,4":                return "iPhone XS Max"
        case "iPhone12,1":                              return "iPhone 11"
        case "iPhone12,3":                              return "iPhone 11 Pro"
        case "iPhone12,5":                              return "iPhone 11 Pro Max"
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
    
    //是否X系列  高度為812
    public func IS_IPHONE_X()->Bool{
        if modelName == "iPhone X" ||
            modelName == "iPhone XR" ||
            modelName == "iPhone XS" ||
            modelName == "iPhone XS Max" ||
            modelName == "iPhone 11" ||
            modelName == "iPhone 11 Pro" ||
            modelName == "iPhone 11 Pro Max"{
            return true
        }
        if UIScreen.main.bounds.height == 812{
            return true
        }

        return false
    }
}


extension UISegmentedControl{
    func customizeSegenmentedControlWithColor(color:UIColor)
    {
        let tintColorImage = GeneralExtension.imageWithColor(color: color)
        self.setBackgroundImage(GeneralExtension.imageWithColor(color: self.backgroundColor ?? UIColor.clear), for: .normal, barMetrics: .default)
        self.setBackgroundImage(tintColorImage, for: .selected, barMetrics: .default)
        self.setBackgroundImage(GeneralExtension.imageWithColor(color: color.withAlphaComponent(0.2)), for: .highlighted, barMetrics: .default)
        //self.setBackgroundImage(tintColorImage, for: .selected, barMetrics: .default)
        self.setDividerImage(tintColorImage, forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
        self.layer.borderWidth=1
        self.layer.borderColor=color.cgColor
    }
}

extension UIApplication{
    var isKeyboardPresented: Bool{
        if let keyboardWindowClass = NSClassFromString("UIRemoteKeyboardWindow"), self.windows.contains(where: { $0.isKind(of: keyboardWindowClass) }){
            return true
        }else{
            return false
        }
    }
}

extension Bundle {
    func info(key:String)->String? {
        return infoDictionary?[key] as? String
    }
}
