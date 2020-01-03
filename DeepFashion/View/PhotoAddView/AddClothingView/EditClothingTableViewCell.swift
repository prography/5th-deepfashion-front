//
//  AddFashionTableViewCell.swift
//  DeepFashion
//
//  Created by MinKyeongTae on 2019/12/20.
//  Copyright © 2019 MinKyeongTae. All rights reserved.
//

import UIKit

class EditClothingTableViewCell: UITableViewCell {
    // MARK: UIs

    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var styleButton: UIButton!
    @IBOutlet var mainTypeSegmentedControl: UISegmentedControl!
    @IBOutlet var subTypeButton: UIButton!

    @IBOutlet var seasonSegmentedControl: UISegmentedControl!
    @IBOutlet var editStackView: UIStackView!
    @IBOutlet var subTitleLabelList: [UILabel]!

    private var colorSelectStackView: UIStackView = {
        let colorSelectStackView = UIStackView()
        colorSelectStackView.spacing = 5
        colorSelectStackView.axis = .vertical
        colorSelectStackView.alignment = .center
        colorSelectStackView.distribution = .fillProportionally
        return colorSelectStackView
    }()

    var colorSelectCollectionView: ColorSelectCollectionView = {
        let collectionViewLayout = ColorSelectCollectionViewFlowLayout()
        let colorSelectCollectionView = ColorSelectCollectionView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: collectionViewLayout)
        return colorSelectCollectionView
    }()

    private var colorSelectTitleLabel: UILabel = {
        let colorSelectTitleLabel = UILabel()
        colorSelectTitleLabel.text = "옷 색상"
        colorSelectTitleLabel.font = UIFont.mainFont(displaySize: 16)
        colorSelectTitleLabel.textColor = .black
        colorSelectTitleLabel.backgroundColor = ViewData.Color.clothingAddView
        return colorSelectTitleLabel
    }()

    // MARK: Life Cycle

    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = ViewData.Color.clothingAddView
        colorSelectStackView.addArrangedSubview(colorSelectTitleLabel)
        colorSelectStackView.addArrangedSubview(colorSelectCollectionView)
        editStackView.addArrangedSubview(colorSelectStackView)
        colorSelectCollectionView.dataSource = self
        colorSelectCollectionView.register(ColorSelectCollectionViewCell.self, forCellWithReuseIdentifier: UIIdentifier.Cell.CollectionView.colorSelect)
        configureSubTitleLabelList()
        configureSegmentedControl()
        configureStyleButton()
        configureSubTypeButton()
        configureNameTextField()
        makeConstraint()
        colorSelectCollectionView.allowsSelection = true
    }

    // MARK: Methods

    func getSelectedColorIndex() -> Int? {
        guard let _selectedIndex = self.colorSelectCollectionView.indexPathsForSelectedItems,
            let selectedIndex = _selectedIndex.first,
            let selectedCell = colorSelectCollectionView.cellForItem(at: selectedIndex) as? ColorSelectCollectionViewCell,
            let colorIndex = UIIdentifier.Color.colorHexaCodeIndex[selectedCell.nowRGB] else { return nil }
        return colorIndex
    }

    /// fashionNameTextField 값이 들어갔는지 확인하는 메서드
    func checkNameTextFieldContents() -> Bool {
        guard let nameText = nameTextField.text else { return false }
        return nameText.trimmingCharacters(in: .whitespaces).isEmpty ? false : true
    }

    private func configureStyleButton() {
        styleButton.layer.cornerRadius = 10
//        styleButton.layer.borderColor = ViewData.Color.borderColor
        styleButton.layer.borderWidth = 1
        styleButton.clipsToBounds = true
    }

    private func configureSubTypeButton() {
        subTypeButton.layer.cornerRadius = 10
//        subTypeButton.layer.borderColor = ViewData.Color.borderColor
        subTypeButton.layer.borderWidth = 1
        subTypeButton.clipsToBounds = true
    }

    private func configureNameTextField() {
        nameTextField.layer.cornerRadius = 10
//        nameTextField.layer.borderColor = ViewData.Color.borderColor
        nameTextField.layer.borderWidth = 1
        nameTextField.clipsToBounds = true
    }

    private func configureSubTitleLabelList() {
        for i in subTitleLabelList.indices {
            if i == 0 {
                subTitleLabelList[i].font = UIFont.subFont(displaySize: 16)
            } else {
                subTitleLabelList[i].font = UIFont.mainFont(displaySize: 16)
            }
        }
    }

    private func configureSegmentedControl() {
        // 초기 선택 인덱스를 설정
        mainTypeSegmentedControl.selectedSegmentIndex = 0
        mainTypeSegmentedControl.layer.cornerRadius = 10
        mainTypeSegmentedControl.layer.borderWidth = 1
        mainTypeSegmentedControl.clipsToBounds = true

        seasonSegmentedControl.selectedSegmentIndex = 0
        seasonSegmentedControl.layer.cornerRadius = 10
        seasonSegmentedControl.clipsToBounds = true
        seasonSegmentedControl.layer.borderWidth = 1
    }

    private func makeConstraint() {
        colorSelectStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.colorSelectStackView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0),
            self.colorSelectStackView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0),
        ])

        colorSelectCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.colorSelectCollectionView.leftAnchor.constraint(equalTo: colorSelectStackView.leftAnchor, constant: 0),
            self.colorSelectCollectionView.rightAnchor.constraint(equalTo: colorSelectStackView.rightAnchor, constant: 0),
            self.colorSelectCollectionView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width / 2 - colorSelectCollectionView.contentInset.left * 3),
        ])

        colorSelectTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.colorSelectTitleLabel.leftAnchor.constraint(equalTo: colorSelectStackView.leftAnchor, constant: 10),
            self.colorSelectTitleLabel.rightAnchor.constraint(equalTo: colorSelectStackView.rightAnchor, constant: -10),
            self.colorSelectTitleLabel.heightAnchor.constraint(equalToConstant: 30),
        ])
    }
}

extension EditClothingTableViewCell: UICollectionViewDataSource {
    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return UIIdentifier.Color.colorHexaCode.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let colorCell = collectionView.dequeueReusableCell(withReuseIdentifier: UIIdentifier.Cell.CollectionView.colorSelect, for: indexPath) as? ColorSelectCollectionViewCell else { return UICollectionViewCell() }

        colorCell.configureCell(rgb: UIIdentifier.Color.colorHexaCode[indexPath.item])
        return colorCell
    }
}
