//
//  MainView.swift
//  Perroquet
//
//  Created by Yoan Dubuc on 2/6/24.
//

import SwiftUI

struct MainView: View {
    @StateObject var vm: MainViewModel
    
    init(vm: StateObject<MainViewModel> = .init(wrappedValue: .init())) {
        _vm = vm
    }

    var body: some View {
        
        ZStack(alignment: .bottom) {
            
            RemindersView(
                vm: .init(wrappedValue: .init(dto: .init(
                    id: nil,
                    userId: vm.authMan.accessTokenClaims?.id,
                    search: nil,
                    sort: "trigger_at,desc",
                    cursor: nil,
                    limit: nil
                )))
            )
            .opacity(vm.currentTab == 0 ? 1 : 0)
            
            DiscoverView()
                .opacity(vm.currentTab == 2 ? 1 : 0)
            
            HStack(alignment: .center, spacing: Dims.spacingRegular * 3) {
                
                Button {
                    vm.currentTab = 0
                } label: {
                    Image(systemName: "list.bullet.rectangle.portrait")
                        .foregroundColor(vm.currentTab == 0 ? vm.appVm.theme.fontBright : vm.appVm.theme.fontDim)
                        .font(.body.weight(.bold))
                }
                
                Button {
                    vm.isPresentingCreateReminderView = true
                } label: {
                    Image(systemName: "plus.square")
                        .foregroundColor(vm.currentTab == 1 ? vm.appVm.theme.fontBright : vm.appVm.theme.fontDim)
                        .font(.body.weight(.bold))
                }
                .sheet(isPresented: $vm.isPresentingCreateReminderView) {
                    CreateReminderView()
                        .presentationDetents([.medium])
                }

                Button {
                    vm.currentTab = 2
                } label: {
                    Image(systemName: "safari")
                        .foregroundColor(vm.currentTab == 2 ? vm.appVm.theme.fontBright : vm.appVm.theme.fontDim)
                        .font(.body.weight(.bold))
                }
                
            }
            .padding(Dims.spacingRegular)
            .background(vm.appVm.theme.primaryDark)
            .cornerRadius(Dims.cornerRadius)
            
        }
        .background(vm.appVm.theme.primary)
        
    }
}

#Preview {
    MainView()
}
