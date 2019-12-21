//
//  AddFashionViewController.swift
//  DeepFashion
//
//  Created by MinKyeongTae on 2019/11/27.
//  Copyright © 2019 MinKyeongTae. All rights reserved.
//

import UIKit

class AddFashionViewController: UIViewController {
    // MARK: IBOutlet

    @IBOutlet var addFashionTableView: UITableView!
    @IBOutlet var clothingImageView: UIImageView!
    @IBOutlet var registrationButton: UIButton!

    // MARK: Properties

    var selectedFashionData = FashionData()

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
//        configureFashionStyleButton()
        checkFillInData()
    }

    override func viewDidAppear(_: Bool) {
        super.viewDidAppear(true)
        DispatchQueue.main.async {
            self.addFashionTableView.reloadData()
        }
    }

    // MARK: Methods

    private func configureRegistrationButton() {
        registrationButton.isEnabled = false
    }

    /// styleButton이 최소 1개 이상 설정되어있는지 확인하는 메서드
    private func checkStyleButtonSetting() -> Bool {
        return selectedFashionData.style.count != 0
    }

    private func configureFashionStyleButton() {
        guard let addFashionTableCell = addFashionTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? AddFashionTableViewCell else { return }

        if selectedFashionData.style.count == 0 { return }
        var fashionStyleButtonTitle = ""
        for i in selectedFashionData.style.indices {
            if selectedFashionData.style[i].1 == 1 {
                fashionStyleButtonTitle += "\(selectedFashionData.style[i].0)"
                if i != selectedFashionData.style.count - 1 { fashionStyleButtonTitle += " " }
            }
        }

        addFashionTableCell.styleButton.setTitle("\(fashionStyleButtonTitle)", for: .normal)
    }

    private func checkCharacter(textField _: UITextField, character: String) -> Bool {
        let alphabetSet = CharacterSet(charactersIn: MyCharacterSet.signUpAlphabet).inverted
        let numberSet = CharacterSet(charactersIn: MyCharacterSet.signUpNumber).inverted
        return character.rangeOfCharacter(from: alphabetSet) == nil
            || character.rangeOfCharacter(from: numberSet) == nil
    }

    private func checkFillInData() {
        guard let addFashionTableCell = addFashionTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? AddFashionTableViewCell else { return }

        if checkStyleButtonSetting(), addFashionTableCell.checkNameTextFieldContents() {
            makeRegistrationButtonEnabled()
        } else {
            makeRegistrationButtonDisabled()
        }
    }

    private func makeRegistrationButtonDisabled() {
        registrationButton.isEnabled = false
        registrationButton.alpha = 0.7
    }

    private func makeRegistrationButtonEnabled() {
        registrationButton.isEnabled = true
        registrationButton.alpha = 1.0
    }

    private func uploadClothingImage() {
        // clothingUploadAPIData 를 정의 후 사용하자.
        DispatchQueue.main.async {
            let clothingUploadData = UserClothingUploadData(clothingCode: CommonUserData.shared.nowClothingCode, clothingImage: self.clothingImageView.image, ownerPK: CommonUserData.shared.pk)
            RequestAPI.shared.postAPIData(userData: clothingUploadData, APIMode: .clothingUploadPost) { errorType in

                if errorType == nil {
                    self.navigationController?.popViewController(animated: true)
                } else {
                    // Present Error AlertController
                }
            }
        }
    }

    // MARK: - IBActions

    @IBAction func addFashionButton(_: UIButton) {
        guard let addFashionTableCell = addFashionTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? AddFashionTableViewCell else { return }

        // 이미지, 이름 셋팅
        guard let fashionImage = selectedFashionData.image,
            addFashionTableCell.checkNameTextFieldContents(),
            let fashionName = addFashionTableCell.nameTextField.text else { return }
        // 옷 타입, 스타일 셋팅

        let typeIndex = addFashionTableCell.typeSegmentedControl.selectedSegmentIndex
        let fashionStyle = selectedFashionData.style
        let weatherIndex = addFashionTableCell.weatherSegmentedControl.selectedSegmentIndex

        let clothingData = UserClothingData(image: fashionImage, name: fashionName, fashionType: typeIndex, fashionWeahter: weatherIndex, fashionStyle: fashionStyle)
        CommonUserData.shared.addUserClothing(clothingData)
        print("now Adding Clothing Data : \(clothingData)")

        let clotingData = UserClothingAPIData(style: 1, name: fashionName, color: "white", owner: 1, season: weatherIndex + 1, part: typeIndex + 1, images: [1])
        RequestAPI.shared.postAPIData(userData: clotingData, APIMode: APIPostMode.clothingPost) { errorType in
            if errorType == nil {
                print("clothing/ Post Succeed!!!")
                // clothing/ post에 성공하면 clothing/upload/ post 로 실제 이미지를 보낸다.
                self.uploadClothingImage()
            } else {
                print("Clothing Post Error!!!")
                DispatchQueue.main.async {
                    self.presentBasicOneButtonAlertController(title: "이미지 등록 실패", message: "이미지 등록에 실패했습니다.") {}
                }
            }
        }

        print(CommonUserData.shared.userClothingList)
    }

    @IBAction func cancelButton(_: UIButton) {
        navigationController?.popViewController(animated: true)
    }

    @objc func fashionTypeSegmentedControlValueChanged(_ sender: UISegmentedControl) {
        selectedFashionData.typeIndex = sender.selectedSegmentIndex
        print("now SelectedTypeIndex : \(selectedFashionData.typeIndex)")
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

        editStyleViewController.selectedStyleIndex = selectedFashionData.style
        navigationController?.pushViewController(editStyleViewController, animated: true)
    }
}

extension AddFashionViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn _: NSRange, replacementString string: String) -> Bool {
        return checkCharacter(textField: textField, character: string)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension AddFashionViewController: UITableViewDelegate {
    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        return 600
    }
}

extension AddFashionViewController: UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let addFashionTableCell = tableView.dequeueReusableCell(withIdentifier: UIIdentifier.Cell.TableView.addFashion, for: indexPath) as? AddFashionTableViewCell else { return UITableViewCell() }
        addFashionTableCell.nameTextField.delegate = self
        addFashionTableCell.nameTextField.addTarget(self, action: #selector(nameTextFieldEditingChanged(_:)), for: .editingChanged)
        addFashionTableCell.weatherSegmentedControl.addTarget(self, action: #selector(fashionWeatherSegmentedControlValueChanged), for: .valueChanged)
        addFashionTableCell.typeSegmentedControl.addTarget(self, action: #selector(fashionTypeSegmentedControlValueChanged), for: .valueChanged)
        addFashionTableCell.styleButton.addTarget(self, action: #selector(styleButtonPressed(_:)), for: .touchUpInside)

        var styleButtonText = ""
        for i in selectedFashionData.style.indices {
            if selectedFashionData.style[i].1 == 1 {
                styleButtonText.append("\(selectedFashionData.style[i].0) ")
            }
        }
        addFashionTableCell.styleButton.setTitle(styleButtonText, for: .normal)

        return addFashionTableCell
    }
}

extension AddFashionViewController: UIViewControllerSetting {
    func configureViewController() {
        addFashionTableView.delegate = self
        addFashionTableView.dataSource = self
        addFashionTableView.allowsSelection = false
        navigationController?.navigationBar.isHidden = true

        clothingImageView.image = selectedFashionData.image
    }
}
