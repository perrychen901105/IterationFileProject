//
//  FileData.swift
//  IterationFileProject
//
//  Created by chenzhipeng on 2020/8/29.
//  Copyright © 2020 perry. All rights reserved.
//

import Foundation

class FileData {
    var filePath: String?
    var fileSize: UInt64?
    var fileLevel: Int?
    var isDirectory: Bool = false;
    
    func generateData(path: String?, size: UInt64?, level: Int?, isDirectory: Bool?) {
        self.filePath = path ?? ""
        self.fileSize = size ?? 0
        self.fileLevel = level ?? 0
        self.isDirectory = isDirectory ?? false
    }
}
