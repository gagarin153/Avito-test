import UIKit

class AdsViewController: UIViewController {
    
    private var screenDataResult: ScreenDataResult?
    private var timer: Timer?
    private var currentSelectedIndexPath:  IndexPath? {
        didSet {
            if currentSelectedIndexPath != nil { selectButton.isEnabled = true}
            else { selectButton.isEnabled = false }
        }
    }
    
    private let activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.hidesWhenStopped = true
        return activityIndicator
    }()
    
    private let adsCollectionViewRefreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
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
            layout.estimatedItemSize = CGSize(width: width, height: 1)
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
        button.backgroundColor = .clear
        button.setTitle("", for: .normal)
        let radius: CGFloat = 5.0
        button.layer.cornerRadius = radius
        button.addTarget(self, action: #selector(selectButtonStartTouch), for: .touchDown)
        button.addTarget(self, action: #selector(selectButtonTapped), for: .touchUpInside)
        button.addTarget(self, action: #selector(selectButtonCancelTapped), for: .touchDragExit)
        button.isEnabled = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        self.setUpnavigationController()
        self.setUpCollectionView()
        self.setUpLayout()
        self.startLoadingEffect()
        NetworkMonitor.shared.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NetworkMonitor.shared.startMonitoring()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NetworkMonitor.shared.stopMonitoring()
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
        [self.titleLabel, self.adsCollectionView, self.selectButton, self.activityIndicator].forEach { self.view.addSubview($0)}
        
        self.activityIndicator.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        self.activityIndicator.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        
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
    
    private func fetchData() {
        NetworkManager.shared.fetchScreenData { [weak self] result in
            switch result  {
            case .success(let screenData):
                self?.screenDataResult = screenData.result
                self?.timer?.invalidate()
                
                DispatchQueue.main.async {
                    self?.titleLabel.text = screenData.result.title
                    self?.selectButton.setTitle(screenData.result.selectedActionTitle, for: .normal)
                    self?.selectButton.backgroundColor = .softBlue
                    self?.adsCollectionView.reloadData()
                    self?.activityIndicator.stopAnimating()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func startLoadingEffect() {
        var counter = 0
        self.activityIndicator.startAnimating()
        timer = Timer.scheduledTimer(withTimeInterval: 0.55, repeats: true) { (timer) in
            var currentTitleText: String {
                switch self.titleLabel.text {
                case "Загрузка.":       return "Загрузка.."
                case "Загрузка..":      return "Загрузка..."
                case "Загрузка...":     return "Загрузка."
                default:                return "Загрузка"
                }
            }
            self.titleLabel.text = currentTitleText
            counter += 1
            if counter == 50 {
                timer.invalidate()
                self.activityIndicator.stopAnimating()
            }
        }
    }
    
    @objc private func selectButtonStartTouch (_ sender: UIButton) {
        UIView.animate(withDuration: 0.1) {
            sender.transform = .init(scaleX:0.9, y: 0.9)
        }
        self.selectButton.backgroundColor = .lightGray
    }
    
    @objc private func selectButtonTapped (_ sender: UIButton) {
        UIView.animate(withDuration: 0.1) {
            sender.transform = .identity
        }
        self.selectButton.backgroundColor = .softBlue
        guard let index = currentSelectedIndexPath?.row, let message = screenDataResult?.list[index].title
        else { return }
        Alert.showSelectedServiceAlert(on: self, withSelectedService: message)
    }
    
    @objc private func selectButtonCancelTapped(_ sender: UIButton) {
        UIView.animate(withDuration: 0.1) {
            sender.transform = .identity
        }
        self.selectButton.backgroundColor = .softBlue
    }
    
    @objc private func refresh() {
        if NetworkMonitor.shared.isConntected {
            self.fetchData()
        } else {
            Alert.showInternetConnectionErrorAlert(on: self)
        }
        self.adsCollectionViewRefreshControl.endRefreshing()
    }
}

extension AdsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return screenDataResult?.list.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AdCollectionViewCell.reuseIdentifier, for: indexPath) as? AdCollectionViewCell else { return UICollectionViewCell() }
        let screenDataResultlistItem = screenDataResult?.list[indexPath.item]
        cell.resultListItem = screenDataResultlistItem
        
        if indexPath != self.currentSelectedIndexPath  {
            cell.deselect()
        } else if indexPath == self.currentSelectedIndexPath { // Чтобы возвращать выделение после рефреша коллекции
            cell.select()
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if self.currentSelectedIndexPath != indexPath {
            
            if let currentSelectedIndexPath = self.currentSelectedIndexPath, let cellWillDeselect = self.adsCollectionView.cellForItem(at: currentSelectedIndexPath) as? AdCollectionViewCell {
                cellWillDeselect.deselect()  // Если использовать метод DidDeselectItemAt, он не убирает выделение после рефреша
            }
            
            if let cellWillSelect = self.adsCollectionView.cellForItem(at: indexPath) as? AdCollectionViewCell {
                self.currentSelectedIndexPath = indexPath
                cellWillSelect.select()
            }
        } else {
            if let currentSelectedIndexPath = self.currentSelectedIndexPath, let cellWillDeselect = self.adsCollectionView.cellForItem(at: currentSelectedIndexPath) as? AdCollectionViewCell {
                self.currentSelectedIndexPath = nil
                cellWillDeselect.deselect()
            }
        }
    }
}

extension AdsViewController: NetworkMonitorDelegate {
    func connectionHandler() {
        if NetworkMonitor.shared.isConntected {
            self.fetchData()
        } else {
            DispatchQueue.main.async {
                self.activityIndicator.startAnimating()
                Alert.showInternetConnectionErrorAlert(on: self)
            }
        }
    }
}
