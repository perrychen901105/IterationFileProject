//
//  ViewController.swift
//  IterationFileProject
//
//  Created by chenzhipeng on 2020/8/29.
//  Copyright © 2020 perry. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var filepathTextField: UITextField!
    @IBOutlet weak var pathsTextView: UITextView!
    
//    For testing, create folder in advance, that can access in Files App.
    func createFolder() {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        let docURL = URL(string: documentsDirectory)!
        let dataPath = docURL.appendingPathComponent("MyFolder")
        if !FileManager.default.fileExists(atPath: dataPath.absoluteString) {
            do {
                try FileManager.default.createDirectory(atPath: dataPath.absoluteString, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print(error.localizedDescription);
            }
        }
    }
    
    @IBAction func createFileFolder(_ sender: UIButton) {
        createFolder();
    }
    
//    check if path is file or dir
    internal func fileIsDir(fileURL: NSURL) -> Bool {
        var isDir: ObjCBool = false;
        FileManager.default.fileExists(atPath: fileURL.path!, isDirectory: &isDir)
        return isDir.boolValue
    }
    
    func fileSize(fromPath path: String) -> UInt64? {
        guard let size = try? FileManager.default.attributesOfItem(atPath: path)[FileAttributeKey.size],
            let fileSize = size as? UInt64 else {
            return nil
        }
        return fileSize;
    }
    
    func makeFileSizeReadable(fileSize: UInt64) -> String {
        // bytes
        if fileSize < 1023 {
            return String(format: "%lu bytes", CUnsignedLong(fileSize))
        }
        // KB
        var floatSize = Float(fileSize / 1024)
        if floatSize < 1023 {
            return String(format: "%.1f KB", floatSize)
        }
        // MB
        floatSize = floatSize / 1024
        if floatSize < 1023 {
            return String(format: "%.1f MB", floatSize)
        }
        // GB
        floatSize = floatSize / 1024
        return String(format: "%.1f GB", floatSize)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    func getFilesInDirectory(path: URL, size: inout UInt64) {
        if fileIsDir(fileURL: path as NSURL) {
            do {
                let subContent = try FileManager.default.contentsOfDirectory(at: path, includingPropertiesForKeys: nil)
                for subFile in subContent {
                    getFilesInDirectory(path: subFile, size: &size);
                }
            } catch {
                print(error)
            }
        } else {
            size += self.fileSize(fromPath: path.path) ?? 0
        }
    }
    
    @IBAction func getAllFilePath(_ sender: UIButton) {
        self.pathsTextView.text = ""
        let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let folderPath = documentsUrl.appendingPathComponent(filepathTextField.text!);
        var findFolder: ObjCBool = false;
        // check if folder is exist
        if !FileManager.default.fileExists(atPath: folderPath.path, isDirectory: &findFolder) {
            let alertController = UIAlertController(title: "Warning", message:
                "Folder does not exist", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))
            self.present(alertController, animated: true, completion: nil)
            return;
        }
        var fileArray = [FileData]()
        do {
            let directoryContents = try FileManager.default.contentsOfDirectory(at: folderPath, includingPropertiesForKeys: nil)
            
            for fileInDir in directoryContents {
                let fileData = FileData();
                // file size
                var fileTotalSize: UInt64 = 0;
                var isDir: Bool = false;
                if fileIsDir(fileURL: fileInDir as NSURL) {
                    getFilesInDirectory(path: fileInDir, size: &fileTotalSize);
                    isDir = true
                } else {
                    fileTotalSize = self.fileSize(fromPath: fileInDir.path) ?? 0
                }
//                generate file data
                let fileName = FileManager.default.displayName(atPath: fileInDir.path);
                fileData.generateData(path: fileName, size: fileTotalSize, level: 0, isDirectory: isDir);
                fileArray.append(fileData)
            }
//            print file paths
            var filesString: String = ""
            for singleFile in fileArray {
                var fileString = singleFile.isDirectory ? "DIR " : "FILE "
                fileString += singleFile.filePath ?? ""
                fileString += " ";
                fileString += self.makeFileSizeReadable(fileSize: singleFile.fileSize!)
                print(fileString)
                filesString += "\n"
                filesString += fileString
            }
            self.pathsTextView.text = filesString
        } catch {
            print(error)
        }
   
    }

}

