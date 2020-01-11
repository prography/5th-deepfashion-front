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
    private var isCodiListEmpty = true
    private var locationManager = CLLocationManager()
    private var nowWeatherData: WeatherAPIData?
    private var weatherIndex = WeatherIndex.sunny {
        didSet {
            weatherImageView.image = weatherIndex.image
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
        configureBasicTitle(ViewData.Title.MainTabBarView.recommend)
        RequestAPI.shared.delegate = self
        RequestImage.shared.delegate = self
        configureCodiListCollectionView()
        requestLocationAuthority()
        locationManager.startUpdatingLocation()
        requestClothingAPIDataList()
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

    // UI적인 요소, 로직적인 요소가 같이 겹쳐져 있는 부분이 있다.
    // ViewController에서는 데이터만 넘겨주고, viewWillAppear, viewDidAppear에서 호출해보는게 더 좋지 않을까?
    // 이미 옷데이터를 받은 경우에는 reload소요가 크지 않으니 viewWillAppear, viewDidAppear에서 하는게 좋지않을까?

    // 로딩 중 터치동작을 막기위해서는 ?
    // keyWindows의 indicatorView를 AddsubView시키면 keyWindow는 최상단의 뷰.
    // baseViewController를 만들고, 모든 뷰컨트롤러는 baseViewController를 상속받게만들고 baseViewController의 함수를 endLoading, startLoading 지정하는 방법 .isEnabled .UserInteractive 설정
    // 뷰에 인디케이터를 씌워서 동작시키는 방식
    // 인디케이터 매니저를 커스텀으로 만들어서 인디케이터매니저.showWindow

    func requestClothingAPIDataList() {
        if UserCommonData.shared.isNeedToUpdateClothing == false {
            refreshCodiData()
            return
        }
        RequestAPI.shared.getAPIData(APIMode: .getClothing, type: ClothingAPIDataList.self) { networkError, clothingDataList in
            if networkError == nil {
                guard let clothingDataList = clothingDataList else { return }
                UserCommonData.shared.configureClothingData(clothingDataList)
                CodiListGenerator.shared.getNowCodiDataSet()
                self.refreshCodiData()
                UserCommonData.shared.setIsNeedToUpdateClothingFalse()
            } else {
                DispatchQueue.main.async {
                    guard let tabBarController = self.tabBarController as? MainTabBarController else { return }
                    tabBarController.presentToastMessage("옷 정보를 불러오는데 실패했습니다.")
                }

                UserCommonData.shared.setIsNeedToUpdateClothingTrue()
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

                nowCell.updateCellImage(CodiListGenerator.shared.topCodiDataSet[i]?.image)
                if let _ = CodiListGenerator.shared.topCodiDataSet[i]?.image {
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
                let clothingImage = clothingCell.imageView.image else { continue }
            codiImageList.append(clothingImage)
        }

        codiAddView.nameTextField.delegate = self

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(codiAddViewTapped(_:)))
        codiAddView.addGestureRecognizer(tapGestureRecognizer)
        codiAddView.configureImage(codiImageList)
        codiAddView.addButton.addTarget(self, action: #selector(codiAddButtonPressed(_:)), for: .touchUpInside)
        codiAddView.cancelButton.addTarget(self, action: #selector(codiCancelButtonPressed(_:)), for: .touchUpInside)
        tabBarController.navigationController?.view.addSubview(codiAddView)
        UIView.animate(withDuration: 0.3) {
            self.codiAddView.alpha = 1
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

    @objc func codiAddButtonPressed(_: UIButton) {
        // RequestAPI.shared.postCodiData ~
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
        for i in CodiListGenerator.shared.topCodiDataSet.indices {
            guard let codiId = CodiListGenerator.shared.topCodiDataSet[i]?.id else { continue }
            codiIdList.append(codiId)
        }

        let codiListData = CodiListAPIData(id: nil, name: codiListName, owner: UserCommonData.shared.pk, clothes: codiIdList, createdTime: nil, updatedTime: nil)
        isCodiDataRequested = true
        RequestAPI.shared.postAPIData(userData: codiListData, APIMode: .codiList) { networkError in
            DispatchQueue.main.async { [weak self] in
                self?.isCodiDataRequested = false
                if networkError == nil {
                    tabBarController.presentToastMessage("코디리스트가 등록되었습니다!")
                    UserCommonData.shared.setIsNeedToUpdateCodiListTrue()
                    self?.dismissCodiAddView()
                } else {
                    tabBarController.presentToastMessage("코디리스트 등록에 실패했습니다.")
                }
            }
        }
    }

    @objc func codiCancelButtonPressed(_: UIButton) {
        // dismiss the codiAddView
        dismissCodiAddView()
    }

    @objc func codiAddViewTapped(_: CodiAddView) {
        codiAddView.nameTextField.resignFirstResponder()
    }

    // MARK: - IBAction

    @IBAction func refreshCodiButtonPressed(_: UIButton) {
        var fixStatus = [Int]()
        for i in 0 ..< 4 {
            guard let nowCell = recommendCollectionView.cellForItem(at: IndexPath(row: i, section: 0)) as? CodiRecommendCollectionViewCell else {
                fixStatus.append(0)
                continue
            }

            fixStatus.append(nowCell.isSelected ? 0 : 1)
        }

        CodiListGenerator.shared.getNextCodiDataSet(fixStatus)

        refreshCodiData()
    }

    @IBAction func saveButtonPressed(_: UIButton) {
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

        codiRecommendCollectionCell.configureCell(title: ViewData.Title.fashionType[indexPath.item], clothingData: CodiListGenerator.shared.topCodiDataSet[indexPath.item], indexPath: indexPath)

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
                    guard let tabBarController = self.tabBarController as? MainTabBarController else { return }
                    tabBarController.presentToastMessage("날씨 정보를 불러오는데 실패했습니다.")
                }
            }
        }
    }

    func locationManager(_: CLLocationManager, didChangeAuthorization _: CLAuthorizationStatus) {
        let locationAuthStatus = CLLocationManager.authorizationStatus()
        switch locationAuthStatus {
        case .authorizedWhenInUse:
            break
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

        guard let tabBarController = self.tabBarController as? MainTabBarController else { return }
        tabBarController.presentToastMessage("로그인에 성공했습니다.")
    }
}
