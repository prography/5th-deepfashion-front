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
    @IBOutlet var indicatorView: UIActivityIndicatorView!
    @IBOutlet var topContentView: UIView!

    private let backgroundImageView: UIImageView = {
        let backgroundImageView = UIImageView()
        backgroundImageView.contentMode = .scaleAspectFill
        return backgroundImageView
    }()

    // MARK: Properties

    private let clothingPartTitle = [" Top", " Outer", " Bottom", " Shoes"]
    private var codiIdCount = 0
    private var isCodiListEmpty = true
    private var locationManager = CLLocationManager()
    private var nowWeatherData: WeatherAPIData?
    private var weatherIndex = WeatherIndex.sunny {
        didSet {
            updateWeatherImage(weatherIndex)
        }
    }

    private var recommendAPIDataChecker: (isClothingData: Bool, isWeatherData: Bool) = (false, false) {
        didSet {
            if recommendAPIDataChecker.isClothingData, recommendAPIDataChecker.isWeatherData {
                CodiListGenerator.shared.getNowCodiDataSet()
                updateRecommendedCodiList()
            }
        }
    }

    private var codiAddView = CodiAddView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))

    private var isAPIDataRequested = false {
        didSet {
            DispatchQueue.main.async {
                self.indicatorView.checkIndicatorView((self.isAPIDataRequested || self.isImageDataRequested) && !self.isCodiDataRequested)
            }
        }
    }

    private var isCodiDataRequested = false {
        didSet {
            DispatchQueue.main.async {
                self.codiAddView.addButton.isEnabled = !self.isCodiDataRequested
                self.codiAddView.cancelButton.isEnabled = !self.isCodiDataRequested
                self.codiAddView.indicatorView.checkIndicatorView(self.isCodiDataRequested)
            }
        }
    }

    private var isImageDataRequested = false {
        didSet {
            DispatchQueue.main.async {
                self.indicatorView.checkIndicatorView(self.isAPIDataRequested || self.isImageDataRequested)
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
        RequestImage.shared.delegate = self
        configureCodiListCollectionView()
        requestClothingAPIDataList()
        updateWeatherImage(weatherIndex)
    }

    override func viewDidAppear(_: Bool) {
        super.viewDidAppear(true)
        configureTopContentViewConstraint()
        checkLocationAuthority()
    }

    override func viewWillDisappear(_: Bool) {
        super.viewWillDisappear(true)
    }

    // MARK: Methods

    // UI적인 요소, 로직적인 요소가 같이 겹쳐져 있는 부분이 있다.
    // ViewController에서는 데이터만 넘겨주고, viewWillAppear, viewDidAppear에서 호출해보는게 더 좋지 않을까?
    // 이미 옷데이터를 받은 경우에는 reload소요가 크지 않으니 viewWillAppear, viewDidAppear에서 하는게 좋지않을까?

    // 로딩 중 터치동작을 막기위해서는 ?
    // keyWindows의 indicatorView를 AddsubView시키면 keyWindow는 최상단의 뷰.
    // baseViewController를 만들고, 모든 뷰컨트롤러는 baseViewController를 상속받게만들고 baseViewController의 함수를 endLoading, startLoading 지정하는 방법 .isEnabled .UserInteractive 설정
    // 뷰에 인디케이터를 씌워서 동작시키는 방식
    // 인디케이터 매니저를 커스텀으로 만들어서 인디케이터매니저.showWindow

    private func configureTopContentViewConstraint() {}

    private func updateWeatherImage(_ weatherIndex: WeatherIndex) {
        weatherImageView.presentImageWithAnimation(weatherIndex.iconImage, 0.63)
        backgroundImageView.presentImageWithAnimation(weatherIndex.backgroundImage, 0.63)
    }

    func requestClothingAPIDataList() {
        if CommonUserData.shared.isNeedToUpdateClothing == false {
            refreshCodiData()
            return
        }

        RequestAPI.shared.getAPIData(APIMode: .getClothing, type: ClothingAPIDataList.self) { networkError, clothingDataList in
            DispatchQueue.main.async {
                guard let tabBarController = self.tabBarController as? MainTabBarController else { return }
                if networkError == nil {
                    guard let clothingDataList = clothingDataList else { return }
                    CommonUserData.shared.configureClothingData(clothingDataList)
                    self.recommendAPIDataChecker.isClothingData = true
                    tabBarController.updateClosetListTableView()
                    CommonUserData.shared.setIsNeedToUpdateClothingFalse()
                } else {
                    tabBarController.presentToastMessage("옷 정보를 불러오는데 실패했습니다.")
                    CommonUserData.shared.setIsNeedToUpdateClothingTrue()
                    self.recommendAPIDataChecker.isClothingData = false
                }
            }
        }
    }

    func reloadRecommendCollectionView() {
        DispatchQueue.main.async {
            self.recommendCollectionView.reloadData()
        }
    }

    private func requestLocationAuthority() {
        // 현재 위치권한이 있는지 유무를 확인한다.
        let locationAuthStatus = CLLocationManager.authorizationStatus()
        switch locationAuthStatus {
        case .notDetermined:
            locationManager.requestAlwaysAuthorization()
        case .authorizedAlways,
             .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
        // location Update, get weatherData
        default:
            presentBasicTwoButtonAlertController(title: "위치 권한 요청", message: "현지 날씨정보를 받기 위해 위치권한이 필요합니다. 위치권한을 설정하시겠습니까?") { isApproved in
                if isApproved {
                    guard let appSettingURL = URL(string: UIApplication.openSettingsURLString) else { return }
                    UIApplication.shared.open(appSettingURL, options: [:])
                } else {}
            }
        }
    }

    private func checkLocationAuthority() {
        // 현재 위치권한이 있는지 유무를 확인한다.
        let locationAuthStatus = CLLocationManager.authorizationStatus()
        switch locationAuthStatus {
        case .notDetermined,
             .authorizedAlways,
             .authorizedWhenInUse:
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

    private func configureTopContentView() {
        topContentView.layer.cornerRadius = 10
        topContentView.layer.shadowOffset = CGSize(width: 0, height: 0)
        topContentView.layer.shadowColor = UIColor.black.cgColor
        topContentView.layer.shadowOpacity = 0.3
        topContentView.layer.shadowRadius = 3
        topContentView.backgroundColor = UIColor(white: 1, alpha: 0.0)
    }

    private func configureWeatherImageView() {
        //        guard let weatherImage = UIImage(named: "clear-day") else { return }
        //        weatherImageView.image = weatherImage.withRenderingMode(.alwaysTemplate)
        //        weatherImageView.tintColor = .white
    }

    private func configureLabel() {
        celsiusLabel.adjustsFontSizeToFitWidth = true
    }

    private func configureCodiListSaveButton() {
        codiListSaveButton.backgroundColor = .clear
        codiListSaveButton.setTitle("코디 저장하기", for: .normal)
        codiListSaveButton.setImage(UIImage(named: AssetIdentifier.Image.addCodiList), for: .normal)
        codiListSaveButton.centerVertically()
    }

    private func configureRefreshCodiButton() {
        refreshCodiButton.backgroundColor = .clear
        refreshCodiButton.setImage(UIImage(named: AssetIdentifier.Image.refresh), for: .normal)
        refreshCodiButton.addTarget(self, action: #selector(refreshCodiButtonPressed(_:)), for: .touchUpInside)
        refreshCodiButton.centerVertically()
    }

    private func updateWeatherData(weatherData: WeatherAPIData) {
        if let _temperature = weatherData.temperature,
            let temperature = Double(_temperature) {
            celsiusLabel.text = "\((temperature * 10).rounded() / 10)°C"
        }

        if let rainValueString = weatherData.rain,
            let rainValue = Double(rainValueString) {
            if rainValue >= 0.6 {
                weatherIndex = .rainy
            }
            return
        } else if let snowValueString = weatherData.snow,
            let snowValue = Double(snowValueString) {
            if snowValue >= 0.6 {
                weatherIndex = .snowy
            }
            return
        }

        if let humidityValueString = weatherData.humidity,
            let humidityValue = Double(humidityValueString) {
            if humidityValue >= 60.0 {
                weatherIndex = .cloudy
            }
            return
        }

        weatherIndex = .sunny
    }

    private func checkImageDataRequest() {
        isImageDataRequested = !RequestImage.shared.isImageKeyEmpty()
    }

    private func refreshCodiData() {
        DispatchQueue.main.async {
            var isNowCodiListEmpty = true
            for i in 0 ..< 4 {
                guard let nowCell = self.recommendCollectionView.cellForItem(at: IndexPath(row: i, section: 0)) as? CodiRecommendCollectionViewCell else {
                    continue
                }

                nowCell.updateCellImage(CodiListGenerator.shared.topRecommendedCodiDataSet[i]?.image)
                if let _ = CodiListGenerator.shared.topRecommendedCodiDataSet[i]?.image {
                    isNowCodiListEmpty = false
                }
            }
            self.isCodiListEmpty = isNowCodiListEmpty
        }
    }

    private func presentCodiAddView() {
        guard let tabBarController = self.tabBarController else { return }
        codiAddView.alpha = 0

        var codiImageList = [UIImage]()
        for item in clothingPartTitle.indices {
            guard let clothingCell = self.recommendCollectionView.cellForItem(at: IndexPath(item: item, section: 0)) as? CodiRecommendCollectionViewCell,
                let clothingImage = clothingCell.clothingImageView.image else { continue }
            codiImageList.append(clothingImage)
        }

        codiAddView.nameTextField.delegate = self

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(codiAddViewTapped(_:)))
        codiAddView.addGestureRecognizer(tapGestureRecognizer)
        codiAddView.configureImage(codiImageList)
        codiAddView.addButton.addTarget(self, action: #selector(codiAddViewAddButtonPressed(_:)), for: .touchUpInside)
        codiAddView.cancelButton.addTarget(self, action: #selector(codiAddViewCancelButtonPressed(_:)), for: .touchUpInside)

        tabBarController.navigationController?.view.addSubview(codiAddView)
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.codiAddView.alpha = 1
        }
    }

    private func dismissCodiAddView() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.3, animations: { [weak self] in
                self?.codiAddView.alpha = 0.0
            }, completion: { [weak self] isSucceed in
                if isSucceed {
                    self?.codiAddView.removeFromSuperview()
                }
            })
        }
    }

    private func configureCodiListCollectionView() {
        refreshCodiData()
    }

    private func checkCharacter(textField _: UITextField, character: String) -> Bool {
        let alphabetSet = CharacterSet(charactersIn: MyCharacterSet.signUpAlphabet).inverted
        let numberSet = CharacterSet(charactersIn: MyCharacterSet.signUpNumber).inverted
        let koreanSet = CharacterSet(charactersIn: MyCharacterSet.korean).inverted
        return character.rangeOfCharacter(from: alphabetSet) == nil
            || character.rangeOfCharacter(from: numberSet) == nil
            || character.rangeOfCharacter(from: koreanSet) == nil
    }

    private func configureTopContentButtonAlignment(_ button: UIButton) {
        if let imageView = button.imageView, let titleLabel = button.titleLabel {
            imageView.center.x = titleLabel.center.x
        }
    }

    private func configureBackgroundImageView() {
        backgroundImageView.bounds = view.bounds
        backgroundImageView.clipsToBounds = true
        backgroundImageView.center = view.center
        view.addSubview(backgroundImageView)
        view.sendSubviewToBack(backgroundImageView)
    }

    private func configureCodiRecommendCollectionView() {
        recommendCollectionView.dataSource = self
        recommendCollectionView.delegate = self
        recommendCollectionView.allowsMultipleSelection = true
        recommendCollectionView.isScrollEnabled = false
    }

    private func configureLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        locationManager.activityType = .automotiveNavigation
        locationManager.distanceFilter = kCLDistanceFilterNone
        requestLocationAuthority()
    }

    private func checkAPIDataWithDelay() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            guard let tabBarController = self.tabBarController as? MainTabBarController else { return }
            if !self.recommendAPIDataChecker.isWeatherData {
                tabBarController.presentToastMessage("초기 날씨정보 갱신 시 지연이 발생할 수 있습니다.")
            }
        }
    }

    func updateRecommendedCodiList() {
        var fixStatus = [Int]()
        DispatchQueue.main.async {
            for i in 0 ..< 4 {
                guard let nowCell = self.recommendCollectionView.cellForItem(at: IndexPath(row: i, section: 0)) as? CodiRecommendCollectionViewCell else {
                    fixStatus.append(0)
                    continue
                }

                fixStatus.append(nowCell.isSelected ? 0 : 1)
            }

            CodiListGenerator.shared.getNextCodiDataSet(fixStatus)
            self.refreshCodiData()
        }
    }

    private func checkWeatherData(_ weatherDataList: [WeatherAPIData]?, coordinator: CLLocationCoordinate2D) {
        // 에러 없이 날씨데이터를 받아왔다면 받아온 데이터와 현지 위치좌표를 비교한다.

        guard let weatherDataList = weatherDataList else { return }

        var minDiff: Double = 6e4
        weatherDataList.forEach {
            guard let latitude = LocationData.coordinatorList[$0.id]?.1,
                let longitude = LocationData.coordinatorList[$0.id]?.2 else { return }
            let diff = abs(coordinator.latitude - latitude) + abs(coordinator.longitude - longitude)
            if diff < minDiff {
                minDiff = diff
                self.nowWeatherData = $0
            }
        }

        // 현재 흭득한 날씨 정보를 CommonUserData에 저장
        guard let weatherAPIData = self.nowWeatherData,
            let _temperature = weatherAPIData.temperature,
            let temperature = Double(_temperature) else { return }
        let weatherData = WeatherData(temperature: temperature, coordinator: coordinator)
        CommonUserData.shared.configureWeatherData(weatherData)
        recommendAPIDataChecker.isWeatherData = true

        DispatchQueue.main.async {
            self.updateWeatherData(weatherData: weatherAPIData)
            self.locationManager.stopUpdatingLocation()
        }
    }

    //    private func hideBackgroundImage() {
    //        backgroundImageView.isHidden = true
    //    }

    @objc func codiAddViewAddButtonPressed(_: UIButton) {
        if codiAddView.nameTextField.text?.trimmingCharacters(in: .whitespaces) == "" {
            DispatchQueue.main.async {
                guard let tabBarController = self.tabBarController as? MainTabBarController else { return }
                tabBarController.presentToastMessage("코디리스트 이름을 입력해주세요.")
            }
            return
        }

        guard let codiListName = codiAddView.nameTextField.text,
            let tabBarController = self.tabBarController as? MainTabBarController else { return }
        var codiIdList = [Int]()
        for i in CodiListGenerator.shared.topRecommendedCodiDataSet.indices {
            guard let codiId = CodiListGenerator.shared.topRecommendedCodiDataSet[i]?.id else { continue }
            codiIdList.append(codiId)
        }

        let codiListData = CodiListAPIData(id: nil, name: codiListName, owner: CommonUserData.shared.pk, clothes: codiIdList, createdTime: nil, updatedTime: nil)
        isCodiDataRequested = true
        debugPrint("now Posting CodiListData : \(codiListData)")
        RequestAPI.shared.postAPIData(userData: codiListData, APIMode: .codiList) { networkError in
            DispatchQueue.main.async { [weak self] in
                self?.isCodiDataRequested = false
                if networkError == nil {
                    tabBarController.presentToastMessage("코디리스트가 등록되었습니다!")
                    CommonUserData.shared.setIsNeedToUpdateCodiListTrue()
                    self?.dismissCodiAddView()
                } else {
                    tabBarController.presentToastMessage("코디리스트 등록에 실패했습니다.")
                }
            }
        }
    }

    @objc func codiAddViewCancelButtonPressed(_: UIButton) {
        // dismiss the codiAddView
        dismissCodiAddView()
    }

    @objc func codiAddViewTapped(_: CodiAddView) {
        codiAddView.nameTextField.resignFirstResponder()
    }

    // MARK: - IBAction

    @objc func refreshCodiButtonPressed(_: UIButton) {
        // 먼저 날씨정보를 참고할 수 있는지 확인한다.
        if !recommendAPIDataChecker.isClothingData || !recommendAPIDataChecker.isWeatherData {
            guard let tabBarController = self.tabBarController as? MainTabBarController else { return }
            tabBarController.presentToastMessage("옷, 날씨정보를 받지 못해 추천이 불가능합니다.")
        }

        updateRecommendedCodiList()
    }

    @IBAction func saveCodiListButtonPressed(_: UIButton) {
        if !isCodiListEmpty {
            presentCodiAddView()
        } else {
            guard let tabBarController = self.tabBarController as? MainTabBarController else { return }
            tabBarController.presentToastMessage("옷 등록 후 코디리스트 저장을 해주세요.")
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

        codiRecommendCollectionCell.configureCell(title: ViewData.Title.fashionType[indexPath.item], clothingData: CodiListGenerator.shared.topRecommendedCodiDataSet[indexPath.item], indexPath: indexPath)

        return codiRecommendCollectionCell
    }
}

extension CodiRecommendViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn _: NSRange, replacementString string: String) -> Bool {
        return checkCharacter(textField: textField, character: string)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension CodiRecommendViewController: CLLocationManagerDelegate {
    func locationManager(_: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let nowCoordinator = locations.first?.coordinate else { return }
        // 현지 위치정보를 얻었는데 만약 날씨 데이터가 존재하지 않는나면,
        // 날씨 데이터를 요청해서 받아온다.
        RequestAPI.shared.getAPIData(APIMode: .getWeather, type: WeatherAPIDataList.self) { error, data in

            if error != nil {
                self.recommendAPIDataChecker.isWeatherData = false

                DispatchQueue.main.async {
                    guard let tabBarController = self.tabBarController as? MainTabBarController else { return }
                    tabBarController.presentToastMessage("날씨 정보를 불러오는데 실패했습니다.")
                }
                return
            }

            self.checkWeatherData(data, coordinator: nowCoordinator)
        }
    }

    func locationManager(_: CLLocationManager, didFailWithError _: Error) {
        debugPrint("Failed to update Location Information")
        DispatchQueue.main.async {
            guard let tabBarController = self.tabBarController as? MainTabBarController else { return }
            tabBarController.presentToastMessage("날씨 정보를 불러오는데 실패했습니다.")
        }
    }

    func locationManager(_: CLLocationManager, didChangeAuthorization _: CLAuthorizationStatus) {
        let locationAuthStatus = CLLocationManager.authorizationStatus()
        switch locationAuthStatus {
        case .authorizedAlways,
             .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
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

extension CodiRecommendViewController: RequestImageDelegate {
    func imageRequestDidBegin() {
        isImageDataRequested = true
    }

    func imageRequestDidFinished(_: UIImage, imageKey _: String) {
        checkImageDataRequest()
    }

    func imageRequestDidError(_: String) {
        checkImageDataRequest()
        DispatchQueue.main.async {
            guard let tabBarController = self.tabBarController as? MainTabBarController else { return }
            tabBarController.presentToastMessage("이미지 로딩 중 에러가 발생했습니다.")
        }
    }
}

extension CodiRecommendViewController: UIViewControllerSetting {
    func configureViewController() {
        configureLocationManager()
        CommonUserData.shared.setIsNeedToUpdateClothingTrue()
        configureBackgroundImageView()
        configureTopContentView()
        configureCodiRecommendCollectionView()
        configureWeatherImageView()
        configureLabel()
        configureRefreshCodiButton()
        configureCodiListSaveButton()
        guard let tabBarController = self.tabBarController as? MainTabBarController else { return }
        tabBarController.presentToastMessage("로그인에 성공했습니다.")
        checkAPIDataWithDelay()
    }
}
