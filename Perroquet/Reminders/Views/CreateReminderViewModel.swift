//
//  CreateReminderViewModel.swift
//  Perroquet
//
//  Created by Yoan Dubuc on 2/19/24.
//

import Foundation

class CreateReminderViewModel: ObservableObject {
    let appVm: AppViewModel
    let authMan: AuthMan
    let remindersService: RemindersService
    
    @Published var title: String = ""
    @Published var body: String = ""
    @Published var frequency: String = ""
    @Published var triggerAt: Int = 0
    
    init(
        appVm: AppViewModel = AppViewModel.shared,
        authMan: AuthMan = AuthMan.shared,
        remindersService: RemindersService = RemindersService(url: Config.BACKEND_URL)
    ) {
        self.appVm = appVm
        self.authMan = authMan
        self.remindersService = remindersService
    }
    
    func createReminder() {
        let currentTime = Date().timeIntervalSince1970.milliseconds
        let dto = CreateReminderDto(title: nil, body: body, frequency: nil, triggerAt: currentTime + 60000)
        
        Task {
            guard let accessToken = await authMan.accessToken() else { return }
            let result = await remindersService.createReminder(dto: dto, accessToken: accessToken)
            
            DispatchQueue.main.async {
                switch result {
                case .success(let reminder):
                    print(reminder)
                case .failure(let apiError):
                    print(apiError.message)
                }
            }
        }
    }
}
