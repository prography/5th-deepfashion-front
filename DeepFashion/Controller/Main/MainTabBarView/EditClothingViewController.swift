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

    var selectedClothingData = FashionData()
    private var clothingSubTypeIndexList = [(Int, SubCategory)]()
    private var selectedClothingSubTypeIndexList = [(Int, SubCategory)]()
    private var selectedSubTypeIndex: (Int, SubCategory) = (1, SubCategory(name: "청바지", mainIndex: 0))
    private let subTypePickerAlertController: PickerAlertController = {
        let subTypePickerAlertController = PickerAlertController(title: "소분류 선택", message: "소분류를 선택해주세요.", preferredStyle: .actionSheet)
        return subTypePickerAlertController
    }()

    private var isColorSelected = false {
        didSet {
            checkFillInData()
        }
    }

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
        subTypePickerAlertController.pickerView.delegate = self
        subTypePickerAlertController.pickerView.dataSource = self
        present(subTypePickerAlertController, animated: true) {
            self.subTypePickerAlertController.configureDefaultPickerViewIndex()
        }
    }

    private func configureClothingSubTypeIndex() {
        for (key, value) in ClothingCategoryIndex.subCategoryList {
            clothingSubTypeIndexList.append((key, value))
        }
    }

    private func configureClothingStyleButton() {
        guard let addFashionTableCell = editClothingTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? EditClothingTableViewCell else { return }

        addFashionTableCell.styleButton.setTitle("  \(selectedClothingData.style.0)", for: .normal)
    }

    private func checkCharacter(textField _: UITextField, character: String) -> Bool {
        let alphabetSet = CharacterSet(charactersIn: MyCharacterSet.signUpAlphabet).inverted
        let numberSet = CharacterSet(charactersIn: MyCharacterSet.signUpNumber).inverted
        return character.rangeOfCharacter(from: alphabetSet) == nil
            || character.rangeOfCharacter(from: numberSet) == nil
    }

    private func checkFillInData() {
        guard let addFashionTableCell = editClothingTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? EditClothingTableViewCell else { return }

        if isColorSelected, addFashionTableCell.checkNameTextFieldContents() {
            makeRegistrationButtonEnabled()
        } else {
            makeRegistrationButtonDisabled()
        }
    }

    private func makeRegistrationButtonDisabled() {
        addClothingButton.configureDisabledButton()
        addClothingButton.backgroundColor = ColorList.beige
        addClothingButton.layer.cornerRadius = 0
        addClothingButton.titleLabel?.font = UIFont.mainFont(displaySize: 18)
    }

    private func makeRegistrationButtonEnabled() {
        addClothingButton.configureEnabledButton()
        addClothingButton.layer.cornerRadius = 0
        addClothingButton.titleLabel?.font = UIFont.mainFont(displaySize: 18)
    }

    private func configureSubTypeButton() {
        selectedClothingSubTypeIndexList = clothingSubTypeIndexList.filter {
            $0.1.mainIndex == 0 && $0.0 != 15
        }

        guard let firstSubTypeIndex = selectedClothingSubTypeIndexList.first else { return }
        selectedSubTypeIndex = firstSubTypeIndex
    }

    private func configureSubTypePickerAlertController() {
        subTypePickerAlertController.pickerView.delegate = self
        subTypePickerAlertController.pickerView.dataSource = self
    }

    func refreshStyleButton() {
        guard let addFashionTableCell = editClothingTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? EditClothingTableViewCell else { return }
        DispatchQueue.main.async {
            addFashionTableCell.styleButton.setTitle("  \(self.selectedClothingData.style.0)", for: .normal)
        }
    }

    // MARK: - IBActions

    @IBAction func addFashionButtonPressed(_: UIButton) {
        guard let addFashionTableCell = editClothingTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? EditClothingTableViewCell,
            let navigationController = self.navigationController else { return }

        // 이미지, 이름 셋팅
        guard let clothingImage = selectedClothingData.image,
            let clothingName = addFashionTableCell.nameTextField.text,
            let selectedColorIndex = addFashionTableCell.getSelectedColorIndex() else { return }
        // 옷 타입, 스타일 셋팅

        let partName = ClothingCategoryIndex.shared.getMainCategoryName(addFashionTableCell.mainTypeSegmentedControl.selectedSegmentIndex)
        let partServerIndex = ClothingCategoryIndex.shared.convertToMainServerIndex(partName)
        let clothingStyle = selectedClothingData.style
        let seasonIndex = addFashionTableCell.seasonSegmentedControl.selectedSegmentIndex
        let ownerPK = UserCommonData.shared.pk

        let clothingData = ClothingPostData(id: nil, name: clothingName, style: clothingStyle.1 + 1, owner: ownerPK, color: selectedColorIndex, season: seasonIndex + 1, part: partServerIndex, category: selectedSubTypeIndex.0, image: clothingImage)

        print("nowClothingData: \(clothingData)")
        RequestAPI.shared.postAPIData(userData: clothingData, APIMode: APIPostMode.clothingPost) { errorType in
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
            selectedClothingSubTypeIndexList = [(15, ClothingCategoryIndex.subCategoryList[15]!)]
        }

        guard let firstSubTypeIndex = selectedClothingSubTypeIndexList.first else { return }
        selectedSubTypeIndex = firstSubTypeIndex
        addClothingTableCell.subTypeButton.setTitle(" \(selectedSubTypeIndex.1.name)", for: .normal)
    }

    @objc func clothingSeasonSegmentedControlPressed(_ sender: UISegmentedControl) {
        selectedClothingData.weatherIndex = sender.selectedSegmentIndex
    }

    @objc func nameTextFieldEditingChanged(_: UITextField) {
        checkFillInData()
    }

    @objc func styleButtonPressed(_: UIButton) {
        let storyBoard = UIStoryboard(name: UIIdentifier.mainStoryboard, bundle: nil)
        guard let editStyleViewController = storyBoard.instantiateViewController(withIdentifier: UIIdentifier.ViewController.editStyle) as? EditStyleViewController else { return }

        editStyleViewController.selectedStyle = selectedClothingData.style
        navigationController?.pushViewController(editStyleViewController, animated: true)
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
        addClothingTableCell.nameTextField.addTarget(self, action: #selector(nameTextFieldEditingChanged(_:)), for: .editingChanged)
        addClothingTableCell.seasonSegmentedControl.addTarget(self, action: #selector(clothingSeasonSegmentedControlPressed(_:)), for: .valueChanged)
        addClothingTableCell.mainTypeSegmentedControl.addTarget(self, action: #selector(clothingTypeSegmentedControlPressed(_:)), for: .valueChanged)
        addClothingTableCell.styleButton.addTarget(self, action: #selector(styleButtonPressed(_:)), for: .touchUpInside)
        addClothingTableCell.subTypeButton.addTarget(self, action: #selector(subTypeButtonPressed(_:)), for: .touchUpInside)

        addClothingTableCell.styleButton.setTitle("  \(selectedClothingData.style.0)", for: .normal)
        addClothingTableCell.subTypeButton.setTitle(" \(selectedSubTypeIndex.1.name)", for: .normal)
        addClothingTableCell.colorSelectCollectionView.delegate = self

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
    func pickerView(_: UIPickerView, didSelectRow row: Int, inComponent _: Int) {
        selectedSubTypeIndex = selectedClothingSubTypeIndexList[row]
        guard let addClothingTableCell = editClothingTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? EditClothingTableViewCell else { return }
        addClothingTableCell.subTypeButton.setTitle(" \(selectedSubTypeIndex.1.name)", for: .normal)
    }
}

extension EditClothingViewController: UIPickerViewDataSource {
    func numberOfComponents(in _: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_: UIPickerView, numberOfRowsInComponent _: Int) -> Int {
        return selectedClothingSubTypeIndexList.count
    }

    func pickerView(_: UIPickerView, titleForRow row: Int, forComponent _: Int) -> String? {
        return "\(selectedClothingSubTypeIndexList[row].1.name)"
    }
}

extension EditClothingViewController: UIViewControllerSetting {
    func configureViewController() {
        configureClothingSubTypeIndex()
        editClothingTableView.delegate = self
        editClothingTableView.dataSource = self
        configureSubTypeButton()
        configureSubTypePickerAlertController()
        navigationController?.navigationBar.isHidden = true
        view.backgroundColor = ViewData.Color.clothingAddView
        clothingImageView.image = selectedClothingData.image
        clothingImageView.backgroundColor = ColorList.beige
        makeRegistrationButtonDisabled()
        cancelButton.titleLabel?.font = UIFont.mainFont(displaySize: 18)
    }
}
