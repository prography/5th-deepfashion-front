//
//  RequestAPIData.swift
//  DeepFashion
//
//  Created by MinKyeongTae on 10/11/2019.
//  Copyright © 2019 MinKyeongTae. All rights reserved.
//

import Foundation

enum APIMode: String {
    case userDataPost
}

struct APIURL {
    static let base = "http://127.0.0.1:8000/"
    struct SubURL {
        static let userDataPost = "accounts/"
    }
}

final class RequestAPI {
    static let shared: RequestAPI = RequestAPI()

    // MARK: - Properties

    weak var delegate: RequestAPIDelegate?

    func printUserAPIData() {
        let userId = CommonUserData.shared.id
        let userPassword = CommonUserData.shared.password
        let userStyle = CommonUserData.shared.style
        let userGender = CommonUserData.shared.gender
        let userData = UserData(userName: userId, styles: userStyle, password: userPassword, gender: userGender)
        print("userData is... : \(userData)")
    }

    func getUserAPIData<T>(userData _: T, completion _: @escaping (UserAPIData?) -> Void) {}

    func postLoginAPIData(userData: UserLoginData, completion _: @escaping (UserTokenAPIData) -> Void) {
        let userDataPostURLString = "http://127.0.0.1:8888/accounts/login/"
        print("userDataPostURLString : \(userDataPostURLString)")

        let userDataToPost = LoginAPIPostData(userName: userData.userName, password: userData.password)
        print("userAPIData... : \(userDataToPost)")
        guard let userAPIData = try? JSONEncoder().encode(userDataToPost),
            let postURL = URL(string: userDataPostURLString) else { return }

        print("userAPIData... : \(userAPIData)")
        var urlRequest = URLRequest(url: postURL)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")

        // URLSession을 만들어 Post 작용을 시작한다.
        let urlSession = URLSession.shared
        urlSession.uploadTask(with: urlRequest, from: userAPIData) {
            data, response, error in

            if error != nil {
                print("Error Occurred...! : \(error?.localizedDescription)")
            }

            guard let data = data,
                let userData = try? JSONDecoder().decode(UserTokenAPIData.self, from: data) else {
                return
            }

            print("token is.. \(userData.token)")
            print("userAPIData : \(userData)")

            if let response = response as? HTTPURLResponse {
                print("post response : \(response)")

                if (200 ... 299).contains(response.statusCode) {
                    print("request successed : \(response.statusCode)")
                } else {
                    print("request failed : \(response.statusCode)")
                }
            }
        }.resume()
    }

    func postUserAPIData(userData: UserData, completion _: @escaping (UserAPIData?) -> Void) {
        let userDataPostURLString = "http://127.0.0.1:8888/accounts/"
        print("userDataPostURLString : \(userDataPostURLString)")
        let userDataToPost = UserAPIPostData(userName: userData.userName, gender: userData.gender, styles: userData.style, password: userData.password)
        guard let userAPIData = try? JSONEncoder().encode(userDataToPost),
            let postURL = URL(string: userDataPostURLString) else { return }

        var urlRequest = URLRequest(url: postURL)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")

        // URLSession을 만들어 Post 작용을 시작한다.
        let urlSession = URLSession.shared
        urlSession.uploadTask(with: urlRequest, from: userAPIData) {
            data, response, error in

            if error != nil {
                print("Error Occurred...! : \(error?.localizedDescription)")
            }

            guard let data = data,
                let userData = try? JSONDecoder().decode(UserAPIData.self, from: data) else {
                return
            }

            print("userAPIData : \(userData)")

            if let response = response as? HTTPURLResponse {
                print("post response : \(response)")

                if (200 ... 299).contains(response.statusCode) {
                    print("request successed : \(response.statusCode)")
                } else {
                    print("request failed : \(response.statusCode)")
                }
            }
        }.resume()
    }
}
