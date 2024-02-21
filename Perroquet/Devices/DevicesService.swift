//
//  DevicesService.swift
//  Perroquet
//
//  Created by Yoan Dubuc on 2/20/24.
//

import Foundation

class DevicesService {
    private let url: String
    private let courier = Courier()
    
    init(url: String) {
        self.url = url.appending("/devices")
    }
    
    func editDevice(id: String, dto: EditDeviceDto, accessToken: String) async -> Result<Device, ApiError> {
        guard let url = URL(string: url.appending("/\(id)")) else {
            return .failure(ApiError.invalidUrl())
        }
        
        let headers = courier.headerBearerToken(accessToken: accessToken)
        let result: Result<Device, CourierError> = await courier.patch(url: url, headers: headers, body: dto)
        switch result {
        case .success(let device):
            return .success(device)
        case .failure(let courierError):
            return .failure(ApiError.fromCourierError(courierError))
        }
    }
}
