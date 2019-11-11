//
//  RequestAPIData.swift
//  DeepFashion
//
//  Created by MinKyeongTae on 10/11/2019.
//  Copyright © 2019 MinKyeongTae. All rights reserved.
//

import Foundation

enum APIMode: String {
    case userDataPost = "userDataPost"
}

struct APIURL {
    static let base = "http://deepfashion.io/"
    struct SubURL {
        static let userDataPost = "user_data_post/"
    }
}


final class RequestAPI {
    static let shared: RequestAPI = RequestAPI()
    
    /// MARK: - Properties
    weak var delegate: RequestAPIDelegate?
    
    func getUserAPIData() {
        let userId = CommonUserData.shared.id
        let userPassword = CommonUserData.shared.password
        let userStyle = CommonUserData.shared.style
        let userGender = CommonUserData.shared.gender
        let userData = UserData(userName: userId, styles: userStyle, password: userPassword, gender: userGender)
        print("userData is... : \(userData)")
    }
    
    func postUserAPIData(userData: UserData, completion: @escaping (UserAPIData?) -> () ) {
        
        let userDataPostURLString = "\(APIURL.base)\(APIURL.SubURL.userDataPost)"
        
        
        let userDataToPost = UserAPIData(userName: userData.userName, gender: userData.gender, styles: userData.style, password: userData.password)
        guard let userAPIData = try? JSONEncoder().encode(userDataToPost),
            let postURL = URL(string: userDataPostURLString) else { return }
        
        var urlRequest = URLRequest(url: postURL)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // URLSession을 만들어 Post 작용을 시작한다.
        let urlSession = URLSession.shared
        urlSession.uploadTask(with: urlRequest, from: userAPIData) {
            (data, response, error) in
            
            if error != nil {
                print("Error Occurred...!")
//                fatalError(error?.localizedDescription ?? "The Error Occurred")
            }
            
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
