import UIKit

extension UIColor {
    class var softGray: UIColor { UIColor(red: 243/255, green: 243/255, blue: 243/255, alpha: 1) }
    class var softBlue: UIColor { UIColor(red: 1/255, green: 172/255, blue: 255/255, alpha: 1) }
}

let imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView {
    func load(url: URL) {
        self.image = nil
        
        if let imageFromCache = imageCache.object(forKey: url.absoluteURL as AnyObject) as? UIImage {
            self.image = imageFromCache
            return
        }
        
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                imageCache.setObject(image, forKey: url.absoluteURL as AnyObject)
                DispatchQueue.main.async {
                    self?.image = image
                }
            }
        }
    }
}
