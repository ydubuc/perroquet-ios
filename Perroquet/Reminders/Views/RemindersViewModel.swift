//
//  RemindersViewModel.swift
//  Perroquet
//
//  Created by Yoan Dubuc on 2/17/24.
//

import Foundation

class RemindersViewModel: ObservableObject {
    @Published private(set) var appVm: AppViewModel
    
    @Published var reminders: [Reminder] = []
    
    @Published var userId: String?
    @Published var search: String?
    @Published var sort: String?
    @Published var cursor: String?
    @Published var limit: Int?
    
    @Published var errorMessage: String = ""
    
    let remindersService: RemindersService
    
    init(
        appVm: AppViewModel,
        reminders: [Reminder],
        dto: GetRemindersFilterDto,
        remindersService: RemindersService = RemindersService(url: Config.BACKEND_URL)
    ) {
        self.appVm = appVm
        
        self.reminders = reminders
        
        self.userId = dto.userId
        self.search = dto.search
        self.sort = dto.sort
        self.cursor = dto.cursor
        self.limit = dto.limit
        
        self.remindersService = remindersService
        
        self.load()
    }
    
    func load() {
        Task {
            guard let accessToken = await appVm.accessToken() else { return }
            let dto = GetRemindersFilterDto(id: nil, userId: userId, search: search, sort: sort, cursor: cursor, limit: limit)
            let result = await remindersService.getReminders(dto: dto, accessToken: accessToken)
            
            DispatchQueue.main.async {
                switch result {
                case .success(let reminders):
                    self.reminders = reminders
                case .failure(let apiError):
                    print(apiError.localizedDescription)
                    self.errorMessage = apiError.message
                }
            }
        }
    }
    
}
