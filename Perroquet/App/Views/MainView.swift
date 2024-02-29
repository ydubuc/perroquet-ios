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
            
            LazyView(loadWhen: $vm.shouldLoadRemindersView) {
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
            }
            .opacity(vm.currentTab == 0 ? 1 : 0)
            
            LazyView(loadWhen: $vm.shouldLoadDiscoverView) {
                DiscoverView(vm: .init(wrappedValue: .init(dto: .init(
                    id: nil,
                    userId: nil,
                    search: nil,
                    visibility: 1,
                    sort: "trigger_at,desc",
                    cursor: nil,
                    limit: nil
                ))))
            }
            .opacity(vm.currentTab == 2 ? 1 : 0)
            
            HStack(alignment: .center, spacing: Dims.spacingRegular * 3) {
                
                Button {
                    vm.switchToTab(0)
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
                    vm.switchToTab(2)
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
            if url.scheme == "widget" && url.host == "com.beamcove.perroquet.create-reminder" {
                vm.isPresentingCreateReminderView = true
            }
        }
        
    }
}

#Preview {
    MainView()
}
