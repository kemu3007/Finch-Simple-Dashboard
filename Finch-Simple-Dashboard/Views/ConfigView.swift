//
//  ConfigView.swift
//  Finch-Desktop
//
//  Created by 市川憲伸 on 2025/04/12.
//

import SwiftUI

struct ConfigView: View {
    @AppStorage("finchPath") var finchPath: String = "/usr/local/bin/finch"
    @AppStorage("lineLimit") var lineLimit: Int = 500
    @AppStorage("dockerMode") var dockerMode: Bool = false
    
    @State var version = ""
    @State var error = ""
    
    func getVersion() {
        let result = runCommand(path: finchPath, args: ["--version"])
        version = result.0
        error = result.1
    }

    var body: some View {
        VStack {
            HStack {
                Text("Finch Path:")
                TextField("", text: $finchPath)
                Button {
                    getVersion()
                } label: {
                    Image(systemName: "arrow.trianglehead.clockwise")
                }
            }
            Text(version)
            Text(error)
            HStack {
                Text("Enable Docker Mode:")
                Toggle("", isOn: $dockerMode)
                Spacer()
            }
        }
        .padding()
    }
}

