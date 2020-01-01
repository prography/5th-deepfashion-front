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

    var selectedFashionData = FashionData()

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

    //    /// styleButton이 최소 1개 이상 설정되어있는지 확인하는 메서드
    //    private func checkStyleButtonSetting() -> Bool {
    //        return selectedFashionData.style.count != 0
    //    }

    private func configureFashionStyleButton() {
        guard let addFashionTableCell = editClothingTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? EditClothingTableViewCell else { return }

        addFashionTableCell.styleButton.setTitle("  \(selectedFashionData.style.0)", for: .normal)
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

    private func uploadClothingImage() {
        DispatchQueue.main.async {
            guard let navigationController = self.navigationController else { return }
            // clothingUploadAPIData 를 정의 후 사용하자.

            let clothingUploadData = UserClothingUploadData(clothingCode: UserCommonData.shared.nowClothingCode, clothingImage: self.clothingImageView.image, ownerPK: UserCommonData.shared.pk)
            RequestAPI.shared.postAPIData(userData: clothingUploadData, APIMode: .clothingUploadPost) { errorType in

                if errorType == nil {
                    self.performSegue(withIdentifier: UIIdentifier.Segue.unwindToClothingAdd, sender: nil)
                } else {
                    ToastView.shared.presentShortMessage(navigationController.view, message: "옷 저장에 실패했습니다.")
                }
            }
        }
    }

    func refreshStyleButton() {
        guard let addFashionTableCell = editClothingTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? EditClothingTableViewCell else { return }
        DispatchQueue.main.async {
            addFashionTableCell.styleButton.setTitle("  \(self.selectedFashionData.style.0)", for: .normal)
        }
    }

    // MARK: - IBActions

    @IBAction func addFashionButtonPressed(_: UIButton) {
        guard let addFashionTableCell = editClothingTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? EditClothingTableViewCell,
            let navigationController = self.navigationController else { return }

        // 이미지, 이름 셋팅
        guard let clothingImage = selectedFashionData.image,
            let clothingName = addFashionTableCell.nameTextField.text,
            let selectedColorIndex = addFashionTableCell.getSelectedColorIndex() else { return }
        // 옷 타입, 스타일 셋팅

        let partServerIndex = addFashionTableCell.typeSegmentedControl.selectedSegmentIndex
        let partClientIndex = ClothingCategoryIndex.shared.convertToMainClientIndex(partServerIndex + 1)
        let clothingStyle = selectedFashionData.style
        let seasonIndex = addFashionTableCell.seasonSegmentedControl.selectedSegmentIndex
        let ownerPK = UserCommonData.shared.pk

        let clotingData = ClothingPostData(id: nil, name: clothingName, style: clothingStyle.1 + 1, owner: ownerPK, color: selectedColorIndex, season: seasonIndex + 1, part: partClientIndex + 1, category: 1, image: clothingImage)

        RequestAPI.shared.postAPIData(userData: clotingData, APIMode: APIPostMode.clothingPost) { errorType in
            if errorType == nil {
                // clothing/ post에 성공하면 clothing/upload/ post 로 실제 이미지를 보낸다.
                self.uploadClothingImage()
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

    @objc func clothingTypeSegmentedControlValueChanged(_ sender: UISegmentedControl) {
        selectedFashionData.typeIndex = sender.selectedSegmentIndex
    }

    @objc func clothingSeasonSegmentedControlValueChanged(_ sender: UISegmentedControl) {
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
        addFashionTableCell.seasonSegmentedControl.addTarget(self, action: #selector(clothingSeasonSegmentedControlValueChanged), for: .valueChanged)
        addFashionTableCell.typeSegmentedControl.addTarget(self, action: #selector(clothingTypeSegmentedControlValueChanged), for: .valueChanged)
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
        editClothingTableView.delegate = self
        editClothingTableView.dataSource = self
        navigationController?.navigationBar.isHidden = true
        view.backgroundColor = ViewData.Color.clothingAddView
        clothingImageView.image = selectedFashionData.image
        clothingImageView.backgroundColor = ColorList.beige
        makeRegistrationButtonDisabled()
        cancelButton.titleLabel?.font = UIFont.mainFont(displaySize: 18)
    }
}
