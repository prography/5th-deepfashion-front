//
//  RequestAPIData.swift
//  DeepFashion
//
//  Created by MinKyeongTae on 10/11/2019.
//  Copyright © 2019 MinKyeongTae. All rights reserved.
//

import UIKit

enum NetworkError {
    case client
    case server
    case wrongType
    case duplicate
    case unknown

    var errorTitle: String {
        switch self {
        case .client:
            return "클라이언트 에러"
        case .server:
            return "서버 에러"
        case .wrongType:
            return "올바르지 않은 입력"
        case .duplicate:
            return ""
        case .unknown:
            return "예기치 못한 에러"
        }
    }

    var errorMessage: String {
        switch self {
        case .client:
            return "클라이언트 문제가 발생했습니다. "
        case .server:
            return "네트워크 상태가 불안정 합니다."
        case .wrongType:
            return "올바른 입력을 해주시기 바랍니다."
        case .unknown:
            return "예기치 못한 에러가 발생했습니다."
        default: return ""
        }
    }
}

enum APIPostMode: String {
    case signUpAccounts
    case loginData
    case clothing
    case codiList
}

enum APIDeleteMode: String {
    case deleteUser
    case deleteClothing
    case deleteCodiList
}

enum APIGetMode: String {
    case getWeather
    case getClothing
    case getCodiList
    case getUserData
}

enum APIPutMode: String {
    case putUserData
}

struct APIURL {
    static let base = "http://deepfashion-dev.us-west-2.elasticbeanstalk.com/"
    struct SubURL {
        struct Delete {
            static let user = "accounts/"
            static let clothing = "clothing/"
            static let codiList = "clothing/codilist/"
        }

        struct Get {
            static let currentWeather = "weather/current-weather/"
            static let clothing = "clothing/"
            static let codiList = "clothing/codilist/"
            static let user = "accounts/"
        }

        struct Post {
            static let accounts = "accounts/"
            static let login = "accounts/login/"
            static let styleImage = "accounts/"
            static let clothing = "clothing/"
            static let clothingUpload = "clothing/upload"
            static let codiList = "clothing/codilist/"
        }

        struct Put {
            static let accounts = "accounts/"
        }
    }
}

final class RequestAPI {
    static let shared: RequestAPI = RequestAPI()

    // MARK: - Properties

//    private var isWeatherRequested = false

    private let urlSession = URLSession(configuration: .default)
    private var dataTask = URLSessionDataTask()

    weak var delegate: RequestAPIDelegate?

    func getAPIData<T: Codable>(APIMode: APIGetMode, type _: T.Type, completion: @escaping (NetworkError?, T?) -> Void) {
        var errorType: NetworkError = .unknown
        delegate?.requestAPIDidBegin()

        switch APIMode {
        case .getUserData:
            let requestAPIURLString = "\(APIURL.base)\(APIURL.SubURL.Get.user)\(CommonUserData.shared.pk)/"
            debugPrint("now url : \(requestAPIURLString)")

            guard let url = URL(string: requestAPIURLString) else { return }
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "GET"
            urlRequest.addValue("token \(CommonUserData.shared.userToken)", forHTTPHeaderField: "Authorization")
            urlSession.dataTask(with: urlRequest, completionHandler: { (data, _, _) -> Void in
                guard let data = data else {
                    errorType = .client
                    self.delegate?.requestAPIDidError()
                    completion(errorType, nil)
                    return
                }

                do {
                    let userAPIData = try JSONDecoder().decode(T.self, from: data)
                    self.delegate?.requestAPIDidFinished()
                    completion(nil, userAPIData)
                } catch {
                    errorType = .client
                    self.delegate?.requestAPIDidError()
                    completion(errorType, nil)
                }

            }).resume()
        case .getWeather:

            let requestAPIURLString = "\(APIURL.base)\(APIURL.SubURL.Get.currentWeather)"
            guard let requestAPIURL = URL(string: requestAPIURLString) else { return }
            var urlRequest = URLRequest(url: requestAPIURL)
            urlRequest.httpMethod = "GET"
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            urlSession.dataTask(with: requestAPIURL) { data, response, error in
                if error != nil {
//                    self.isWeatherRequested = false
                    completion(self.configureError(.client), nil)
                    return
                }

                guard let weatherData = data else {
//                    self.isWeatherRequested = false
                    completion(self.configureError(.client), nil)
                    return
                }

                guard let weatherAPIData = try? JSONDecoder().decode(T.self, from: weatherData) else {
                    errorType = .client
//                    self.isWeatherRequested = false
                    self.delegate?.requestAPIDidError()
                    completion(errorType, nil)
                    return
                }

                if let response = response as? HTTPURLResponse {
                    if (200 ... 299).contains(response.statusCode) {
//                        self.isWeatherRequested = false
                        self.delegate?.requestAPIDidFinished()
                        completion(nil, weatherAPIData)
                    } else {
                        debugPrint("request failed : \(response.statusCode)")
//                        self.isWeatherRequested = false
                        self.delegate?.requestAPIDidError()
                        self.classifyErrorType(statusCode: response.statusCode, errorType: &errorType)
                        completion(errorType, nil)
                    }
                }
            }.resume()

        case .getClothing:
            let requestAPIURLString = "\(APIURL.base)\(APIURL.SubURL.Get.clothing)"
            guard let url = URL(string: requestAPIURLString) else { return }
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "GET"
            urlRequest.addValue("token \(CommonUserData.shared.userToken)", forHTTPHeaderField: "Authorization")
            urlSession.dataTask(with: urlRequest, completionHandler: { (data, _, _) -> Void in
                guard let data = data else {
                    errorType = .client
                    self.delegate?.requestAPIDidError()
                    completion(errorType, nil)
                    return
                }

                do {
                    let weatherAPIData = try JSONDecoder().decode(T.self, from: data)
                    self.delegate?.requestAPIDidFinished()
                    completion(nil, weatherAPIData)
                } catch {
                    errorType = .client
                    self.delegate?.requestAPIDidError()
                    completion(errorType, nil)
                }

            }).resume()
        case .getCodiList:
            let requestAPIURLString = "\(APIURL.base)\(APIURL.SubURL.Get.codiList)"
            guard let url = URL(string: requestAPIURLString) else { return }
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "GET"
            urlRequest.addValue("token \(CommonUserData.shared.userToken)", forHTTPHeaderField: "Authorization")
            urlSession.dataTask(with: urlRequest, completionHandler: { (data, _, _) -> Void in
                guard let data = data else {
                    errorType = .client
                    self.delegate?.requestAPIDidError()
                    completion(errorType, nil)
                    return
                }

                do {
                    let weatherAPIData = try JSONDecoder().decode(T.self, from: data)
                    self.delegate?.requestAPIDidFinished()
                    completion(nil, weatherAPIData)
                } catch {
                    errorType = .client
                    self.delegate?.requestAPIDidError()
                    completion(errorType, nil)
                }

            }).resume()
        }
    }

    func deleteAPIData(APIMode: APIDeleteMode, targetId: Int = 0, completion: @escaping (NetworkError?) -> Void) {
        var errorType: NetworkError = .unknown

        delegate?.requestAPIDidBegin()

        var deleteURLString: String
        var deleteURL: URL

        switch APIMode {
        case .deleteUser:
            deleteURLString = "\(APIURL.base)\(APIURL.SubURL.Delete.user)\(CommonUserData.shared.pk)/"
            guard let _deleteURL = URL(string: deleteURLString) else {
                completion(configureError(.client))
                return
            }
            deleteURL = _deleteURL
        case .deleteClothing:
            deleteURLString = "\(APIURL.base)\(APIURL.SubURL.Delete.clothing)\(targetId)/"
            guard let _deleteURL = URL(string: deleteURLString) else {
                completion(configureError(.client))
                return
            }
            deleteURL = _deleteURL
        case .deleteCodiList:
            deleteURLString = "\(APIURL.base)\(APIURL.SubURL.Delete.codiList)\(targetId)/"
            guard let _deleteURL = URL(string: deleteURLString) else {
                completion(configureError(.client))
                return
            }
            deleteURL = _deleteURL
        }

        var urlRequest = URLRequest(url: deleteURL)
        urlRequest.httpMethod = "DELETE"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("token \(CommonUserData.shared.userToken)", forHTTPHeaderField: "Authorization")

        urlSession.dataTask(with: urlRequest) { _, response, error in
            if error != nil {
                completion(self.configureError(.client))
                return
            }

            if let response = response as? HTTPURLResponse {
                if (200 ... 299).contains(response.statusCode) {
                    self.delegate?.requestAPIDidFinished()
                    completion(nil)
                } else {
                    debugPrint("request failed : \(response.statusCode)")
                    self.delegate?.requestAPIDidError()
                    self.classifyErrorType(statusCode: response.statusCode, errorType: &errorType)
                    completion(errorType)
                }
            }

        }.resume()
    }

    func putAPIData<T: Codable>(_ userData: T, APIMode: APIPutMode, completion: @escaping (NetworkError?) -> Void) {
        var nowStatusCode = 0
        var errorType: NetworkError = .unknown

        delegate?.requestAPIDidBegin()
        switch APIMode {
        case .putUserData:

            let userDataPostURLString = "\(APIURL.base)\(APIURL.SubURL.Put.accounts)\(CommonUserData.shared.pk)/"
            guard let userData = userData as? UserAPIPutData else {
                delegate?.requestAPIDidError()
                completion(NetworkError.wrongType)
                return
            }

            guard let userAPIData = try? JSONEncoder().encode(userData),
                let postURL = URL(string: userDataPostURLString) else {
                delegate?.requestAPIDidError()

                completion(NetworkError.unknown)
                return
            }

            var urlRequest = URLRequest(url: postURL)
            urlRequest.httpMethod = "PUT"
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            urlRequest.setValue("token \(CommonUserData.shared.userToken)", forHTTPHeaderField: "Authorization")

            // URLSession을 만들어 Post 작용을 시작한다.
            urlSession.uploadTask(with: urlRequest, from: userAPIData) {
                _, response, error in
                nowStatusCode = (response as? HTTPURLResponse)?.statusCode ?? 0

                if error != nil {
                    self.delegate?.requestAPIDidError()
                    self.classifyErrorType(statusCode: nowStatusCode, errorType: &errorType)
                    completion(errorType)
                    return
                }

                if let response = response as? HTTPURLResponse {
                    if (200 ... 299).contains(response.statusCode) {
                        self.delegate?.requestAPIDidFinished()
                        completion(nil)
                    } else {
                        debugPrint("request failed : \(response.statusCode)")
                        self.classifyErrorType(statusCode: nowStatusCode, errorType: &errorType)
                        completion(self.configureError(errorType))
                    }
                }
            }.resume()
        }
    }

    func postAPIData<T>(userData: T, APIMode: APIPostMode, completion: @escaping (NetworkError?) -> Void) {
        var nowStatusCode = 0
        var errorType: NetworkError = .unknown

        delegate?.requestAPIDidBegin()
        switch APIMode {
        case .loginData:

            let userDataPostURLString = "\(APIURL.base)\(APIURL.SubURL.Post.login)"
            guard let userData = userData as? LoginAPIPostData else {
                delegate?.requestAPIDidError()
                completion(NetworkError.wrongType)
                return
            }

            let userDataToPost = LoginAPIPostData(userName: userData.userName, password: userData.password)

            guard let userAPIData = try? JSONEncoder().encode(userDataToPost),
                let postURL = URL(string: userDataPostURLString) else {
                delegate?.requestAPIDidError()

                completion(NetworkError.unknown)
                return
            }

            var urlRequest = URLRequest(url: postURL)
            urlRequest.httpMethod = "POST"
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")

            // URLSession을 만들어 Post 작용을 시작한다.
            urlSession.uploadTask(with: urlRequest, from: userAPIData) {
                data, response, error in
                nowStatusCode = (response as? HTTPURLResponse)?.statusCode ?? 0

                if error != nil {
                    self.delegate?.requestAPIDidError()
                    self.classifyErrorType(statusCode: nowStatusCode, errorType: &errorType)
                    completion(errorType)
                    return
                }

                guard let data = data,
                    let userData = try? JSONDecoder().decode(LoginAPIData.self, from: data) else {
                    self.classifyErrorType(statusCode: nowStatusCode, errorType: &errorType)
                    completion(self.configureError(errorType))
                    return
                }

                // MARK: - Token Check

                CommonUserData.shared.setUserPrivateData(token: userData.token, pk: userData.pk)
                debugPrint("token : \(userData.token)")
                debugPrint("pk : \(userData.pk)")

                if let response = response as? HTTPURLResponse {
                    if (200 ... 299).contains(response.statusCode) {
                        self.delegate?.requestAPIDidFinished()
                        completion(nil)
                    } else {
                        debugPrint("request failed : \(response.statusCode)")
                        self.classifyErrorType(statusCode: nowStatusCode, errorType: &errorType)
                        completion(self.configureError(errorType))
                    }
                }
            }.resume()

        case .signUpAccounts:

            guard let userData = userData as? UserAPIPostData else {
                delegate?.requestAPIDidError()
                completion(NetworkError.client)
                return
            }

            let userDataPostURLString = "\(APIURL.base)\(APIURL.SubURL.Post.accounts)"
            let userDataToPost = UserAPIPostData(userName: userData.userName, gender: userData.gender, styles: userData.styles, password: userData.password)
            guard let userAPIData = try? JSONEncoder().encode(userDataToPost),
                let postURL = URL(string: userDataPostURLString) else {
                completion(configureError(.client))
                return
            }

            var urlRequest = URLRequest(url: postURL)
            urlRequest.httpMethod = "POST"
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")

            // URLSession을 만들어 Post 작용을 시작한다.
            urlSession.uploadTask(with: urlRequest, from: userAPIData) {
                _, response, error in

                if error != nil {
                    self.classifyErrorType(statusCode: nowStatusCode, errorType: &errorType)
                    completion(self.configureError(.client))
                    return
                }

//                guard let _resultData = data,
//                    let resultData = try? JSONDecoder().decode(UserAPIData.self, from: _resultData) else {
//                        completion(self.configureError(.client))
//                        return
//                }

                if let response = response as? HTTPURLResponse {
                    if (200 ... 299).contains(response.statusCode) {
                        debugPrint("request successed : \(response.statusCode)")
                        self.delegate?.requestAPIDidFinished()
                        completion(nil)
                    } else {
                        debugPrint("request failed : \(response.statusCode)")
                        self.classifyErrorType(statusCode: nowStatusCode, errorType: &errorType)
                        completion(self.configureError(errorType))
                    }
                }
            }.resume()

        case .clothing:

            guard let userData = userData as? ClothingPostData else {
                completion(configureError(.wrongType))
                return
            }

            let userDataPostURLString = "\(APIURL.base)\(APIURL.SubURL.Post.clothing)"
            guard let postURL = URL(string: userDataPostURLString) else { return }
            debugPrint("userDataPostURLString : \(userDataPostURLString)")

            let imageName = AssetIdentifier.Image.clothing
            userData.image?.accessibilityIdentifier = imageName

            // post 처리 할 parameter를 정의한다.
            let parameter = [
                "name": "\(userData.name)",
                "style": "\(userData.style)",
                "owner": "\(CommonUserData.shared.pk)",
                "color": "\(userData.color)",
                "season": "\(userData.season)",
                "part": "\(userData.part)",
                "category": "\(userData.category)",
            ]

            // request 설정
            var urlRequest = URLRequest(url: postURL)
            urlRequest.setValue("token \(CommonUserData.shared.userToken)", forHTTPHeaderField: "Authorization")
            urlRequest.httpMethod = "POST"

            // multipart form-data로 보낼 것임을 설정한다.
            let boundary = "Boundary-\(UUID().uuidString)"
            urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

            let clothingMimeType = "image/jpg"
            let clothingImageKey = "img"

            guard let imageData = userData.image?.jpegData(compressionQuality: 0.1) else { return }

            urlRequest.httpBody = createBody(parameters: parameter, boundary: boundary, data: imageData, mimeType: clothingMimeType, fileKey: clothingImageKey, imageName: imageName)
            // URLSession을 만들어 Post 작용을 시작한다.
            urlSession.dataTask(with: urlRequest) { _, response, _ in
                if let response = response as? HTTPURLResponse {
                    if (200 ... 299).contains(response.statusCode) {
                        debugPrint("request successed : \(response.statusCode)")
                        self.delegate?.requestAPIDidFinished()
                        completion(nil)
                    } else {
                        debugPrint("request failed : \(response.statusCode)")
                        self.delegate?.requestAPIDidError()
                        self.classifyErrorType(statusCode: nowStatusCode, errorType: &errorType)
                        completion(errorType)
                    }
                }
            }.resume()
        case .codiList:

            guard let userData = userData as? CodiListAPIData else {
                delegate?.requestAPIDidError()
                completion(NetworkError.client)
                return
            }

            let userDataPostURLString = "\(APIURL.base)\(APIURL.SubURL.Post.codiList)"
            guard let codiListAPIData = try? JSONEncoder().encode(userData),
                let postURL = URL(string: userDataPostURLString) else {
                completion(configureError(.client))
                return
            }

            var urlRequest = URLRequest(url: postURL)
            urlRequest.httpMethod = "POST"
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            urlRequest.setValue("token \(CommonUserData.shared.userToken)", forHTTPHeaderField: "Authorization")

            // URLSession을 만들어 Post 작용을 시작한다.
            urlSession.uploadTask(with: urlRequest, from: codiListAPIData) {
                _, response, error in

                if error != nil {
                    self.classifyErrorType(statusCode: nowStatusCode, errorType: &errorType)
                    completion(self.configureError(.client))
                    return
                }

                if let response = response as? HTTPURLResponse {
                    if (200 ... 299).contains(response.statusCode) {
                        debugPrint("request successed : \(response.statusCode)")
                        self.delegate?.requestAPIDidFinished()
                        completion(nil)
                    } else {
                        debugPrint("request failed : \(response.statusCode)")
                        self.classifyErrorType(statusCode: nowStatusCode, errorType: &errorType)
                        completion(self.configureError(errorType))
                    }
                }
            }.resume()
        }
    }

    private func createBody(parameters: [String: String],
                            boundary: String,
                            data: Data,
                            mimeType: String,
                            fileKey _: String,
                            imageName _: String) -> Data {
        let body = NSMutableData()
        let boundaryPrefix = "--\(boundary)\r\n"
        for (key, value) in parameters {
            body.appendString(boundaryPrefix)
            body.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
            body.appendString("\(value)\r\n")
        }

        body.appendString(boundaryPrefix)
        body.appendString("Content-Disposition: form-data; name=\"\("img")\"; filename=\"\("clothing.jpg")\"\r\n")
        body.appendString("Content-Type: \(mimeType)\r\n\r\n")
        body.append(data)
        body.appendString("\r\n")
        body.appendString("--".appending(boundary.appending("--")))

        return body as Data
    }

    func classifyErrorType(statusCode: Int, errorType: inout NetworkError) {
        if statusCode / 100 == 4 { errorType = .client }
        else if statusCode / 100 == 5 { errorType = .server }
        else { errorType = .unknown }
    }

    func configureError(_ errorType: NetworkError) -> NetworkError {
        let errorType: NetworkError = .client
        delegate?.requestAPIDidError()
        return errorType
    }

    func resetProperties() {
//        isWeatherRequested = false
    }
}
