import UIKit

class AdCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "AdCell"

    var resultListItem: List? {
        didSet {
            self.adLabel.text = resultListItem?.title
            self.adDescriptionLabel.text = resultListItem?.description
            self.adPriceLabel.text = resultListItem?.price
        }
    }
    
    private lazy var width: NSLayoutConstraint = {
        let width = self.contentView.widthAnchor.constraint(equalToConstant: bounds.size.width)
        width.isActive = true
        return width
    }()
    
    private lazy var selectImageConstraints: [NSLayoutConstraint] = {
        let arrayConstraints = [
            self.selectImage.leadingAnchor.constraint(equalTo:self.contentView.trailingAnchor, constant: -Sizes.doubleStandartOffset.rawValue),
            self.selectImage.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: Sizes.doubleStandartOffset.rawValue),
            self.selectImage.heightAnchor.constraint(equalToConstant: Sizes.checkMark.rawValue),
            self.selectImage.widthAnchor.constraint(equalToConstant: Sizes.checkMark.rawValue)
        ]
        return arrayConstraints
    }()
    
    private let adLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        let titleTextSize: CGFloat = 22.0
        let textAttribute = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: titleTextSize)]
        label.attributedText = NSAttributedString(string: " ", attributes: textAttribute)
        label.numberOfLines = 0
        return label
    }()
    
    private let adDescriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        let titleTextSize: CGFloat = 16.0
        let textAttribute = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: titleTextSize)]
        label.attributedText = NSAttributedString(string: " ", attributes: textAttribute)
        return label
    }()
    
    private let adPriceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        let titleTextSize: CGFloat = 16.0
        let textAttribute = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: titleTextSize)]
        label.attributedText = NSAttributedString(string: " ", attributes: textAttribute)
        return label
    }()
    
    private let adImageView: UIImageView = {
        let imageview = UIImageView()
        imageview.backgroundColor = .white
        let radius: CGFloat = Sizes.icon.rawValue / 2.0
        imageview.layer.cornerRadius = radius
        imageview.translatesAutoresizingMaskIntoConstraints = false
        return imageview
    }()
    
    private let selectImage: UIImageView  = {
        let imageview = UIImageView()
        imageview.translatesAutoresizingMaskIntoConstraints = false
        imageview.image =  UIImage(named: Images.checkmark.rawValue)
        return imageview
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUpContentView()
        self.setLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    deinit {
        self.deselect()
    }
    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        self.width.constant = self.bounds.size.width
        return contentView.systemLayoutSizeFitting(CGSize(width: targetSize.width, height: 1))
    }
    
    private func setUpContentView() {
        let radius: CGFloat = 5.0
        self.contentView.layer.cornerRadius = radius
        self.contentView.backgroundColor = .softGray
    }
    
    func select() {
        self.contentView.addSubview(self.selectImage)
        NSLayoutConstraint.activate(selectImageConstraints)
    }
    
    func deselect() {
        NSLayoutConstraint.deactivate(selectImageConstraints)
        self.selectImage.removeFromSuperview()
    }
    
    private func setLayout() {
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        [self.adImageView, self.adLabel, self.adDescriptionLabel, self.adPriceLabel].forEach { self.contentView.addSubview($0)}
        
        self.adImageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: Sizes.standartOffset.rawValue).isActive = true
        self.adImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: Sizes.standartOffset.rawValue).isActive = true
        self.adImageView.heightAnchor.constraint(equalToConstant: Sizes.icon.rawValue).isActive = true
        self.adImageView.widthAnchor.constraint(equalToConstant: Sizes.icon.rawValue).isActive = true
        
        self.adLabel.leadingAnchor.constraint(equalTo: self.adImageView.trailingAnchor, constant: Sizes.standartOffset.rawValue).isActive = true
        self.adLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -Sizes.standartOffset.rawValue).isActive = true
        self.adLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: Sizes.standartOffset.rawValue).isActive = true
        
        self.adDescriptionLabel.leadingAnchor.constraint(equalTo: self.adImageView.trailingAnchor, constant: Sizes.standartOffset.rawValue).isActive = true
        self.adDescriptionLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -Sizes.doubleStandartOffset.rawValue).isActive = true
        self.adDescriptionLabel.topAnchor.constraint(equalTo: self.adLabel.bottomAnchor, constant: Sizes.halfStandartOffset.rawValue).isActive = true
        
        self.adPriceLabel.leadingAnchor.constraint(equalTo: self.adImageView.trailingAnchor, constant: Sizes.standartOffset.rawValue).isActive = true
        self.adPriceLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -Sizes.standartOffset.rawValue).isActive = true
        self.adPriceLabel.topAnchor.constraint(equalTo: self.adDescriptionLabel.bottomAnchor, constant: Sizes.halfStandartOffset.rawValue).isActive = true
        
        self.contentView.bottomAnchor.constraint(equalTo: self.adPriceLabel.bottomAnchor, constant: Sizes.standartOffset.rawValue).isActive = true
    }
}
