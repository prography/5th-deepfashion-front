//
//  AddFashionTableViewCell.swift
//  DeepFashion
//
//  Created by MinKyeongTae on 2019/12/20.
//  Copyright © 2019 MinKyeongTae. All rights reserved.
//

import UIKit

class AddFashionTableViewCell: UITableViewCell {
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var styleButton: UIButton!
    @IBOutlet var typeSegmentedControl: UISegmentedControl!
    @IBOutlet var weatherSegmentedControl: UISegmentedControl!
    @IBOutlet var editStackView: UIStackView!

    private var colorSelectStackView: UIStackView = {
        let colorSelectStackView = UIStackView()
        colorSelectStackView.spacing = 5
        colorSelectStackView.axis = .vertical
        colorSelectStackView.alignment = .center
        colorSelectStackView.distribution = .fillProportionally
        return colorSelectStackView
    }()

    private var colorSelectCollectionView: ColorSelectCollectionView = {
        let collectionViewLayout = ColorSelectCollectionViewFlowLayout()
        let colorSelectCollectionView = ColorSelectCollectionView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: collectionViewLayout)
        return colorSelectCollectionView
    }()

    private var colorSelectTitleLabel: UILabel = {
        let colorSelectTitleLabel = UILabel()
        colorSelectTitleLabel.text = "옷 색상"
        colorSelectTitleLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 17.0)
        colorSelectTitleLabel.textColor = .white
        colorSelectTitleLabel.backgroundColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
        return colorSelectTitleLabel
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
        colorSelectStackView.addArrangedSubview(colorSelectTitleLabel)
        colorSelectStackView.addArrangedSubview(colorSelectCollectionView)
        editStackView.addArrangedSubview(colorSelectStackView)
        colorSelectCollectionView.allowsSelection = true
        colorSelectCollectionView.delegate = self
        colorSelectCollectionView.dataSource = self
        colorSelectCollectionView.register(ColorSelectCollectionViewCell.self, forCellWithReuseIdentifier: UIIdentifier.Cell.CollectionView.colorSelect)
        configureFashionTypeSegmentedControl()
        makeConstraint()
    }

    /// fashionNameTextField 값이 들어갔는지 확인하는 메서드
    func checkNameTextFieldContents() -> Bool {
        guard let nameText = nameTextField.text else { return false }
        return nameText.trimmingCharacters(in: .whitespaces).isEmpty ? false : true
    }

    private func configureFashionTypeSegmentedControl() {
        // 초기 선택 인덱스를 설정
        typeSegmentedControl.selectedSegmentIndex = 0
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
            self.colorSelectCollectionView.heightAnchor.constraint(equalToConstant: 160),
        ])

        colorSelectTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.colorSelectTitleLabel.leftAnchor.constraint(equalTo: colorSelectStackView.leftAnchor, constant: 10),
            self.colorSelectTitleLabel.rightAnchor.constraint(equalTo: colorSelectStackView.rightAnchor, constant: -10),
        ])
    }
}

extension AddFashionTableViewCell: UICollectionViewDelegate {}

extension AddFashionTableViewCell: UICollectionViewDataSource {
    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        // colorType.count 들어갈 예정
        return UIIdentifier.colorHexaCode.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let colorCell = collectionView.dequeueReusableCell(withReuseIdentifier: UIIdentifier.Cell.CollectionView.colorSelect, for: indexPath) as? ColorSelectCollectionViewCell else { return UICollectionViewCell() }
        let cellColor = UIColor(rgb: UIIdentifier.colorHexaCode[indexPath.item], alpha: 1.0)
        colorCell.configureCell(color: cellColor)
        return colorCell
    }
}
