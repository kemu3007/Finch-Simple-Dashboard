//
//  IconButton.swift
//  Finch-Simple-Dashboard
//
//  Created by 市川憲伸 on 2025/04/14.
//

import SwiftUI

struct IconButton: View {
    var iconName: String
    var action: () -> Void = { }

    init(iconName: String, action: @escaping () -> Void) {
        self.iconName = iconName
        self.action = action
    }
    
    var body: some View {
        Button {
            action()
        } label: {
            Image(systemName: iconName)
        }
    }
}

