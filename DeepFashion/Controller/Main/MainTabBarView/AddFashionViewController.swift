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

    // MARK: Methods

    private func configureRegistrationButton() {
        registrationButton.isEnabled = false
    }

    /// fashionNameTextField 값이 들어갔는지 확인하는 메서드
//    private func isNameTextFieldEmpty() -> Bool {
//        guard let nameText = nameTextField.text else { return false }
//        return nameText.trimmingCharacters(in: .whitespaces).isEmpty ? false : true
//    }

    /// styleButton이 최소 1개 이상 설정되어있는지 확인하는 메서드
    private func checkStyleButtonSetting() -> Bool {
        return selectedFashionData.style.count != 0
    }

//    private func configureFashionStyleButton() {
//        if selectedFashionData.style.count == 0 { return }
//        var fashionStyleButtonTitle = ""
//        for i in selectedFashionData.style.indices {
//            if selectedFashionData.style[i].1 == 1 {
//                fashionStyleButtonTitle += "\(selectedFashionData.style[i].0)"
//                if i != selectedFashionData.style.count - 1 { fashionStyleButtonTitle += " " }
//            }
//        }
//
//        styleButton.setTitle("\(fashionStyleButtonTitle)", for: .normal)
//    }
//
//    private func configureFashionTypeSegmentedControl() {
//        // 초기 선택 인덱스를 설정
//        typeSegmentedControl.selectedSegmentIndex = 0
//    }

    private func checkCharacter(textField _: UITextField, character: String) -> Bool {
        let alphabetSet = CharacterSet(charactersIn: MyCharacterSet.signUpAlphabet).inverted
        let numberSet = CharacterSet(charactersIn: MyCharacterSet.signUpNumber).inverted
        return character.rangeOfCharacter(from: alphabetSet) == nil
            || character.rangeOfCharacter(from: numberSet) == nil
    }

    private func checkFillInData() {
//        if checkStyleButtonSetting(), isNameTextFieldEmpty() {
//            makeRegistrationButtonEnabled()
//        } else {
//            makeRegistrationButtonDisabled()
//        }
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
        // 이미지, 이름 셋팅
//        guard let fashionImage = selectedFashionData.image,
//            let fashionName = nameTextField.text else { return }
//        // 옷 타입, 스타일 셋팅
//        let fashionType = selectedFashionData.typeIndex
//        let fashionStyle = selectedFashionData.style
//        let weatherIndex = weatherSegmentedControl.selectedSegmentIndex
//
//        let clothingData = UserClothingData(image: fashionImage, name: fashionName, fashionType: fashionType, fashionWeahter: weatherIndex, fashionStyle: fashionStyle)
//        CommonUserData.shared.addUserClothing(clothingData)
//        print("now Adding Clothing Data : \(clothingData)")
//
//        let clotingData = UserClothingAPIData(style: 1, name: fashionName, color: "white", owner: 1, season: weatherIndex + 1, part: typeSegmentedControl.selectedSegmentIndex + 1, images: [1])
//        RequestAPI.shared.postAPIData(userData: clotingData, APIMode: APIPostMode.clothingPost) { errorType in
//            if errorType == nil {
//                print("clothing/ Post Succeed!!!")
//                // clothing/ post에 성공하면 clothing/upload/ post 로 실제 이미지를 보낸다.
//                self.uploadClothingImage()
//            } else {
//                print("Clothing Post Error!!!")
//                DispatchQueue.main.async {
//                    self.presentBasicOneButtonAlertController(title: "이미지 등록 실패", message: "이미지 등록에 실패했습니다.") {}
//                }
//            }
//        }
//
//        print(CommonUserData.shared.userClothingList)
    }

    @IBAction func cancelButton(_: UIButton) {
        navigationController?.popViewController(animated: true)
    }

//    @IBAction func editStyleButtonPressed(_: UIButton) {
//        let storyboard = UIStoryboard(name: UIIdentifier.mainStoryboard, bundle: nil)
//        guard let styleSelectViewController = storyboard.instantiateViewController(withIdentifier: UIIdentifier.ViewController.editStyle) as? EditStyleViewController else { return }
//        styleSelectViewController.selectedStyle = selectedFashionData.style
//        print(selectedFashionData.style)
//        navigationController?.pushViewController(styleSelectViewController, animated: true)
//    }
//
//    @IBAction func fashionTypeSegmentedControlValueChanged(_ sender: UISegmentedControl) {
//        selectedFashionData.typeIndex = sender.selectedSegmentIndex
//        print("now SelectedTypeIndex : \(selectedFashionData.typeIndex)")
//    }
//
//    @IBAction func fashionWeatherSegmentedControlValueChanged(_ sender: UISegmentedControl) {
//        selectedFashionData.weatherIndex = sender.selectedSegmentIndex
//    }
//
//    @IBAction func nameTextFieldEditingChanged(_: UITextField) {
//        checkFillInData()
//    }
}

// extension AddFashionViewController: UITextFieldDelegate {
//    func textField(_ textField: UITextField, shouldChangeCharactersIn _: NSRange, replacementString string: String) -> Bool {
//        return checkCharacter(textField: textField, character: string)
//    }
//
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        textField.resignFirstResponder()
//        return true
//    }
// }

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

        return addFashionTableCell
    }
}

extension AddFashionViewController: UIViewControllerSetting {
    func configureViewController() {
//        fashionTypeAlertController.fashionTypePickerView.dataSource = self
//        nameTextField.delegate = self

        addFashionTableView.delegate = self
        addFashionTableView.dataSource = self
        addFashionTableView.allowsSelection = false
        navigationController?.navigationBar.isHidden = true

        clothingImageView.image = selectedFashionData.image

//        configureFashionTypeSegmentedControl()
    }
}
