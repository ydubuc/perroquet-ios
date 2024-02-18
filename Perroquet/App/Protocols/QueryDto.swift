//
//  QueryDto.swift
//  Perroquet
//
//  Created by Yoan Dubuc on 2/17/24.
//

import Foundation

protocol QueryDto {
    func toQueryItems() -> [URLQueryItem]
}
