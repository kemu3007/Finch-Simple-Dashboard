//
//  ImageTableView.swift
//  Finch-Simple-Dashboard
//
//  Created by 市川憲伸 on 2025/04/14.
//

import SwiftUI

struct ImageTableView: View {
    @AppStorage("finchPath") var finchPath: String = "/usr/local/bin/finch"
    @AppStorage("logs") var logs: String = ""

    var images: [FinchImage]
    var refreshAction: () -> Void = { }

    init(images: [FinchImage], refreshAction: @escaping () -> Void) {
        self.images = images
        self.refreshAction = refreshAction
    }
    
    var body: some View {
        Table(images.sorted { $0.name > $1.name }) {
            TableColumn("ID") { image in
                Text(image.imageId).textSelection(.enabled)
            }
            TableColumn("Name") { image in
                Text(image.name).textSelection(.enabled)
            }
            TableColumn("Tag") { image in
                Text(image.tag).textSelection(.enabled)
            }
            TableColumn("Size") { image in
                Text(image.size).textSelection(.enabled)
            }
            TableColumn("Platform") { image in
                Text(image.platform).textSelection(.enabled)
            }
            TableColumn("ACTIONS") { image in
                HStack {
                    IconButton(iconName: "play", action: {
                        let result = runCommand(path: finchPath, args: ["run", "-d", image.imageId])
                        logs += finchPath + " run -d " + image.imageId + "\n"
                        logs += formatResponse(cliResult: result)
                        refreshAction()
                    })
                    IconButton(iconName: "trash", action: {
                        let result = runCommand(path: finchPath, args: ["image", "rm", image.imageId])
                        logs += finchPath + " image rm " + image.imageId + "\n"
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
                        window.title = image.name + " inspect"
                        window.contentView = NSHostingView(rootView: InspectView(targetId: image.imageId))
                        window.isReleasedWhenClosed = false
                        window.makeKeyAndOrderFront(nil)
                    })
                }
            }.width(min: 100)
        }
    }
}

