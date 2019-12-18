//
//  UserClothingUploadAPIData.swift
//  DeepFashion
//
//  Created by MinKyeongTae on 2019/12/18.
//  Copyright © 2019 MinKyeongTae. All rights reserved.
//

import UIKit

struct UserClothingUploadAPIData: Codable {
    var clothing: Int
    var image: UIImage?
    var owner: Int

    enum CodingKeys: String, CodingKey {
        case clothing
        case image
        case owner
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        clothing = try container.decode(Int.self, forKey: .clothing)
        owner = try container.decode(Int.self, forKey: .owner)

        if let text = try container.decodeIfPresent(String.self, forKey: .image) {
            if let data = Data(base64Encoded: text) {
                image = UIImage(data: data)
            }
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        if let image = image, let data = image.pngData() {
            try container.encode(data, forKey: .image)
        }
        try container.encode(clothing, forKey: .clothing)
        try container.encode(owner, forKey: .owner)
    }
}
