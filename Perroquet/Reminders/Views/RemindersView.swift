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
                
                Text("Reminders View")
                
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
    RemindersView(vm: RemindersViewModel(appVm: AppViewModel()))
}
