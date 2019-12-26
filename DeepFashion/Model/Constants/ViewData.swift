//
//  TitleData.swift
//  DeepFashion
//
//  Created by MinKyeongTae on 2019/11/18.
//  Copyright © 2019 MinKyeongTae. All rights reserved.
//

import UIKit

struct ViewData {
    struct Title {
        static let fashionType = ["상의", "아우터", "하의", "신발"]

        struct MainTabBarView {
            static let homeView = "마이 추천 리스트"
            static let closetListView = "마이 옷장 리스트"
            static let photoAddView = "옷장 사진 추가"
            static let codiListView = "마이 코디 리스트"
            static let myPageView = "마이 페이지"
        }
    }

    struct Color {
        static let clothingAddView = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        static let borderColor = ColorList.lightPeach?.cgColor
    }

    struct Section {
        struct Count {
            static let myPageTableView = 1
        }

        struct Row {
            static let myPageTableView = ["공지사항", "개인/보안", "스타일수정", "이용약관", "로그아웃"]
        }

        enum MyPageRow: Int {
            case notice = 0
            case privacy = 1
            case modifyStyle = 2
            case rule = 3
            case logout = 4
        }
    }

    struct Row {
        struct Height {
            static let closetList: CGFloat = 120
        }
    }
}
