//
//  InspectView.swift
//  Finch-Simple-Dashboard
//
//  Created by 市川憲伸 on 2025/04/14.
//

import SwiftUI

struct InspectView: View {
    @AppStorage("finchPath") var finchPath: String = "/usr/local/bin/finch"
    
    @State var inspectResult: String = ""
    let targetId: String
    
    init(targetId: String) {
        self.targetId = targetId
    }
    
    func inspect() {
        let result = runCommand(path: finchPath, args: ["inspect", targetId])
        self.inspectResult = result.0.isEmpty ? result.1 : result.0
    }
    
    var body: some View {
        VStack {
            TextEditor(text: .constant(inspectResult))
        }
        .padding()
        .onAppear() {
            inspect()
        }
    }
}

