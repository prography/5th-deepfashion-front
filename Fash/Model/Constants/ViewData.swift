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
        static let fashionType = ["TOP", "OUTER", "BOTTOM", "SHOES"]

        struct SignUpView {
            static let firstSignUp = "계정/성별 설정"
            static let lastSignUp = "선호스타일 설정"
        }

        struct MainTabBarView {
            static let recommend = "추천리스트"
            static let closetList = "옷장"
            static let photoAdd = "옷장 사진추가"
            static let codiList = "코디리스트"
            static let myPage = "마이 페이지"
            static let privacy = "개인정보/보안"
            static let deleteUser = "회원탈퇴"
        }
    }

    struct Section {
        struct Count {
            static let myPageTableView = 1
        }

        struct Row {
            struct Height {
                static let closetList: CGFloat = 120
                static let privacy: CGFloat = 50
            }

            static let myPageTableView = ["공지사항", "개인/보안", "이용약관", "로그아웃"]
            static let privacyTableView = ["유저정보변경", "스타일변경", "회원탈퇴"]

            enum MyPage: Int {
                case notice = 0
                case privacy = 1
                case rule = 2
                case logout = 3
            }

            enum Privacy: Int {
                case editUser = 0
                case style = 1
                case deleteUser = 2
            }
        }
    }
}
