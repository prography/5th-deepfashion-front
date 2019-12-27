//
//  AddFashionViewController.swift
//  DeepFashion
//
//  Created by MinKyeongTae on 2019/11/27.
//  Copyright © 2019 MinKyeongTae. All rights reserved.
//

import UIKit

class EditClothingViewController: UIViewController {
    // MARK: IBOutlet

    @IBOutlet var addFashionTableView: UITableView!
    @IBOutlet var clothingImageView: UIImageView!
    @IBOutlet var addFashionButton: UIButton!
    @IBOutlet var cancelButton: UIButton!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!

    // MARK: Properties

    var selectedFashionData = FashionData()

    private var isColorSelected = false {
        didSet {
            checkFillInData()
        }
    }

    private var isRequestAPI = false {
        willSet {
            DispatchQueue.main.async {
                self.addFashionButton.isEnabled = !newValue
                self.cancelButton.isEnabled = !newValue
                self.activityIndicator.checkIndicatorView(newValue)
            }
        }
    }

    private let fashionTypeAlertController: TypeAlertController = {
        let fashionAlertController = TypeAlertController(title: "패션분류 선택", message: "패션 분류를 선택해주세요.", preferredStyle: .actionSheet)
        return fashionAlertController
    }()

    // MARK: Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
    }

    override func viewWillAppear(_: Bool) {
        super.viewWillAppear(true)
        RequestAPI.shared.delegate = self
    }

    override func viewDidAppear(_: Bool) {
        super.viewDidAppear(true)
    }

    override func viewWillDisappear(_: Bool) {
        super.viewWillDisappear(true)
        view.endEditing(true)
    }

    // MARK: Methods

    private func configureRegistrationButton() {
        makeRegistrationButtonDisabled()
    }

    //    /// styleButton이 최소 1개 이상 설정되어있는지 확인하는 메서드
    //    private func checkStyleButtonSetting() -> Bool {
    //        return selectedFashionData.style.count != 0
    //    }

    private func configureFashionStyleButton() {
        guard let addFashionTableCell = addFashionTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? EditClothingTableViewCell else { return }

        addFashionTableCell.styleButton.setTitle("  \(selectedFashionData.style.0)", for: .normal)
    }

    private func checkCharacter(textField _: UITextField, character: String) -> Bool {
        let alphabetSet = CharacterSet(charactersIn: MyCharacterSet.signUpAlphabet).inverted
        let numberSet = CharacterSet(charactersIn: MyCharacterSet.signUpNumber).inverted
        return character.rangeOfCharacter(from: alphabetSet) == nil
            || character.rangeOfCharacter(from: numberSet) == nil
    }

    private func checkFillInData() {
        guard let addFashionTableCell = addFashionTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? EditClothingTableViewCell else { return }

        if isColorSelected, addFashionTableCell.checkNameTextFieldContents() {
            makeRegistrationButtonEnabled()
        } else {
            makeRegistrationButtonDisabled()
        }
    }

    private func makeRegistrationButtonDisabled() {
        addFashionButton.configureDisabledButton()
        addFashionButton.layer.cornerRadius = 0
    }

    private func makeRegistrationButtonEnabled() {
        addFashionButton.configureEnabledButton()
        addFashionButton.layer.cornerRadius = 0
    }

    private func uploadClothingImage() {
        guard let navigationController = self.navigationController else { return }
        // clothingUploadAPIData 를 정의 후 사용하자.
        DispatchQueue.main.async {
            let clothingUploadData = UserClothingUploadData(clothingCode: UserCommonData.shared.nowClothingCode, clothingImage: self.clothingImageView.image, ownerPK: UserCommonData.shared.pk)
            RequestAPI.shared.postAPIData(userData: clothingUploadData, APIMode: .clothingUploadPost) { errorType in

                if errorType == nil {
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: UIIdentifier.Segue.unwindToClothingAdd, sender: nil)
                    }
                } else {
                    // Present Error AlertController
                    ToastView.shared.presentShortMessage(navigationController.view, message: "옷 저장에 실패했습니다.")
                }
            }
        }
    }

    func refreshStyleButton() {
        guard let addFashionTableCell = addFashionTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? EditClothingTableViewCell else { return }
        DispatchQueue.main.async {
            addFashionTableCell.styleButton.setTitle("  \(self.selectedFashionData.style.0)", for: .normal)
        }
    }

    // MARK: - IBActions

    @IBAction func addFashionButtonPressed(_: UIButton) {
        guard let addFashionTableCell = addFashionTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? EditClothingTableViewCell,
            let navigationController = self.navigationController else { return }

        // 이미지, 이름 셋팅
        guard let fashionImage = selectedFashionData.image,
            let fashionName = addFashionTableCell.nameTextField.text,
            let selectedColorIndex = addFashionTableCell.getColorSelectCollectionCellSelectedIndex() else { return }
        // 옷 타입, 스타일 셋팅

        let typeIndex = addFashionTableCell.typeSegmentedControl.selectedSegmentIndex
        let fashionStyle = selectedFashionData.style
        let weatherIndex = addFashionTableCell.weatherSegmentedControl.selectedSegmentIndex
        let ownerIndex = UserCommonData.shared.pk
        let clothingData = UserClothingData(image: fashionImage, name: fashionName, id: 1, fashionType: typeIndex, fashionWeahter: weatherIndex, fashionStyle: fashionStyle)
        UserCommonData.shared.addUserClothing(clothingData)

        let clotingData = ClothingAPIData(style: fashionStyle.1 + 1, name: fashionName, color: selectedColorIndex.item + 1, owner: ownerIndex, season: weatherIndex + 1, part: typeIndex + 1, images: [])

        print("now Adding clothingData : \(clotingData)")
        RequestAPI.shared.postAPIData(userData: clotingData, APIMode: APIPostMode.clothingPost) { errorType in
            if errorType == nil {
                // clothing/ post에 성공하면 clothing/upload/ post 로 실제 이미지를 보낸다.
                self.uploadClothingImage()
            } else {
                DispatchQueue.main.async {
                    ToastView.shared.presentShortMessage(navigationController.view, message: "옷 저장에 실패했습니다.")
                }
            }
        }
    }

    @IBAction func cancelButtonPressed(_: UIButton) {
        navigationController?.popViewController(animated: true)
    }

    @objc func fashionTypeSegmentedControlValueChanged(_ sender: UISegmentedControl) {
        selectedFashionData.typeIndex = sender.selectedSegmentIndex
    }

    @objc func fashionWeatherSegmentedControlValueChanged(_ sender: UISegmentedControl) {
        selectedFashionData.weatherIndex = sender.selectedSegmentIndex
    }

    @objc func nameTextFieldEditingChanged(_: UITextField) {
        checkFillInData()
    }

    @objc func styleButtonPressed(_: UIButton) {
        let storyBoard = UIStoryboard(name: UIIdentifier.mainStoryboard, bundle: nil)
        guard let editStyleViewController = storyBoard.instantiateViewController(withIdentifier: UIIdentifier.ViewController.editStyle) as? EditStyleViewController else { return }

        editStyleViewController.selectedStyle = selectedFashionData.style
        navigationController?.pushViewController(editStyleViewController, animated: true)
    }
}

extension EditClothingViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn _: NSRange, replacementString string: String) -> Bool {
        return checkCharacter(textField: textField, character: string)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        checkFillInData()
        return true
    }
}

extension EditClothingViewController: UITableViewDelegate {
    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        return 700
    }

    func tableView(_: UITableView, shouldHighlightRowAt _: IndexPath) -> Bool {
        view.endEditing(true)
        return false
    }
}

extension EditClothingViewController: UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let addFashionTableCell = tableView.dequeueReusableCell(withIdentifier: UIIdentifier.Cell.TableView.editClothing, for: indexPath) as? EditClothingTableViewCell else { return UITableViewCell() }
        addFashionTableCell.nameTextField.delegate = self
        addFashionTableCell.nameTextField.addTarget(self, action: #selector(nameTextFieldEditingChanged(_:)), for: .editingChanged)
        addFashionTableCell.weatherSegmentedControl.addTarget(self, action: #selector(fashionWeatherSegmentedControlValueChanged), for: .valueChanged)
        addFashionTableCell.typeSegmentedControl.addTarget(self, action: #selector(fashionTypeSegmentedControlValueChanged), for: .valueChanged)
        addFashionTableCell.styleButton.addTarget(self, action: #selector(styleButtonPressed(_:)), for: .touchUpInside)

        addFashionTableCell.styleButton.setTitle("  \(selectedFashionData.style.0)", for: .normal)
        addFashionTableCell.colorSelectCollectionView.delegate = self

        return addFashionTableCell
    }
}

extension EditClothingViewController: UICollectionViewDelegate {
    func collectionView(_: UICollectionView, didSelectItemAt _: IndexPath) {
        isColorSelected = true
    }
}

extension EditClothingViewController: RequestAPIDelegate {
    func requestAPIDidBegin() {
        isRequestAPI = true
    }

    func requestAPIDidFinished() {
        isRequestAPI = false
    }

    func requestAPIDidError() {
        isRequestAPI = false
    }
}

extension EditClothingViewController: UIViewControllerSetting {
    func configureViewController() {
        addFashionTableView.delegate = self
        addFashionTableView.dataSource = self
        navigationController?.navigationBar.isHidden = true
        view.backgroundColor = ViewData.Color.clothingAddView
        clothingImageView.image = selectedFashionData.image
        clothingImageView.backgroundColor = ColorList.beige
        addFashionButton.configureEnabledButton()
    }
}
