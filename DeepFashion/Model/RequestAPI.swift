//
//  RequestAPIData.swift
//  DeepFashion
//
//  Created by MinKyeongTae on 10/11/2019.
//  Copyright © 2019 MinKyeongTae. All rights reserved.
//

import Foundation

final class RequestAPI {
    static let shared: RequestAPI = RequestAPI()
    
    /// MARK: - Properties
    weak var delegate: RequestAPIDelegate?
    
    
}
