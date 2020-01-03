//
//  HomeViewController.swift
//  DeepFashion
//
//  Created by MinKyeongTae on 2019/11/18.
//  Copyright © 2019 MinKyeongTae. All rights reserved.
//

import CoreLocation
import UIKit

class CodiRecommendViewController: UIViewController {
    // MARK: UIs

    @IBOutlet var codiListSaveButton: UIButton!
    @IBOutlet var recommendCollectionView: UICollectionView!
    @IBOutlet var weatherImageView: UIImageView!
    @IBOutlet var celsiusLabel: UILabel!
    @IBOutlet var refreshCodiButton: UIButton!
    @IBOutlet var leftTitleView: UIView!
    @IBOutlet var indicatorView: UIActivityIndicatorView!

    // MARK: Properties

    private let clothingPartTitle = [" Top", " Outer", " Bottom", " Shoes"]
    private var codiIdCount = 0
    private var locationManager = CLLocationManager()
    private var nowWeatherData: WeatherAPIData?
    private var weatherIndex = WeatherIndex.sunny {
        didSet {
            weatherImageView.image = weatherIndex.image
        }
    }

    private var isAPIDataRequested = false {
        didSet {
            DispatchQueue.main.async {
                self.indicatorView.checkIndicatorView(self.isAPIDataRequested)
            }
        }
    }

    // MARK: Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
    }

    override func viewWillAppear(_: Bool) {
        super.viewWillAppear(true)
        RequestAPI.shared.delegate = self
        requestLocationAuthority()
        locationManager.startUpdatingLocation()
        requestClothingAPIDataList()
        configureBasicTitle(ViewData.Title.MainTabBarView.recommend)
    }

    override func viewWillDisappear(_: Bool) {
        super.viewWillDisappear(true)
    }

    override func viewDidAppear(_: Bool) {
        super.viewDidAppear(true)
    }

    // MARK: Methods

//    func updateClothingAPIDataList(_ clothingDataList: [ClothingAPIData]) {
//        CodiListGenerator.shared.getNowCodiDataSet(clothingDataList)
//        UserCommonData.shared.configureClothingData(clothingDataList)
//        DispatchQueue.main.async {
//            self.recommendCollectionView.reloadData()
//        }
//    }

    func requestClothingAPIDataList() {
        if UserCommonData.shared.isNeedToUpdateClothing == false { return }
        RequestAPI.shared.getAPIData(APIMode: .getClothing, type: ClothingAPIDataList.self) { networkError, clothingDataList in
            if networkError == nil {
                guard let clothingDataList = clothingDataList else { return }
                CodiListGenerator.shared.getNowCodiDataSet(clothingDataList)
                UserCommonData.shared.configureClothingData(clothingDataList)

                DispatchQueue.main.async {
                    self.recommendCollectionView.reloadData()
                }
                UserCommonData.shared.setIsNeedToUpdateClothingFalse()
            } else {
                DispatchQueue.main.async {
                    guard let tabBarController = self.tabBarController else { return }
                    ToastView.shared.presentShortMessage(tabBarController.view, message: "옷 정보를 불러오는데 실패했습니다.")
                    UserCommonData.shared.setIsNeedToUpdateClothingTrue()
                }
            }
        }
    }

    private func requestLocationAuthority() {
        // 현재 위치권한이 있는지 유무를 확인한다.
        let locationAuthStatus = CLLocationManager.authorizationStatus()
        switch locationAuthStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .authorizedAlways,
             .authorizedWhenInUse:
            // location Update, get weatherData
            break
        default:
            presentBasicTwoButtonAlertController(title: "위치 권한 요청", message: "현지 날씨정보를 받기 위해 위치권한이 필요합니다. 위치권한을 설정하시겠습니까?") { isApproved in
                if isApproved {
                    guard let appSettingURL = URL(string: UIApplication.openSettingsURLString) else { return }
                    UIApplication.shared.open(appSettingURL, options: [:])
                } else {}
            }
        }
    }

    private func configureWeatherImageView() {
        guard let weatherImage = UIImage(named: "clear-day") else { return }
        weatherImageView.image = weatherImage.withRenderingMode(.alwaysTemplate)
        weatherImageView.tintColor = .white
    }

    private func configureLabel() {
        celsiusLabel.textColor = .white
        celsiusLabel.font = UIFont.mainFont(displaySize: 18)
        celsiusLabel.adjustsFontSizeToFitWidth = true
    }

    private func configureCodiListSaveButton() {
        codiListSaveButton.titleLabel?.font = UIFont.mainFont(displaySize: 18)
        codiListSaveButton.setTitle("코디 저장하기", for: .normal)
        codiListSaveButton.configureEnabledButton()
    }

    private func configureRefreshCodiButton() {
        refreshCodiButton.backgroundColor = ColorList.newBrown
        refreshCodiButton.setTitleColor(.white, for: .normal)
        refreshCodiButton.setTitle(" 코디 새로고침", for: .normal)
        refreshCodiButton.titleLabel?.font = UIFont.mainFont(displaySize: 12)
        refreshCodiButton.setImage(UIImage(named: AssetIdentifier.Image.refresh), for: .normal)
    }

    private func updateWeatherData(weatherData: WeatherAPIData) {
        if let temperature = Double(weatherData.temperature) {
            celsiusLabel.text = "\((temperature * 10).rounded() / 10)°C"
        }

        if let rainValueString = weatherData.rain,
            let rainValue = Double(rainValueString) {
            if rainValue >= 0.6 {
                weatherIndex = .rainy
            } else {
                weatherIndex = .sunny
            }
        } else if let snowValueString = weatherData.snow,
            let snowValue = Double(snowValueString) {
            if snowValue >= 0.6 {
                weatherIndex = .snowy
            } else {
                weatherIndex = .sunny
            }
        } else {
            weatherIndex = .sunny
        }
    }

    private func addCodiDataSet() {
        var codiDataSet = [CodiData]()
        for i in 0 ..< 4 {
            let nowIndexPath = IndexPath(item: i, section: 0)
            guard let nowCell = recommendCollectionView.cellForItem(at: nowIndexPath) as? CodiRecommendCollectionViewCell else { return }
            let codiData = CodiData(codiImage: nowCell.imageView.image, codiId: codiIdCount)
            codiDataSet.append(codiData)
            if codiDataSet.count == 4 { break }
        }
        UserCommonData.shared.addCodiData(codiDataSet)
        codiIdCount += 1
    }

    // MARK: - IBAction

    @IBAction func refreshCodiButtonPressed(_: UIButton) {
        var fixStatus = [Int]()
        for i in 0..<4 {
            guard let nowCell = recommendCollectionView.cellForItem(at: IndexPath(row: i, section: 0)) as? CodiRecommendCollectionViewCell else {
                fixStatus.append(0)
                continue
            }
            
            fixStatus.append(nowCell.isSelected ? 0 : 1)
        }
        
        CodiListGenerator.shared.getNextCodiDataSet(fixStatus)
        
        for i in 0..<4 {
            guard let nowCell = recommendCollectionView.cellForItem(at: IndexPath(row: i, section: 0)) as? CodiRecommendCollectionViewCell else {
                continue
            }
            
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.6) {
                    nowCell.imageView.setThumbnailImageFromServerURL(CodiListGenerator.shared.topCodiDataSet[i]?.image, placeHolder: #imageLiteral(resourceName: "noClothing"))
                }
            }
        }
        
    }
    
    @IBAction func saveButtonPressed(_: UIButton) {
        presentBasicTwoButtonAlertController(title: "코디 저장", message: "해당 코디를 저장하시겠습니까?") { isApproved in
            if isApproved {
                guard let tabBar = self.tabBarController else { return }
                ToastView.shared.presentShortMessage(tabBar.view, message: "해당 코디가 저장되었습니다!")
                self.addCodiDataSet()
            }
        }
    }
    
}

extension CodiRecommendViewController: UICollectionViewDelegate {
    func collectionView(_: UICollectionView, didSelectItemAt _: IndexPath) {}

    func collectionView(_: UICollectionView, didDeselectItemAt _: IndexPath) {}
}

extension CodiRecommendViewController: UICollectionViewDataSource {
    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return ViewData.Title.fashionType.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let codiRecommendCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: UIIdentifier.Cell.CollectionView.recommend, for: indexPath) as? CodiRecommendCollectionViewCell else { return UICollectionViewCell() }

        codiRecommendCollectionCell.configureCell(title: ViewData.Title.fashionType[indexPath.item], clothingData: CodiListGenerator.shared.topCodiDataSet[indexPath.item], indexPath: indexPath)

        return codiRecommendCollectionCell
    }
}

extension CodiRecommendViewController: CLLocationManagerDelegate {
    func locationManager(_: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let nowCoordinator = locations.first?.coordinate else { return }
        // 현지 위치정보를 얻었는데 만약 날씨 데이터가 존재하지 않는나면,
        // 날씨 데이터를 요청해서 받아온다.
        RequestAPI.shared.getAPIData(APIMode: .getWeather, type: [WeatherAPIData].self) { error, data in
            if error == nil {
                // 에러 없이 날씨데이터를 받아왔다면 받아온 데이터와 현지 위치좌표를 비교한다.
                guard let weatherDataList = data else { return }

                var minDiff: Double = 6e4
                weatherDataList.forEach {
                    guard let latitude = LocationData.coordinatorList[$0.id]?.1,
                        let longitude = LocationData.coordinatorList[$0.id]?.2 else { return }
                    let diff = abs(nowCoordinator.latitude - latitude) + abs(nowCoordinator.longitude - longitude)
                    if diff < minDiff {
                        minDiff = diff
                        self.nowWeatherData = $0
                    }
                }

                guard let weatherData = self.nowWeatherData else { return }
                DispatchQueue.main.async {
                    self.updateWeatherData(weatherData: weatherData)
                    self.locationManager.stopUpdatingLocation()
                }
            } else {
                DispatchQueue.main.async {
                    guard let tabBarController = self.tabBarController else { return }
                    ToastView.shared.presentShortMessage(tabBarController.view, message: "현지 날씨정보 불러오기에 실패했습니다.")
                }
            }
        }
    }

    func locationManager(_: CLLocationManager, didChangeAuthorization _: CLAuthorizationStatus) {
        let locationAuthStatus = CLLocationManager.authorizationStatus()
        switch locationAuthStatus {
        case .authorizedWhenInUse:
            DispatchQueue.main.async {
                guard let tabBarController = self.tabBarController else { return }
                ToastView.shared.presentShortMessage(tabBarController.view, message: "현지기반 날씨 정보가 업데이트 됩니다.")
            }
        default:
            break
        }
    }
}

extension CodiRecommendViewController: RequestAPIDelegate {
    func requestAPIDidBegin() {
        // 인디케이터 동작
        isAPIDataRequested = true
    }

    func requestAPIDidFinished() {
        // 인디케이터 종료 및 세그 동작 실행
        isAPIDataRequested = false
    }

    func requestAPIDidError() {
        // 에러 발생 시 동작 실행
        isAPIDataRequested = false
    }
}

extension CodiRecommendViewController: UIViewControllerSetting {
    func configureViewController() {
        configureBasicTitle(ViewData.Title.MainTabBarView.recommend)
        UserCommonData.shared.setIsNeedToUpdateClothingTrue()
        recommendCollectionView.dataSource = self
        recommendCollectionView.delegate = self
        locationManager.delegate = self
        recommendCollectionView.allowsMultipleSelection = true
        configureCodiListSaveButton()
        configureWeatherImageView()
        configureLabel()
        configureRefreshCodiButton()
    }
}
