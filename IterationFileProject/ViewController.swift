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
    
    internal func fileIsDir(fileURL: NSURL) -> Bool {
        var isDir: ObjCBool = false;
        FileManager.default.fileExists(atPath: fileURL.path!, isDirectory: &isDir)
        return isDir.boolValue
    }
    
    func fileSize(fromPath path: String) -> String? {
        guard let size = try? FileManager.default.attributesOfItem(atPath: path)[FileAttributeKey.size],
            let fileSize = size as? UInt64 else {
            return nil
        }

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    func getFilesInDirectory(path: URL) {
        if fileIsDir(fileURL: path as NSURL) {
            
        } else {
            
        }
    }
    
    @IBAction func getAllFilePath(_ sender: UIButton) {
        if filepathTextField.text?.count ?? 0 > 0 {
            print("%@", filepathTextField.text ?? "");
            let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let fileData = FileData();
            do {
                // Get the directory contents urls (including subfolders urls)
                let directoryContents = try FileManager.default.contentsOfDirectory(at: documentsUrl, includingPropertiesForKeys: nil)
                
                for filep in directoryContents {
                    if fileIsDir(fileURL: filep as NSURL) {
                        getFilesInDirectory(path: filep);
                        print("file directory")
                    } else {
                        print("file path")
                    }
                }
                print(directoryContents)
                
                // if you want to filter the directory contents you can do like this:
//                let mp3Files = directoryContents.filter{ $0.pathExtension == "mp3" }
//                print("mp3 urls:",mp3Files)
//                let mp3FileNames = mp3Files.map{ $0.deletingPathExtension().lastPathComponent }
//                print("mp3 list:", mp3FileNames)

            } catch {
                print(error)
            }
        } else {
            // alert user has not input the file path
        }
    }
    

}

