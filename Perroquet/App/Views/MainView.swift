//
//  MainView.swift
//  Perroquet
//
//  Created by Yoan Dubuc on 2/6/24.
//

import SwiftUI

struct MainView: View {
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    @StateObject var vm: MainViewModel
    
    init(vm: StateObject<MainViewModel> = .init(wrappedValue: .init())) {
        _vm = vm
    }

    var body: some View {
        
        ZStack(alignment: .center) {
            
            LazyView(loadWhen: $vm.shouldLoadRemindersView) {
                RemindersView(
                    vm: .init(wrappedValue: .init(
                        reminders: vm.stash.getReminders(),
                        dto: .init(
                            id: nil,
                            userId: vm.authMan.accessTokenClaims?.id,
                            search: nil,
                            tags: nil,
                            visibility: nil,
                            sort: "trigger_at,desc",
                            cursor: nil,
                            limit: nil
                        )
                    ))
                )
            }
            .opacity(vm.currentTab == 0 ? 1 : 0)
            
            LazyView(loadWhen: $vm.shouldLoadDiscoverView) {
                DiscoverView(vm: .init(wrappedValue: .init(dto: .init(
                    id: nil,
                    userId: nil,
                    search: nil,
                    tags: nil,
                    visibility: 1,
                    sort: "trigger_at,asc",
                    cursor: "\(Date().timeIntervalSince1970.milliseconds),\(UUID().uuidString)",
                    limit: nil
                ))))
            }
            .opacity(vm.currentTab == 1 ? 1 : 0)
            
            LazyView(loadWhen: $vm.shouldLoadRemindersView) {
                Text("requests")
            }
            .opacity(vm.currentTab == 3 ? 1 : 0)
            
            LazyView(loadWhen: $vm.shouldLoadProfileView) {
                ProfileView()
            }
            .opacity(vm.currentTab == 4 ? 1 : 0)
            
            VStack(alignment: .center, spacing: 0) {
                
                vm.appVm.theme.primary
                    .frame(height: safeAreaInsets.top)
                    .ignoresSafeArea()

                Spacer()
                
                HStack(alignment: .center, spacing: 0) {
                    
                    Button {
                        vm.switchToTab(0)
                    } label: {
                        Image(systemName: "list.bullet.circle")
                            .foregroundColor(vm.currentTab == 0 ? vm.appVm.theme.fontBright : vm.appVm.theme.fontNormal)
                            .font(.body.weight(.bold))
                            .dynamicTypeSize(.xSmall ... .accessibility1)
                            .padding(Dims.spacingRegular)
                    }
                    
                    Button {
                        vm.switchToTab(1)
                    } label: {
                        Image(systemName: "safari")
                            .foregroundColor(vm.currentTab == 1 ? vm.appVm.theme.fontBright : vm.appVm.theme.fontNormal)
                            .font(.body.weight(.bold))
                            .dynamicTypeSize(.xSmall ... .accessibility1)
                            .padding(Dims.spacingRegular)
                    }
                    
                    Button {
                        vm.isPresentingCreateReminderView = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(vm.currentTab == 2 ? vm.appVm.theme.fontBright : vm.appVm.theme.fontNormal)
                            .font(.body.weight(.bold))
                            .dynamicTypeSize(.xSmall ... .accessibility1)
                            .padding(Dims.spacingRegular)
                    }
                    .sheet(isPresented: $vm.isPresentingCreateReminderView) {
                        CreateReminderView()
                            .background(ClearBackgroundView())
                    }
                    
                    Button {
                        vm.switchToTab(3)
                    } label: {
                        Image(systemName: "at.circle")
                            .foregroundColor(vm.currentTab == 3 ? vm.appVm.theme.fontBright : vm.appVm.theme.fontNormal)
                            .font(.body.weight(.bold))
                            .dynamicTypeSize(.xSmall ... .accessibility1)
                            .padding(Dims.spacingRegular)
                    }
                    
                    Button {
                        vm.switchToTab(4)
                    } label: {
                        Image(systemName: "person.crop.circle")
                            .foregroundColor(vm.currentTab == 4 ? vm.appVm.theme.fontBright : vm.appVm.theme.fontNormal)
                            .font(.body.weight(.bold))
                            .dynamicTypeSize(.xSmall ... .accessibility1)
                            .padding(Dims.spacingRegular)
                    }
                    
                } // HStack
                .background(vm.appVm.theme.primaryLight)
                .cornerRadius(Dims.cornerRadius)
                
            }
                        
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
