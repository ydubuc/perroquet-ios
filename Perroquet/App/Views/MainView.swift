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
                    visibility: nil,
                    sort: "trigger_at,desc",
                    cursor: nil,
                    limit: nil
                )))
            )
            .opacity(vm.currentTab == 0 ? 1 : 0)
            
            DiscoverView(vm: .init(wrappedValue: .init(dto: .init(
                id: nil,
                userId: nil,
                search: nil,
                visibility: 1,
                sort: "trigger_at,desc",
                cursor: nil,
                limit: nil
            ))))
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
                        .background(ClearBackgroundView())
                }

                Button {
                    vm.currentTab = 2
                } label: {
                    Image(systemName: "safari")
                        .foregroundColor(vm.currentTab == 2 ? vm.appVm.theme.fontBright : vm.appVm.theme.fontDim)
                        .font(.body.weight(.bold))
                }
                
            } // HStack
            .padding(Dims.spacingRegular)
            .background(vm.appVm.theme.primaryDark)
            .cornerRadius(Dims.cornerRadius)
            
        } // ZStack
        .background(vm.appVm.theme.primary)
        .onAppear {
            UIApplication.setWindowBackgroundColor(UIColor(vm.appVm.theme.primaryDark))
        }
        .onOpenURL { url in
            print("on open url in main view \(url)")
        }
        
    }
}

#Preview {
    MainView()
}
