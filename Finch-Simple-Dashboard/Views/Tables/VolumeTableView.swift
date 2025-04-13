//
//  VolumeTableView.swift
//  Finch-Simple-Dashboard
//
//  Created by 市川憲伸 on 2025/04/14.
//

import SwiftUI

struct VolumeTableView: View {
    @AppStorage("finchPath") var finchPath: String = "/usr/local/bin/finch"
    @AppStorage("logs") var logs: String = ""

    var volumes: [FinchVolume]
    var refreshAction: () -> Void = { }

    init(volumes: [FinchVolume], refreshAction: @escaping () -> Void) {
        self.volumes = volumes
        self.refreshAction = refreshAction
    }
    
    var body: some View {
        Table(volumes.sorted { $0.name > $1.name} ) {
            TableColumn("Name") { volume in
                Text(volume.name).textSelection(.enabled)
            }
            TableColumn("Size") { volume in
                Text(volume.size).textSelection(.enabled)
            }
            TableColumn("MoundPoint") { volume in
                Text(volume.mountpoint).textSelection(.enabled)
            }
            TableColumn("ACTIONS") { volume in
                HStack {
                    IconButton(iconName: "trash", action: {
                        let result = runCommand(path: finchPath, args: ["volume", "rm", volume.name])
                        logs += finchPath + " volume rm " + volume.name + "\n"
                        logs += formatResponse(cliResult: result)
                        refreshAction()
                    })
                    IconButton(iconName: "book.pages", action: {
                        let window = NSWindow(
                            contentRect: NSRect(x: 200, y: 600, width: 1000, height: 600),
                            styleMask: [.titled, .closable, .resizable],
                            backing: .buffered,
                            defer: false
                        )
                        window.title = volume.name + " inspect"
                        window.contentView = NSHostingView(rootView: InspectView(targetId: volume.name))
                        window.isReleasedWhenClosed = false
                        window.makeKeyAndOrderFront(nil)
                    })
                }
            }.width(min: 100)
        }

    }
}

