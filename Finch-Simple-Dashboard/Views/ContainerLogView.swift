//
//  LogView.swift
//  Finch-Desktop
//
//  Created by 市川憲伸 on 2025/04/12.
//

import SwiftUI

struct ContainerLogView: View {
    let containerId: String
    @State var logs: String = ""
    @AppStorage("finchPath") var finchPath: String = "/usr/local/bin/finch"
    @AppStorage("lineLimit") var lineLimit: Int = 500

    init(containerId: String, logs: String = "") {
        self.containerId = containerId
    }

    func refreshLog() {
        let result = runCommand(path: finchPath, args: ["logs", "--tail", "\(lineLimit)", containerId, "-t"])
        self.logs = result.0.isEmpty ? result.1 : result.0
    }

    var body: some View {
        VStack {
            HStack {
                Text("Line Limit:")
                TextField("", value: $lineLimit, formatter: NumberFormatter())
                Spacer()
                Button {
                    refreshLog()
                } label: {
                    Image(systemName: "arrow.trianglehead.clockwise")
                }
            }
            TextEditor(text: .constant(logs))
        }
        .padding()
        .onAppear() {
            refreshLog()
        }
    }
}

