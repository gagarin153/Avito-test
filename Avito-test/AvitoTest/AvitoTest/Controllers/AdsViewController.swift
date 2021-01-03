import UIKit

class AdsViewController: UIViewController {

    private let activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.hidesWhenStopped = true
        return activityIndicator
    }()
    
    private let adsCollectionViewRefreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
       // refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return refreshControl
    }()
    
    private let  titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        let title = "Загрузка."
        let titleTextSize: CGFloat = 30.0
        let textAttribute = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: titleTextSize)]
        label.attributedText = NSAttributedString(string: title, attributes: textAttribute)
        return label
    }()
    
    private let adsCollectionView: UICollectionView = {
        var layout: UICollectionViewFlowLayout = {
            let layout = UICollectionViewFlowLayout()
            let width = UIScreen.main.bounds.size.width - 40
            layout.estimatedItemSize = CGSize(width: width, height: 40)
            return layout
        }()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(AdCollectionViewCell.self, forCellWithReuseIdentifier: AdCollectionViewCell.reuseIdentifier)
        collectionView.backgroundColor = .white
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()
    
    private let selectButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .softBlue
        button.setTitle("", for: .normal)
        let radius: CGFloat = 5.0
        button.layer.cornerRadius = radius
//        button.addTarget(self, action: #selector(selectButtonStartTouch), for: .touchDown)
//        button.addTarget(self, action: #selector(selectButtonTapped), for: .touchUpInside)
//        button.addTarget(self, action: #selector(selectButtonCancelTapped), for: .touchDragExit)
        button.isEnabled = false
        return button
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        self.setUpnavigationController()
        self.setUpCollectionView()
        self.setUpLayout()
        
    }
    
    private func setUpnavigationController() {
        let image = UIImage(named: Images.closeIconTemplate.rawValue)?.withRenderingMode(.alwaysOriginal)
        let closeButton = UIBarButtonItem(image: image, style: .plain, target: self, action: nil)
        closeButton.isEnabled = false
        self.navigationItem.leftBarButtonItem  = closeButton
        self.navigationController?.navigationBar.barTintColor = .white
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
    }
    
    private func setUpCollectionView() {
        self.adsCollectionView.dataSource = self
        self.adsCollectionView.delegate = self
        self.adsCollectionView.refreshControl = self.adsCollectionViewRefreshControl
        self.adsCollectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: Sizes.tripleStandartOffset.rawValue + Sizes.bar.rawValue, right: 0)
    }
    
    private func setUpLayout() {
        [self.titleLabel, self.adsCollectionView, self.selectButton].forEach { self.view.addSubview($0)}
        
        
        self.titleLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: Sizes.standartOffset.rawValue).isActive = true
        self.titleLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -Sizes.standartOffset.rawValue).isActive = true
        self.titleLabel.heightAnchor.constraint(equalToConstant: Sizes.doubleBar.rawValue).isActive = true
        self.titleLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: Sizes.standartOffset.rawValue).isActive = true
        
        self.selectButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: Sizes.standartOffset.rawValue).isActive = true
        self.selectButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -Sizes.standartOffset.rawValue).isActive = true
        self.selectButton.heightAnchor.constraint(equalToConstant: Sizes.bar.rawValue).isActive = true
        self.selectButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -Sizes.standartOffset.rawValue).isActive = true
        
        self.adsCollectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: Sizes.standartOffset.rawValue).isActive = true
        self.adsCollectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -Sizes.standartOffset.rawValue).isActive = true
        self.adsCollectionView.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: Sizes.standartOffset.rawValue).isActive = true
        self.adsCollectionView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -Sizes.standartOffset.rawValue).isActive = true
    }

}

extension AdsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AdCollectionViewCell.reuseIdentifier, for: indexPath) as? AdCollectionViewCell else { return UICollectionViewCell() }
       
        cell.backgroundColor = .black
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
}
