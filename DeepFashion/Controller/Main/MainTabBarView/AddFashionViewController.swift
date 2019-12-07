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

    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var styleButton: UIButton!
    @IBOutlet var clothingImageView: UIImageView!
    @IBOutlet var typeSegmentedControl: UISegmentedControl!
    @IBOutlet var weatherButtons: [UIButton]!
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
        fashionTypeAlertController.fashionTypePickerView.dataSource = self
        nameTextField.delegate = self
        nameTextField.delegate = self
        navigationController?.navigationBar.isHidden = true

        clothingImageView.image = selectedFashionData.image

        configureFashionTypeSegmentedControl()
        configureFashionWeatherButtons()
    }

    override func viewWillAppear(_: Bool) {
        super.viewWillAppear(true)
        configureFashionStyleButton()
        checkFillInData()
    }

    // MARK: Methods

    private func configureRegistrationButton() {
        registrationButton.isEnabled = false
    }

    /// fashionNameTextField 값이 들어갔는지 확인하는 메서드
    private func isNameTextFieldEmpty() -> Bool {
        guard let nameText = nameTextField.text else { return false }
        return nameText.trimmingCharacters(in: .whitespaces).isEmpty ? false : true
    }

    /// weatherButtons가 적어도 1개 이상 설정되어있는지 확인하는 메서드
    private func checkWeatherButtonSetting() -> Bool {
        for i in weatherButtons.indices {
            if weatherButtons[i].isSelected { return true }
        }
        return false
    }

    /// styleButton이 최소 1개 이상 설정되어있는지 확인하는 메서드
    private func checkStyleButtonSetting() -> Bool {
        return selectedFashionData.style.count != 0
    }

    private func configureFashionStyleButton() {
        if selectedFashionData.style.count == 0 { return }
        var fashionStyleButtonTitle = ""
        for i in selectedFashionData.style.indices {
            if selectedFashionData.style[i].1 == 1 {
                fashionStyleButtonTitle += "\(selectedFashionData.style[i].0)"
                if i != selectedFashionData.style.count - 1 { fashionStyleButtonTitle += " " }
            }
        }

        styleButton.setTitle("\(fashionStyleButtonTitle)", for: .normal)
    }

    private func configureFashionTypeSegmentedControl() {
        // 초기 선택 인덱스를 설정
        typeSegmentedControl.selectedSegmentIndex = 0
    }

    private func configureFashionWeatherButtons() {
        for i in weatherButtons.indices {
            if i == 0 { weatherButtons[i].isSelected = true }
            else { weatherButtons[i].isSelected = false }
        }
    }

    private func selectFashionWeatherButton(_ button: UIButton) {
        var selectedIndex = 0
        for i in weatherButtons.indices {
            if button == weatherButtons[i] {
                selectedIndex = i
                break
            }
        }

        if weatherButtons[selectedIndex].isSelected {
            selectedFashionData.weatherIndex[selectedIndex] = 0
            weatherButtons[selectedIndex].isSelected.toggle()
        } else {
            selectedFashionData.weatherIndex[selectedIndex] = 1
            weatherButtons[selectedIndex].isSelected.toggle()
        }
    }

    private func checkCharacter(textField _: UITextField, character: String) -> Bool {
        let alphabetSet = CharacterSet(charactersIn: MyCharacterSet.signUpAlphabet).inverted
        let numberSet = CharacterSet(charactersIn: MyCharacterSet.signUpNumber).inverted
        return character.rangeOfCharacter(from: alphabetSet) == nil
            || character.rangeOfCharacter(from: numberSet) == nil
    }

    private func checkFillInData() {
        if checkStyleButtonSetting(), checkWeatherButtonSetting(), isNameTextFieldEmpty() {
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

    // MARK: - IBActions

    @IBAction func addFashionButton(_: UIButton) {
        // 이미지, 이름 셋팅
        guard let fashionImage = selectedFashionData.image,
            let fashionName = nameTextField.text else { return }
        // 옷 타입, 스타일 셋팅
        let fashionType = selectedFashionData.typeIndex
        let fashionStyle = selectedFashionData.style
        // 옷 날씨타입 셋팅
        var fashionWeatherIndex = [Int]()
        for i in 0 ..< 4 {
            if selectedFashionData.weatherIndex[i] == 1 { fashionWeatherIndex.append(i) }
        }
        let clothingData = UserClothingData(image: fashionImage, name: fashionName, fashionType: fashionType, fashionWeahter: fashionWeatherIndex, fashionStyle: fashionStyle)
        CommonUserData.shared.addUserClothing(clothingData)
        print("now Adding Clothing Data : \(clothingData)")

        let clotingData = UserClothingAPIData(style: 0, name: "clothing", color: "white", season: 0, part: 0, images: selectedFashionData.image)
        RequestAPI.shared.postAPIData(userData: clotingData, APIMode: APIPostMode.styleImagePost) { _, isSucceed in
            if isSucceed {
                print("Clothing Post Succeed!!!")
                DispatchQueue.main.async {
                    self.navigationController?.popViewController(animated: true)
                }
            } else {
                print("Clothing Post Error!!!")
                DispatchQueue.main.async {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }

        print(CommonUserData.shared.userClothingList)
    }

    @IBAction func editStyleButtonPressed(_: UIButton) {
        let storyboard = UIStoryboard(name: UIIdentifier.mainStoryboard, bundle: nil)
        guard let styleSelectViewController = storyboard.instantiateViewController(withIdentifier: UIIdentifier.ViewController.editStyle) as? EditStyleViewController else { return }
        styleSelectViewController.selectedStyle = selectedFashionData.style
        print(selectedFashionData.style)
        navigationController?.pushViewController(styleSelectViewController, animated: true)
    }

    @IBAction func cancelButton(_: UIButton) {
        navigationController?.popViewController(animated: true)
    }

    @IBAction func fashionTypeSegmentedControlValueChanged(_ sender: UISegmentedControl) {
        selectedFashionData.typeIndex = sender.selectedSegmentIndex
        print("now SelectedTypeIndex : \(selectedFashionData.typeIndex)")
    }

    @IBAction func fashionWeatherButtonPressed(_ sender: UIButton) {
        selectFashionWeatherButton(sender)
        checkFillInData()
    }

    @IBAction func nameTextFieldEditingChanged(_: UITextField) {
        checkFillInData()
    }
}

extension AddFashionViewController: UIPickerViewDataSource {
    func numberOfComponents(in _: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_: UIPickerView, numberOfRowsInComponent _: Int) -> Int {
        return ViewData.Title.fashionType.count
    }

    func pickerView(_: UIPickerView, titleForRow row: Int, forComponent _: Int) -> String? {
        return "\(ViewData.Title.fashionType[row])"
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
