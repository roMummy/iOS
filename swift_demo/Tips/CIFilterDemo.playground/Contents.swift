import UIKit

var greeting = "Hello, playground"
func testFilter(qr info: String, width: CGFloat) -> UIImage? {
    let properties = CIFilter.filterNames(inCategory: kCICategoryBuiltIn)
    print(properties)
    for fileterName : String in properties {
        let filter = CIFilter(name: fileterName)
      // 滤镜的参数
        print(filter?.attributes)
    }
    
    let strData = info.data(using: .utf8, allowLossyConversion: false)
    // 创建二维码滤镜
    let qrFilter = CIFilter(name: "CIQRCodeGenerator")
    qrFilter?.setValue(strData, forKey: "inputMessage")
    qrFilter?.setValue("H", forKey: "inputCorrectionLevel")
    let qrImage = qrFilter?.outputImage
    // 颜色滤镜
    let colorFilter = CIFilter(name: "CIFalseColor")
    colorFilter?.setDefaults()
    colorFilter?.setValue(qrImage, forKey: kCIInputImageKey)
    colorFilter?.setValue(CIColor(red: 0, green: 0, blue: 0), forKey: "inputColor0")
    colorFilter?.setValue(CIColor(red: 1, green: 1, blue: 1), forKey: "inputColor1")
    guard let colorImage = colorFilter?.outputImage else {
        return nil
    }
    // 返回二维码
    let codeImage = UIImage(ciImage: colorImage)
    return codeImage
}
// 条形码
func code128(info: String) -> UIImage? {
    let strData = info.data(using: .utf8, allowLossyConversion: false)
    // 创建条形码滤镜
    let qrFilter = CIFilter(name: "CICode128BarcodeGenerator")
    qrFilter?.setDefaults()
    qrFilter?.setValue(strData, forKey: "inputMessage")
    guard let ciImage = qrFilter?.outputImage else {
        return nil
    }
    // 返回条形码
    let codeImage = UIImage(ciImage: ciImage)
    return codeImage
}
