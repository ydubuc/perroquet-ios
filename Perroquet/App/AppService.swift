//
//  AppService.swift
//  Perroquet
//
//  Created by Yoan Dubuc on 3/5/24.
//

import Foundation

class AppService {
    private let url: String
    private let courier: Courier
    private let stash: Stash

    init(
        url: String,
        courier: Courier = Courier(),
        stash: Stash = Stash.shared
    ) {
        self.url = url.appending("/")
        self.courier = courier
        self.stash = stash
    }
}
