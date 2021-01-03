import UIKit

struct Alert {
    private init() {}
    
    static func showSelectedServiceAlert(on vs: UIViewController, withSelectedService text: String) {
        let attributedString = NSAttributedString(string: text, attributes: [ NSAttributedString.Key.foregroundColor : UIColor.white ])
        let alert = UIAlertController(title: "", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "ОК", style: .default)
        
        alert.addAction(action)
        alert.setValue(attributedString, forKey: "attributedTitle")

        if let bgView = alert.view.subviews.first, let groupView = bgView.subviews.first, let contentView = groupView.subviews.first {
            contentView.backgroundColor = .softBlue
        }
        alert.view.tintColor = .white
        
        vs.present(alert, animated: true)
    }
    
    static func showInternetConnectionErrorAlert(on vs: UIViewController) {
        let alert = UIAlertController(title: "Ошибка", message: "У вас проблемы с интернетом", preferredStyle: .alert)
        let action = UIAlertAction(title: "ОК", style: .default)
        alert.addAction(action)
        vs.present(alert, animated: true)
    }
}
