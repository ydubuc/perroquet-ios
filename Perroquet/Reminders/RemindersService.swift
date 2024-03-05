//
//  RemindersService.swift
//  Perroquet
//
//  Created by Yoan Dubuc on 2/16/24.
//

import Foundation

class RemindersService {
    private let url: String
    private let courier: Courier
    private let stash: Stash

    init(
        url: String,
        courier: Courier = Courier(),
        stash: Stash = Stash.shared
    ) {
        self.url = url.appending("/reminders")
        self.courier = courier
        self.stash = stash
    }

    func createReminder(dto: CreateReminderDto, accessToken: String) async -> Result<Reminder, ApiError> {
        guard let url = URL(string: url) else {
            return .failure(ApiError.invalidUrl())
        }

        let headers = courier.headerBearerToken(accessToken: accessToken)
        let result: Result<Reminder, CourierError> = await courier.post(url: url, headers: headers, body: dto)
        switch result {
        case .success(let reminder):
            stash.insertReminder(reminder: reminder)
            return .success(reminder)
        case .failure(let courierError):
            print(courierError.code)
            return .failure(ApiError.fromCourierError(courierError))
        }
    }

    func getReminders(dto: GetRemindersFilterDto, accessToken: String) async -> Result<[Reminder], ApiError> {
        guard let url = URL(string: url) else {
            return .failure(ApiError.invalidUrl())
        }

        let headers = courier.headerBearerToken(accessToken: accessToken)
        let queries = dto.toQueryItems()
        let result: Result<[Reminder], CourierError> = await courier.get(url: url, headers: headers, queries: queries)
        switch result {
        case .success(let reminders):
            stash.insertReminders(reminders: reminders)
            return .success(reminders)
        case .failure(let courierError):
            return .failure(ApiError.fromCourierError(courierError))
        }
    }

    func getReminder(id: String, accessToken: String) async -> Result<Reminder, ApiError> {
        guard let url = URL(string: url.appending("/\(id)")) else {
            return .failure(ApiError.invalidUrl())
        }

        let headers = courier.headerBearerToken(accessToken: accessToken)
        let result: Result<Reminder, CourierError> = await courier.get(url: url, headers: headers)
        switch result {
        case .success(let reminder):
            stash.insertReminder(reminder: reminder)
            return .success(reminder)
        case .failure(let courierError):
            return .failure(ApiError.fromCourierError(courierError))
        }
    }

    func editReminder(id: String, dto: EditReminderDto, accessToken: String) async -> Result<Reminder, ApiError> {
        guard let url = URL(string: url.appending("/\(id)")) else {
            return .failure(ApiError.invalidUrl())
        }

        let headers = courier.headerBearerToken(accessToken: accessToken)
        let result: Result<Reminder, CourierError> = await courier.patch(url: url, headers: headers, body: dto)
        switch result {
        case .success(let reminder):
            stash.updateReminder(reminder: reminder)
            return .success(reminder)
        case .failure(let courierError):
            return .failure(ApiError.fromCourierError(courierError))
        }
    }

    func deleteReminder(id: String, accessToken: String) async -> Result<(), ApiError> {
        guard let url = URL(string: url.appending("/\(id)")) else {
            return .failure(ApiError.invalidUrl())
        }

        let headers = courier.headerBearerToken(accessToken: accessToken)
        let result = await courier.delete(url: url, headers: headers)
        switch result {
        case .success:
            stash.deleteReminder(id: id)
            return .success(())
        case .failure(let courierError):
            return .failure(ApiError.fromCourierError(courierError))
        }
    }
}
