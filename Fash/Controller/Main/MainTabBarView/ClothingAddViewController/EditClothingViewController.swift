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

    @IBOutlet var editClothingTableView: UITableView!
    @IBOutlet var clothingImageView: UIImageView!
    @IBOutlet var addClothingButton: UIButton!
    @IBOutlet var cancelButton: UIButton!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!

    // MARK: Properties

    var selectedClothingData = ClothingData()
    var deepResultList = [Int](repeating: 0, count: 4)
    private var clothingSubTypeIndexList = [(Int, SubCategory)]()
    private var selectedClothingSubTypeIndexList = [(Int, SubCategory)]()

    private let typePickerAlertController: PickerAlertController = {
        let typePickerAlertController = PickerAlertController(title: "소분류 선택", message: "옷 소분류를 선택해주세요.", preferredStyle: .actionSheet)
        typePickerAlertController.pickerView.tag = UIIdentifier.Tag.typePickerView
        return typePickerAlertController
    }()

    private let stylePickerAlertController: PickerAlertController = {
        let stylePickerAlertController = PickerAlertController(title: "스타일 선택", message: "옷 스타일을 선택해주세요.", preferredStyle: .actionSheet)
        stylePickerAlertController.pickerView.tag = UIIdentifier.Tag.stylePickerView
        return stylePickerAlertController
    }()

    private var isColorSelected = false {
        didSet {
            checkFillInData()
        }
    }

    private var fashionStyles: [String] = {
        var fashionStyles = [String]()
        fashionStyles = UserCommonData.shared.gender == 0 ? ClothingStyle.male : ClothingStyle.female
        return fashionStyles
    }()

    private var isRequestAPI = false {
        willSet {
            DispatchQueue.main.async {
                self.addClothingButton.isEnabled = !newValue
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

        guard let addClothingTableCell = editClothingTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? EditClothingTableViewCell else { return }
        if let colorIndex = UIIdentifier.Color.colorHexaCodeIndex[selectedClothingData.colorIndex] {
            addClothingTableCell.colorSelectCollectionView.selectItem(at: IndexPath(item: colorIndex, section: 0), animated: true, scrollPosition: [])
        }
    }

    override func viewWillDisappear(_: Bool) {
        super.viewWillDisappear(true)
        view.endEditing(true)
    }

    // MARK: Methods

    private func configureRegistrationButton() {
        makeRegistrationButtonDisabled()
    }

    private func presentSubTypePickerAlertController() {
        configureSubTypePickerAlertController()
        guard let defaultType = selectedClothingSubTypeIndexList.first else { return }
        selectedClothingData.categoryIndex = defaultType
        present(typePickerAlertController, animated: true) { [weak self] in
            self?.refreshTypeButton()
        }
    }

    private func presentSubStylePickerAlertController() {
        configureSubStylePickerAlertController()
        guard let defaultStyle = fashionStyles.first else { return }
        selectedClothingData.style = (defaultStyle, 0)

        present(stylePickerAlertController, animated: true) { [weak self] in
            self?.refreshStyleButton()
        }
    }

    private func configureClothingSubTypeIndex() {
        for (key, value) in ClothingIndex.subCategoryList {
            clothingSubTypeIndexList.append((key, value))
        }
    }

    private func checkCharacter(textField _: UITextField, character: String) -> Bool {
        let alphabetSet = CharacterSet(charactersIn: MyCharacterSet.signUpAlphabet).inverted
        let numberSet = CharacterSet(charactersIn: MyCharacterSet.signUpNumber).inverted
        let koreanSet = CharacterSet(charactersIn: MyCharacterSet.korean).inverted
        return character.rangeOfCharacter(from: alphabetSet) == nil
            || character.rangeOfCharacter(from: numberSet) == nil
            || character.rangeOfCharacter(from: koreanSet) == nil
    }

    private func checkFillInData() {
        guard let addFashionTableCell = editClothingTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? EditClothingTableViewCell else { return }

        if addFashionTableCell.checkNameTextFieldContents() {
            makeRegistrationButtonEnabled()
        } else {
            makeRegistrationButtonDisabled()
        }
    }

    private func makeRegistrationButtonDisabled() {
//        addClothingButton.configureDisabledButton()
//        addClothingButton.layer.cornerRadius = 0
        addClothingButton.isEnabled = false
        addClothingButton.alpha = 0.7
    }

    private func makeRegistrationButtonEnabled() {
//        addClothingButton.configureEnabledButton()
//        addClothingButton.layer.cornerRadius = 0
        addClothingButton.isEnabled = true
        addClothingButton.alpha = 1.0
    }

    private func configureSubTypeButton() {
        selectedClothingSubTypeIndexList = clothingSubTypeIndexList.filter {
            $0.1.mainIndex == 0 && $0.0 != 15
        }
    }

    private func configureSubTypePickerAlertController() {
        typePickerAlertController.pickerView.delegate = self
        typePickerAlertController.pickerView.dataSource = self
    }

    private func configureSubStylePickerAlertController() {
        stylePickerAlertController.pickerView.delegate = self
        stylePickerAlertController.pickerView.dataSource = self
    }

    private func configureSelectedClothingData() {
        // color
        selectedClothingData.colorIndex = ClothingIndex.deepColorList[deepResultList[0]]

        // style
        var styleIndex = ClothingIndex.deepStyleList[deepResultList[1]]

        if (UserCommonData.shared.gender == 0 && !ClothingStyle.male.contains(ClothingStyle.styleList[styleIndex])) ||
            (UserCommonData.shared.gender == 1 && !ClothingStyle.female.contains(ClothingStyle.styleList[styleIndex])) {
            styleIndex = 1
        }

        selectedClothingData.style = (ClothingStyle.styleList[styleIndex - 1], styleIndex)

        // seasonn
        selectedClothingData.seasonIndex = ClothingIndex.deepSeasonList[deepResultList[2]]

        // category
        let subCategoryIndex = ClothingIndex.deepCategoryList[deepResultList[3]]
        guard let subCategory = ClothingIndex.subCategoryList[subCategoryIndex] else { return }
        selectedClothingData.categoryIndex = (subCategoryIndex, subCategory)
    }

    private func refreshTypeButton() {
        guard let addClothingTableCell = editClothingTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? EditClothingTableViewCell else { return }
        addClothingTableCell.subTypeButton.setTitle(" \(selectedClothingData.categoryIndex.1.name)", for: .normal)
    }

    private func refreshStyleButton() {
        guard let addFashionTableCell = editClothingTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? EditClothingTableViewCell else { return }
        DispatchQueue.main.async {
            addFashionTableCell.styleButton.setTitle("  \(self.selectedClothingData.style.0)", for: .normal)
        }
    }

    // MARK: - IBActions

    @IBAction func addClothingButtonPressed(_: UIButton) {
        if isRequestAPI == true { return }
        beginIgnoringInteractionEvents()
        guard let addFashionTableCell = editClothingTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? EditClothingTableViewCell,
            let navigationController = self.navigationController else { return }

        // 이미지, 이름 셋팅
        guard let clothingImage = selectedClothingData.image,
            let clothingName = addFashionTableCell.nameTextField.text,
            let selectedColorIndex = addFashionTableCell.getSelectedColorIndex() else { return }

        // 옷 타입, 스타일 셋팅

        let partName = ClothingIndex.shared.getMainCategoryName(addFashionTableCell.mainTypeSegmentedControl.selectedSegmentIndex)
        let partServerIndex = ClothingIndex.shared.convertToMainServerIndex(partName)
        let clothingStyle = selectedClothingData.style
        let seasonIndex = addFashionTableCell.seasonSegmentedControl.selectedSegmentIndex
        let ownerPK = UserCommonData.shared.pk

        let clothingData = ClothingPostData(id: nil, name: clothingName, style: clothingStyle.1 + 1, owner: ownerPK, color: selectedColorIndex + 1, season: seasonIndex + 1, part: partServerIndex, category: selectedClothingData.categoryIndex.0, image: clothingImage)

        debugPrint("nowClothingData: \(clothingData)")
        RequestAPI.shared.postAPIData(userData: clothingData, APIMode: APIPostMode.clothing) { errorType in
            if errorType == nil {
                // clothing/ post에 성공하면 clothing/upload/ post 로 실제 이미지를 보낸다.

                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: UIIdentifier.Segue.unwindToClothingAdd, sender: nil)
                }
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

    @objc func clothingTypeSegmentedControlPressed(_ sender: UISegmentedControl) {
        guard let addClothingTableCell = editClothingTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? EditClothingTableViewCell else { return }

        selectedClothingData.typeIndex = sender.selectedSegmentIndex

        if selectedClothingData.typeIndex < 4 {
            selectedClothingSubTypeIndexList = clothingSubTypeIndexList.filter {
                $0.1.mainIndex == selectedClothingData.typeIndex && $0.0 != 15
            }
        } else {
            selectedClothingSubTypeIndexList = [(15, ClothingIndex.subCategoryList[15]!)]
        }

        guard let initialSubTypeIndex = selectedClothingSubTypeIndexList.first else { return }

        selectedClothingData.categoryIndex = initialSubTypeIndex
        addClothingTableCell.subTypeButton.setTitle(" \(String(describing: initialSubTypeIndex.1.name))", for: .normal)
    }

    @objc func clothingSeasonSegmentedControlPressed(_ sender: UISegmentedControl) {
        selectedClothingData.seasonIndex = sender.selectedSegmentIndex
    }

    @objc func nameTextFieldEditingChanged(_: UITextField) {
        checkFillInData()
    }

    @objc func styleButtonPressed(_: UIButton) {
        presentSubStylePickerAlertController()
    }

    @objc func subTypeButtonPressed(_: UIButton) {
        // 서브 카테고리 피커뷰를 띄워 선택할 수 있게 한다.
        presentSubTypePickerAlertController()
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
        guard let addClothingTableCell = tableView.dequeueReusableCell(withIdentifier: UIIdentifier.Cell.TableView.editClothing, for: indexPath) as? EditClothingTableViewCell else { return UITableViewCell() }

        addClothingTableCell.nameTextField.delegate = self
        addClothingTableCell.colorSelectCollectionView.delegate = self
        addClothingTableCell.colorSelectCollectionView.allowsMultipleSelection = false

        addClothingTableCell.nameTextField.addTarget(self, action: #selector(nameTextFieldEditingChanged(_:)), for: .editingChanged)
        addClothingTableCell.seasonSegmentedControl.addTarget(self, action: #selector(clothingSeasonSegmentedControlPressed(_:)), for: .valueChanged)
        addClothingTableCell.seasonSegmentedControl.selectedSegmentIndex = selectedClothingData.seasonIndex

        // 메인 카테고리 설정
        addClothingTableCell.mainTypeSegmentedControl.addTarget(self, action: #selector(clothingTypeSegmentedControlPressed(_:)), for: .valueChanged)
        addClothingTableCell.mainTypeSegmentedControl.selectedSegmentIndex = selectedClothingData.categoryIndex.1.mainIndex

        addClothingTableCell.styleButton.addTarget(self, action: #selector(styleButtonPressed(_:)), for: .touchUpInside)
        addClothingTableCell.subTypeButton.addTarget(self, action: #selector(subTypeButtonPressed(_:)), for: .touchUpInside)

        addClothingTableCell.styleButton.setTitle("  \(selectedClothingData.style.0)", for: .normal)
        addClothingTableCell.subTypeButton.setTitle(" \(selectedClothingData.categoryIndex.1.name)", for: .normal)

        return addClothingTableCell
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

extension EditClothingViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent _: Int) {
        if pickerView.tag == UIIdentifier.Tag.typePickerView {
            selectedClothingData.categoryIndex = selectedClothingSubTypeIndexList[row]
            refreshTypeButton()
        } else if pickerView.tag == UIIdentifier.Tag.stylePickerView {
            selectedClothingData.style = (fashionStyles[row], row)
            refreshStyleButton()
        }
    }
}

extension EditClothingViewController: UIPickerViewDataSource {
    func numberOfComponents(in _: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent _: Int) -> Int {
        if pickerView.tag == UIIdentifier.Tag.typePickerView {
            return selectedClothingSubTypeIndexList.count
        } else if pickerView.tag == UIIdentifier.Tag.stylePickerView {
            return fashionStyles.count
        }
        return 0
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent _: Int) -> String? {
        if pickerView.tag == UIIdentifier.Tag.typePickerView {
            return "\(selectedClothingSubTypeIndexList[row].1.name)"
        } else if pickerView.tag == UIIdentifier.Tag.stylePickerView {
            return "\(fashionStyles[row])"
        }
        return ""
    }
}

extension EditClothingViewController: UIViewControllerSetting {
    func configureViewController() {
        configureClothingSubTypeIndex()
        configureSelectedClothingData()
        editClothingTableView.delegate = self
        editClothingTableView.dataSource = self
        configureSubTypeButton()
        configureSubTypePickerAlertController()
        configureSubStylePickerAlertController()
        view.backgroundColor = ColorList.clothingAddView
        clothingImageView.image = selectedClothingData.image
        makeRegistrationButtonDisabled()
    }
}
