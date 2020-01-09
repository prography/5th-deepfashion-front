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

        struct SignUpView {
            static let firstSignUp = "계정/성별 설정"
            static let lastSignUp = "선호스타일 설정"
        }

        struct MainTabBarView {
            static let recommend = "마이 추천 리스트"
            static let closetList = "마이 옷장 리스트"
            static let photoAdd = "옷장 사진 추가"
            static let codiList = "마이 코디 리스트"
            static let myPage = "마이 페이지"
            static let privacy = "개인정보/보안"
            static let deleteUser = "회원탈퇴"
        }
    }

    struct Color {
        static let clothingAddView = ColorList.pale
        static let border = ColorList.lightPeach?.cgColor
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
            static let privacyTableView = ["비밀번호변경", "스타일변경", "회원탈퇴"]

            enum MyPage: Int {
                case notice = 0
                case privacy = 1
                case rule = 2
                case logout = 3
            }

            enum Privacy: Int {
                case password = 0
                case style = 1
                case deleteUser = 2
            }
        }
    }
}
