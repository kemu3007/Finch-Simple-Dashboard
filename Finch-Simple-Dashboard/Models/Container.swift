//
//  Container.swift
//  Finch-Desktop
//
//  Created by 市川憲伸 on 2025/04/12.
//

import Foundation

// SAMPLE
/*
 {"Command":"\"/docker-entrypoint.…\"","CreatedAt":"2025-04-11T17:14:21.496755142Z","ID":"250762bf59eb","Image":"docker.io/library/nginx:latest","Platform":"linux/arm64/v8","Names":"test-nginx_1-1","Ports":"0.0.0.0:80->80/tcp","Status":"Up","Runtime":"io.containerd.runc.v2","Size":"","Labels":"nerdctl/namespace=finch,com.docker.compose.service=nginx_1,nerdctl/extraHosts=[],maintainer=NGINX Docker Maintainers <docker-maint@nginx.com>,io.containerd.image.config.stop-signal=SIGQUIT,nerdctl/ports=[{\"HostPort\":80,\"ContainerPort\":80,\"Protocol\":\"tcp\",\"HostIP\":\"0.0.0.0\"}],nerdctl/hostname=nginx_1,nerdctl/networks=[\"test_default\"],nerdctl/platform=linux/arm64/v8,nerdctl/state-dir=/var/lib/nerdctl/1935db59/containers/finch/250762bf59ebcffbd33f58421130e43a6adeaf6ea4b59b50185498fdc28571c4,com.docker.compose.project=test,nerdctl/ipc={\"mode\":\"private\"},nerdctl/log-uri=binary:///usr/local/bin/nerdctl?_NERDCTL_INTERNAL_LOGGING=%2Fvar%2Flib%2Fnerdctl%2F1935db59,nerdctl/name=test-nginx_1-1,nerdctl/auto-remove=false"}
 */

struct FinchContainer: Identifiable {
    var id = UUID()
    
    let composeProject: String
    let containerId: String
    let image: String
    let command: String
    let created: String
    let status: String
    let ports: String
    let names: String
}

func extractComposeProject(from labels: String) -> String {
    // 正規表現で "com.docker.compose.project=xxx" を抽出
    let pattern = #"com\.docker\.compose\.project=([\w\-]+)"#
    if let regex = try? NSRegularExpression(pattern: pattern) {
        let range = NSRange(labels.startIndex..<labels.endIndex, in: labels)
        if let match = regex.firstMatch(in: labels, options: [], range: range) {
            if let projectRange = Range(match.range(at: 1), in: labels) {
                return String(labels[projectRange])
            }
        }
    }
    return ""
}

func parseFinchContainers(from jsonString: String) -> [FinchContainer] {
    var processes: [FinchContainer] = []
    for jsonString in jsonString.split(separator: "\n"){
        guard let jsonData = jsonString.data(using: .utf8) else {
            continue
        }
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: jsonData, options: [])
            guard let jsonDict = jsonObject as? [String: Any] else { continue }
            let process = FinchContainer(
                composeProject: extractComposeProject(from: jsonDict["Labels"] as? String ?? ""),
                containerId: jsonDict["ID"] as? String ?? "",
                image: jsonDict["Image"] as? String ?? "",
                command: jsonDict["Command"] as? String ?? "",
                created: jsonDict["CreatedAt"] as? String ?? "",
                status: jsonDict["Status"] as? String ?? "",
                ports: jsonDict["Ports"] as? String ?? "",
                names: jsonDict["Names"] as? String ?? ""
            )
            processes.append(process)
        } catch {
            continue
        }
    }
    return processes
}
