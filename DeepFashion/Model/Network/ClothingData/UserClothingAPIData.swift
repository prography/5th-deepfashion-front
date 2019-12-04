//
//  UserClothingAPIData.swift
//  DeepFashion
//
//  Created by MinKyeongTae on 2019/11/28.
//  Copyright © 2019 MinKyeongTae. All rights reserved.
//

// MARK: - UserClothingAPIData Post Form Struct

import UIKit

struct UserClothingAPIData: Encodable {
    let style: Int
    let name: String
    let color: String
    let season: Int
    let part: Int
    let images: UIImage?
    enum CodingKeys: String, CodingKey {
        case style, name, color, season, part, image
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        if let image = images,
            let data = image.pngData() {
            try container.encode(data, forKey: .image)
        }
    }
}
