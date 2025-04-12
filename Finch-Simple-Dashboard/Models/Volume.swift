//
//  Volume.swift
//  Finch-Desktop
//
//  Created by 市川憲伸 on 2025/04/12.
//

import Foundation

// SAMPLE
/*
 {"Driver":"local","Labels":"","Mountpoint":"/var/lib/nerdctl/1935db59/volumes/finch/test/_data","Name":"test","Scope":"local","Size":""}
 */

struct FinchVolume: Identifiable {
    var id = UUID()
    let name: String
    let size: String
    let mountpoint: String
}

func parseFinchVolumes(from jsonString: String) -> [FinchVolume] {
    var volumes: [FinchVolume] = []
    for jsonString in jsonString.split(separator: "\n"){
        guard let jsonData = jsonString.data(using: .utf8) else {
            continue
        }
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: jsonData, options: [])
            guard let jsonDict = jsonObject as? [String: Any] else { continue }
            let volume = FinchVolume(
                name: jsonDict["Name"] as? String ?? "",
                size: jsonDict["Size"] as? String ?? "",
                mountpoint: jsonDict["Mountpoint"] as? String ?? ""
            )
            volumes.append(volume)
        }
        catch {
            continue
        }
    }
    return volumes
}
