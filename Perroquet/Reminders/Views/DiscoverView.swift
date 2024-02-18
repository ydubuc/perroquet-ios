//
//  DiscoverView.swift
//  Perroquet
//
//  Created by Yoan Dubuc on 2/17/24.
//

import SwiftUI

struct DiscoverView: View {
    @StateObject var vm: DiscoverViewModel
    
    init(vm: DiscoverViewModel) {
        _vm = StateObject(wrappedValue: vm)
    }
    
    var body: some View {
        
        ScrollView(.vertical, showsIndicators: true) {
            
            LazyVStack(alignment: .leading, spacing: 0) {
                
                Text("Discover View")
                
            }

        }
        
    }
}

#Preview {
    DiscoverView(vm: DiscoverViewModel(appVm: AppViewModel()))
}
