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
    private var colorSelectCollectionView: ColorSelectCollectionView = {
        let collectionViewLayout = ColorSelectCollectionViewFlowLayout()
        let colorSelectCollectionView = ColorSelectCollectionView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: collectionViewLayout)
        return colorSelectCollectionView
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
        editStackView.addArrangedSubview(colorSelectCollectionView)
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
        colorSelectCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.colorSelectCollectionView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0),
            self.colorSelectCollectionView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0),
            self.colorSelectCollectionView.heightAnchor.constraint(equalToConstant: 160),
        ])
    }
}

extension AddFashionTableViewCell: UICollectionViewDelegate {}

extension AddFashionTableViewCell: UICollectionViewDataSource {
    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        // colorType.count 들어갈 예정
        return 32
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let colorCell = collectionView.dequeueReusableCell(withReuseIdentifier: UIIdentifier.Cell.CollectionView.colorSelect, for: indexPath) as? ColorSelectCollectionViewCell else { return UICollectionViewCell() }
        colorCell.backgroundColor = .black
        return colorCell
    }
}
