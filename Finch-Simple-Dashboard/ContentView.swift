//
//  ContentView.swift
//  Finch-Desktop
//
//  Created by 市川憲伸 on 2025/04/11.
//

import SwiftUI
import Foundation

func runCommand(path: String, args: [String]) -> (String, String) {
    let process = Process()
    process.launchPath = path
    process.arguments = args
    let pipe = Pipe()
    let errorPipe = Pipe()
    process.standardOutput = pipe
    process.standardError = errorPipe
    process.launch()
    process.waitUntilExit()
    let msg = String(data: pipe.fileHandleForReading.readDataToEndOfFile(), encoding: .utf8) ?? ""
    let error = String(data: errorPipe.fileHandleForReading.readDataToEndOfFile(), encoding: .utf8) ?? ""
    return (msg, error)
}

func formatResponse(cliResult: (String, String)) -> String {
    var logs = ""
    if (cliResult.0 != "") {
        logs += cliResult.0 + "\n"
    }
    if (cliResult.1 != "") {
        logs += cliResult.1 + "\n"
    }
    return logs
}

struct ContentView: View {
    @AppStorage("finchPath") var finchPath: String = "/usr/local/bin/finch"
    @AppStorage("dockerMode") var dockerMode: Bool = false
    
    @State var displayAlert = false
    @State var searchText = ""
    
    @State var containers: [FinchContainer] = []
    @State var images: [FinchImage] = []
    @State var volumes: [FinchVolume] = []
    @State var logs: String = ""
    
    func getTitle() -> String {
        var title = "Finch Simple Dashboard"
        if dockerMode {
            title += " (Docker Mode)"
        }
        return title
    }

    func refreshComposes(mute: Bool = false) {
        let result = runCommand(path: finchPath, args: ["volume", "ls", "--format", "json"])
        volumes = parseFinchVolumes(from: result.0)
        if !mute {
            logs += finchPath + " volume ls --format json" + "\n"
            logs += formatResponse(cliResult: result)
        }
    }
    
    func refreshContainers(mute: Bool = false) {
        let result = runCommand(path: finchPath, args: ["container", "ls", "-a", "--format", "json"])
        containers = parseFinchContainers(from: result.0)
        if !mute {
            logs += finchPath + " container ls --format json" + "\n"
            logs += formatResponse(cliResult: result)
        }
    }

    func refreshImages(mute: Bool = false) {
        let result = runCommand(path: finchPath, args: ["images", "--format", "json"])
        images = parseFinchImages(from: result.0)
        if !mute {
            logs += finchPath + " images --format json" + "\n"
            logs += formatResponse(cliResult: result)
        }
    }
    
    func refreshVolumes(mute: Bool = false) {
        let result = runCommand(path: finchPath, args: ["volume", "ls", "--format", "json"])
        volumes = parseFinchVolumes(from: result.0)
        if !mute {
            logs += finchPath + " volume ls --format json" + "\n"
            logs += formatResponse(cliResult: result)
        }
    }

    var body: some View {
        VStack {
            HStack {
                Text(getTitle()).font(.title)
                Button {
                    let window = NSWindow(
                        contentRect: NSRect(x: 200, y: 300, width: 500, height: 600),
                        styleMask: [.titled, .closable, .resizable],
                        backing: .buffered,
                        defer: false
                    )
                    window.title = "Configuration"
                    window.contentView = NSHostingView(rootView: ConfigView())
                    window.isReleasedWhenClosed = false
                    window.makeKeyAndOrderFront(nil)
                } label: {
                    Image(systemName: "gearshape")
                }
                Button {
                    refreshContainers(mute: true)
                    refreshImages(mute: true)
                    refreshVolumes(mute: true)
                } label: {
                    Image(systemName: "arrow.trianglehead.clockwise")
                }
                Spacer()
            }
            Divider()
            HStack {
                Text("Containers").font(.headline)
                Button {
                    refreshContainers()
                } label: {
                    Image(systemName: "arrow.trianglehead.clockwise")
                }
            }
            Table (containers.sorted { $0.composeProject > $1.composeProject}) {
                TableColumn("COMPOSE PROJECT") { container in
                    HStack {
                        Text(container.composeProject).textSelection(.enabled)
                        if container.composeProject != "" {
                            if container.status.starts(with: "Up") {
                                Button {
                                    let targets = containers.filter { $0.composeProject == container.composeProject }
                                    for targe in targets {
                                        let result = runCommand(path: finchPath, args: ["stop", targe.containerId])
                                        logs += finchPath + " stop " + targe.containerId + "\n"
                                        logs += formatResponse(cliResult: result)
                                    }
                                    refreshContainers(mute: true)
                                } label: {
                                    Image(systemName: "stop")
                                }
                            } else {
                                Button {
                                    let targets = containers.filter { $0.composeProject == container.composeProject }
                                    for targe in targets {
                                        let result = runCommand(path: finchPath, args: ["start", targe.containerId])
                                        logs += finchPath + " start " + targe.containerId + "\n"
                                        logs += formatResponse(cliResult: result)
                                    }
                                    refreshContainers(mute: true)
                                } label: {
                                    Image(systemName: "play")
                                }
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
                        if container.status == "Up" {
                            Button {
                                let result = runCommand(path: finchPath, args: ["stop", container.containerId])
                                logs += finchPath + " stop " + container.containerId  + "\n"
                                logs += formatResponse(cliResult: result)
                                refreshContainers(mute: true)
                            } label: {
                                Image(systemName: "stop")
                            }
                        } else {
                            Button {
                                let result = runCommand(path: finchPath, args: ["start", container.containerId])
                                logs += finchPath + " start " + container.containerId  + "\n"
                                logs += formatResponse(cliResult: result)
                                refreshContainers(mute: true)
                            } label: {
                                Image(systemName: "play")
                            }
                            Button {
                                let result = runCommand(path: finchPath, args: ["rm", container.containerId])
                                logs += finchPath + " rm " + container.containerId  + "\n"
                                logs += formatResponse(cliResult: result)
                                refreshContainers(mute: true)
                            } label: {
                                Image(systemName: "trash")
                            }
                        }
                        Button {
                            let window = NSWindow(
                                contentRect: NSRect(x: 200, y: 600, width: 1000, height: 600),
                                styleMask: [.titled, .closable, .resizable],
                                backing: .buffered,
                                defer: false
                            )
                            window.title = container.containerId + " logs"
                            window.contentView = NSHostingView(rootView: LogView(containerId: container.containerId))
                            window.isReleasedWhenClosed = false
                            window.makeKeyAndOrderFront(nil)
                        } label: {
                            Image(systemName: "magnifyingglass")
                        }
                    }
                }
            }
            HStack {
                VStack {
                    HStack {
                        Text("Images").font(.headline)
                        Button {
                            refreshImages()
                        } label: {
                            Image(systemName: "arrow.trianglehead.clockwise")
                        }
                    }
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
                                Button {
                                    let result = runCommand(path: finchPath, args: ["run", "-d", image.imageId])
                                    logs += finchPath + " run -d " + image.imageId + "\n"
                                    logs += formatResponse(cliResult: result)
                                    refreshContainers(mute: true)
                                } label: {
                                    Image(systemName: "play")
                                }
                                Button {
                                    let result = runCommand(path: finchPath, args: ["image", "rm", image.imageId])
                                    logs += finchPath + " image rm " + image.imageId + "\n"
                                    logs += formatResponse(cliResult: result)
                                    refreshImages(mute: true)
                                } label: {
                                    Image(systemName: "trash")
                                }
                            }
                        }
                    }
                    VStack {
                        HStack {
                            Text("Volumes").font(.headline)
                            Button {
                                refreshVolumes()
                            } label: {
                                Image(systemName: "arrow.trianglehead.clockwise")
                            }
                        }
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
                                    Button {
                                        let result = runCommand(path: finchPath, args: ["volume", "rm", volume.name])
                                        logs += finchPath + " volume rm " + volume.name + "\n"
                                        logs += formatResponse(cliResult: result)
                                        refreshVolumes(mute: true)
                                    } label: {
                                        Image(systemName: "trash")
                                    }
                                }
                            }
                        }
                    }
                }
                VStack {
                    HStack {
                        Text("Logs").font(.headline)
                        Button {
                            logs = ""
                        } label: {
                            Image(systemName: "trash")
                        }
                    }
                    TextEditor (text: .constant(logs))
                }
            }
        }
        .padding()
        .onAppear {
            displayAlert = false
            let version = runCommand(path: finchPath, args: ["--version"])
            if version.1 != "" {
                displayAlert = true
                logs += finchPath + " --version" + "\n"
                logs += formatResponse(cliResult: version)
                return
            }
            if !dockerMode {
                let vmStatus = runCommand(path: finchPath, args: ["vm", "status"])
                if vmStatus.0 != "Running\n" {
                    displayAlert = true
                    logs += finchPath + " vm status" + "\n"
                    logs += formatResponse(cliResult: vmStatus)
                    return
                }
            }
            refreshContainers(mute: true)
            refreshImages(mute: true)
            refreshVolumes(mute: true)
        }.alert("EXECUTION_ERROR", isPresented: .constant(displayAlert)) {} message: {
            VStack {
                Text("Finch / Docker is not installed or running. Please install finch and start vm.(or install docker and start deamon)")
            }
        }
    }
}

#Preview {
    ContentView()
}
