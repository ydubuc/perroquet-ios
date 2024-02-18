//
//  MainView.swift
//  Perroquet
//
//  Created by Yoan Dubuc on 2/6/24.
//

import SwiftUI

struct MainView: View {
    @StateObject var vm: MainViewModel
    
    init(vm: MainViewModel) {
        _vm = StateObject(wrappedValue: vm)
    }

    var body: some View {
        
        ZStack(alignment: .bottom) {
            
            RemindersView(vm: RemindersViewModel(appVm: vm.appVm))
                .opacity(vm.currentTab == 0 ? 1 : 0)
            
            DiscoverView(vm: DiscoverViewModel(appVm: vm.appVm))
                .opacity(vm.currentTab == 1 ? 1 : 0)
            
            HStack(alignment: .center, spacing: Dims.spacingLarge) {
                
                Button {
                    vm.currentTab = 0
                } label: {
                    Image(systemName: "list.clipboard")
                        .foregroundColor(vm.currentTab == 0 ? vm.appVm.theme.fontBright : vm.appVm.theme.fontDim)
                        .font(.body.weight(.bold))
                }

                Button {
                    vm.currentTab = 1
                } label: {
                    Image(systemName: "safari")
                        .foregroundColor(vm.currentTab == 1 ? vm.appVm.theme.fontBright : vm.appVm.theme.fontDim)
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
    MainView(vm: MainViewModel(appVm: AppViewModel()))
}
