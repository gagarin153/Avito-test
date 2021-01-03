import UIKit

class AdCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "AdCell"

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
