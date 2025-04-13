//
//  ContainerTableView.swift
//  Finch-Simple-Dashboard
//
//  Created by 市川憲伸 on 2025/04/14.
//

import SwiftUI

struct ContainerTableView: View {
    @AppStorage("finchPath") var finchPath: String = "/usr/local/bin/finch"
    @AppStorage("logs") var logs: String = ""
    
    @State var serchText: String = ""
    
    var containers: [FinchContainer]
    var refreshAction: () -> Void = { }
    
    init(containers: [FinchContainer], refreshAction: @escaping () -> Void) {
        self.containers = containers
        self.refreshAction = refreshAction
    }
    
    var body: some View {
        Table (containers.sorted { $0.composeProject > $1.composeProject}) {
            TableColumn("COMPOSE PROJECT") { container in
                HStack {
                    Text(container.composeProject).textSelection(.enabled)
                    if container.composeProject != "" {
                        if container.status.starts(with: "Up") {
                            IconButton(iconName: "stop", action: {
                                let targets = containers.filter { $0.composeProject == container.composeProject }
                                for target in targets {
                                    let result = runCommand(path: finchPath, args: ["stop", target.containerId])
                                    logs += finchPath + " stop " + target.containerId + "\n"
                                    logs += formatResponse(cliResult: result)
                                }
                                refreshAction()
                            })
                        } else {
                            IconButton(iconName: "play", action: {
                                let targets = containers.filter { $0.composeProject == container.composeProject }
                                for targe in targets {
                                    let result = runCommand(path: finchPath, args: ["start", targe.containerId])
                                    logs += finchPath + " start " + targe.containerId + "\n"
                                    logs += formatResponse(cliResult: result)
                                }
                                refreshAction()
                            })
                        }
                    }
                }
            }
            TableColumn("CONTAINER ID") { container in
                Text(container.containerId).textSelection(.enabled)
            }
            TableColumn("IMAGE") { container in
                Text(container.image).textSelection(.enabled)
            }
            TableColumn("COMMAND") { container in
                Text(container.command).textSelection(.enabled)
            }
            TableColumn("CREATED") { container in
                Text(container.created).textSelection(.enabled)
            }
            TableColumn("STATUS") { container in
                Text(container.status).textSelection(.enabled)
            }
            TableColumn("PORTS") { container in
                Text(container.ports).textSelection(.enabled)
            }
            TableColumn("NAMES") { container in
                Text(container.names).textSelection(.enabled)
            }
            TableColumn("ACTIONS") { container in
                HStack {
                    if container.status.starts(with: "Up") {
                        IconButton(iconName: "stop", action: {
                            let result = runCommand(path: finchPath, args: ["stop", container.containerId])
                            logs += finchPath + " stop " + container.containerId  + "\n"
                            logs += formatResponse(cliResult: result)
                            refreshAction()
                        })
                    } else {
                        IconButton(iconName: "play", action: {
                            let result = runCommand(path: finchPath, args: ["start", container.containerId])
                            logs += finchPath + " start " + container.containerId  + "\n"
                            logs += formatResponse(cliResult: result)
                            refreshAction()
                        })
                        IconButton(iconName: "trash", action: {
                            let result = runCommand(path: finchPath, args: ["rm", container.containerId])
                            logs += finchPath + " rm " + container.containerId  + "\n"
                            logs += formatResponse(cliResult: result)
                            refreshAction()
                        })
                    }
                    IconButton(iconName: "magnifyingglass", action: {
                        let window = NSWindow(
                            contentRect: NSRect(x: 200, y: 600, width: 1000, height: 600),
                            styleMask: [.titled, .closable, .resizable],
                            backing: .buffered,
                            defer: false
                        )
                        window.title = container.containerId + " logs"
                        window.contentView = NSHostingView(rootView: ContainerLogView(containerId: container.containerId))
                        window.isReleasedWhenClosed = false
                        window.makeKeyAndOrderFront(nil)
                    })
                    IconButton(iconName: "book.pages", action: {
                        let window = NSWindow(
                            contentRect: NSRect(x: 200, y: 600, width: 1000, height: 600),
                            styleMask: [.titled, .closable, .resizable],
                            backing: .buffered,
                            defer: false
                        )
                        window.title = container.containerId + " inspect"
                        window.contentView = NSHostingView(rootView: InspectView(targetId: container.containerId))
                        window.isReleasedWhenClosed = false
                        window.makeKeyAndOrderFront(nil)
                    })
                }
            }.width(min: 100)
        }
    }
}
