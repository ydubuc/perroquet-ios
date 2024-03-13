//
//  MemosService.swift
//  Perroquet
//
//  Created by Yoan Dubuc on 2/16/24.
//

import Foundation

class MemosService {
    private let url: String
    private let courier: Courier
    private let stash: Stash

    init(
        url: String,
        courier: Courier = Courier(),
        stash: Stash = Stash.shared
    ) {
        self.url = url.appending("/memos")
        self.courier = courier
        self.stash = stash
    }

    func createMemo(dto: CreateMemoDto, accessToken: String) async -> Result<Memo, ApiError> {
        guard let url = URL(string: url) else {
            return .failure(ApiError.invalidUrl())
        }

        let headers = courier.headerBearerToken(accessToken: accessToken)
        let result: Result<Memo, CourierError> = await courier.post(url: url, headers: headers, body: dto)
        switch result {
        case .success(let memo):
            stash.insertMemo(memo: memo)
            return .success(memo)
        case .failure(let courierError):
            print(courierError.code)
            return .failure(ApiError.fromCourierError(courierError))
        }
    }

    func getMemos(dto: GetMemosDto, accessToken: String) async -> Result<[Memo], ApiError> {
        guard let url = URL(string: url) else {
            return .failure(ApiError.invalidUrl())
        }

        let headers = courier.headerBearerToken(accessToken: accessToken)
        let queries = dto.toQueryItems()
        let result: Result<[Memo], CourierError> = await courier.get(url: url, headers: headers, queries: queries)
        switch result {
        case .success(let memos):
            stash.insertMemos(memos: memos)
            return .success(memos)
        case .failure(let courierError):
            return .failure(ApiError.fromCourierError(courierError))
        }
    }

    func getMemo(id: String, accessToken: String) async -> Result<Memo, ApiError> {
        guard let url = URL(string: url.appending("/\(id)")) else {
            return .failure(ApiError.invalidUrl())
        }

        let headers = courier.headerBearerToken(accessToken: accessToken)
        let result: Result<Memo, CourierError> = await courier.get(url: url, headers: headers)
        switch result {
        case .success(let memo):
            stash.insertMemo(memo: memo)
            return .success(memo)
        case .failure(let courierError):
            return .failure(ApiError.fromCourierError(courierError))
        }
    }

    func editMemo(id: String, dto: EditMemoDto, accessToken: String) async -> Result<Memo, ApiError> {
        guard let url = URL(string: url.appending("/\(id)")) else {
            return .failure(ApiError.invalidUrl())
        }

        let headers = courier.headerBearerToken(accessToken: accessToken)
        let result: Result<Memo, CourierError> = await courier.patch(url: url, headers: headers, body: dto)
        switch result {
        case .success(let memo):
            stash.updateMemo(memo: memo)
            return .success(memo)
        case .failure(let courierError):
            return .failure(ApiError.fromCourierError(courierError))
        }
    }

    func archiveMemo(id: String, accessToken: String) async -> Result<(), ApiError> {
        let dto = EditMemoDto(
            title: nil,
            description: nil,
            priority: nil,
            status: "archived",
            visibility: nil,
            frequency: nil,
            triggerAt: nil
        )
        let result = await editMemo(id: id, dto: dto, accessToken: accessToken)

        switch result {
        case .success(let memo):
            return .success(())
        case .failure(let apiError):
            return .failure(apiError)
        }
    }
}
