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
    
    let outputPipe = Pipe()
    let errorPipe = Pipe()
    process.standardOutput = outputPipe
    process.standardError = errorPipe
    
    let outputHandle = outputPipe.fileHandleForReading
    let errorHandle = errorPipe.fileHandleForReading
    
    var output = ""
    var errorOutput = ""
    
    // 非同期で読み取る
    outputHandle.readabilityHandler = { handle in
        if let line = String(data: handle.availableData, encoding: .utf8) {
            output += line
        }
    }
    errorHandle.readabilityHandler = { handle in
        if let line = String(data: handle.availableData, encoding: .utf8) {
            errorOutput += line
        }
    }
    
    process.launch()
    process.waitUntilExit()
    
    // ハンドラを解除する
    outputHandle.readabilityHandler = nil
    errorHandle.readabilityHandler = nil
    
    return (output, errorOutput)
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
    @AppStorage("logs") var logs: String = ""
    
    @State var displayAlert = false
    
    @State var containers: [FinchContainer] = []
    @State var images: [FinchImage] = []
    @State var volumes: [FinchVolume] = []
    
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
                IconButton(iconName: "gearshape", action: {
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
                })
                IconButton(iconName: "arrow.trianglehead.clockwise", action: {
                    refreshContainers(mute: true)
                    refreshImages(mute: true)
                    refreshVolumes(mute: true)
                })
                Spacer()
            }
            Divider()
            HStack {
                Text("Running Containers").font(.headline)
                IconButton(iconName: "arrow.trianglehead.clockwise", action: { refreshContainers() })
            }
            ContainerTableView(containers: containers.filter { $0.status.starts(with: "Up") }, refreshAction: { refreshContainers(mute: true) }).frame(height: 120)
            
            HStack {
                Text("Containers").font(.headline)
                IconButton(iconName: "arrow.trianglehead.clockwise", action: { refreshContainers() })
            }
            ContainerTableView(containers: containers, refreshAction: { refreshContainers(mute: true) })
            HStack {
                VStack {
                    HStack {
                        Text("Images").font(.headline)
                        IconButton(iconName: "arrow.trianglehead.clockwise", action: { refreshImages() })
                    }
                    ImageTableView(images: images, refreshAction: { refreshImages(mute: true) })
                    VStack {
                        HStack {
                            Text("Volumes").font(.headline)
                            IconButton(iconName: "arrow.trianglehead.clockwise", action: { refreshVolumes() })
                        }
                        VolumeTableView(volumes: volumes, refreshAction: { refreshVolumes(mute: true) })
                    }
                }
                VStack {
                    HStack {
                        Text("Logs").font(.headline)
                        IconButton(iconName: "trash", action: { logs = "" })
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
