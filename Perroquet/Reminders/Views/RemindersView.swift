//
//  RemindersView.swift
//  Perroquet
//
//  Created by Yoan Dubuc on 2/17/24.
//

import SwiftUI

struct RemindersView: View {
    @StateObject var vm: RemindersViewModel
    
    init(vm: RemindersViewModel) {
        _vm = StateObject(wrappedValue: vm)
    }
    
    var body: some View {
        
        ScrollView(.vertical, showsIndicators: true) {
            
            LazyVStack(alignment: .leading, spacing: 0) {
                
                ForEach(vm.reminders) { reminder in
                    ReminderComponent(reminder: reminder, theme: vm.appVm.theme)
                }
                
                Button(action: {
                    vm.appVm.onSignout()
                }, label: {
                    Text("Logout")
                })
                
            }

        }
        
    }
}

#Preview {
    RemindersView(
        vm: RemindersViewModel(
            appVm: AppViewModel(),
            reminders: [],
            dto: GetRemindersFilterDto(id: nil, userId: nil, search: nil, sort: nil, cursor: nil, limit: nil)
        )
    )
}
