//
//  Image.swift
//  Finch-Desktop
//
//  Created by 市川憲伸 on 2025/04/12.
//

import Foundation

// SAMPLE
/*
 {"CreatedAt":"2025-04-12 00:33:33 +0900 JST","CreatedSince":"About an hour ago","Digest":"sha256:09369da6b10306312cd908661320086bf87fbae1b6b0c49a1f50ba531fef2eab","ID":"09369da6b103","Repository":"nginx","Tag":"latest","Name":"docker.io/library/nginx:latest","Size":"211.9MB","BlobSize":"68.65MB","Platform":"linux/arm64"}
 */

struct FinchImage: Identifiable {
    var id = UUID()
    let imageId: String
    let name: String
    let tag: String
    let platform: String
    let created: String
    let size: String
}

func parseFinchImages(from jsonString: String) -> [FinchImage] {
    var images: [FinchImage] = []
    for jsonString in jsonString.split(separator: "\n"){
        guard let jsonData = jsonString.data(using: .utf8) else {
            continue
        }
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: jsonData, options: [])
            guard let jsonDict = jsonObject as? [String: Any] else { continue }
            let image = FinchImage(
                imageId: jsonDict["ID"] as? String ?? "",
                name: jsonDict["Name"] as? String ?? (jsonDict["Repository"] as? String ?? ""),
                tag: jsonDict["Tag"] as? String ?? "",
                platform: jsonDict["Platform"] as? String ?? "",
                created: jsonDict["CreatedAt"] as? String ?? "",
                size: jsonDict["Size"] as? String ?? ""
            )
            images.append(image)
        }
        catch {
            continue
        }
    }
    return images
}
