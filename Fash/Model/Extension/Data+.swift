//
//  Data+.swift
//  DeepFashion
//
//  Created by MinKyeongTae on 2019/12/30.
//  Copyright © 2019 MinKyeongTae. All rights reserved.
//

import UIKit

extension Data {
    func mimeType() -> String {
        var format: UInt8 = 0
        copyBytes(to: &format, count: 1)

        switch format {
        case 0xFF:
            return "image/jpeg"
        case 0x89:
            return "image/png"
        case 0x47:
            return "image/gif"
        case 0x4D, 0x49:
            return "image/tiff"
        case 0x25:
            return "application/pdf"
        case 0xD0:
            return "application/vnd"
        case 0x46:
            return "text/plain"
        default:
            return "application/octet-stream"
        }
    }
}
