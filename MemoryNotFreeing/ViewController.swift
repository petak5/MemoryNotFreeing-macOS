//
//  ViewController.swift
//  MemoryNotFreeing
//
//  Created by Peter Urgoš on 23/05/2021.
//

import Cocoa
import AVFoundation

class ViewController: NSViewController {

    @IBAction func openFiles(_ sender: Any?) {
        let dialog = NSOpenPanel();
        dialog.showsResizeIndicator    = true;
        dialog.showsHiddenFiles        = false;
        dialog.canChooseFiles          = true;
        dialog.canChooseDirectories    = true;
        dialog.allowsMultipleSelection = true;

        var paths = [String]()
        
        if (dialog.runModal() != NSApplication.ModalResponse.OK) {
            return
        }
        
        // Collect all file paths from selected urls
        let urls = dialog.urls
        
        for url in urls {
            // Add all files from subdirectories (recursively)
            if let enumerator = FileManager.default.enumerator(at: url, includingPropertiesForKeys: [.isRegularFileKey], options: [.skipsHiddenFiles, .skipsPackageDescendants]) {
                for case let fileURL as URL in enumerator {
                    do {
                        let fileAttributes = try fileURL.resourceValues(forKeys:[.isRegularFileKey])
                        if fileAttributes.isRegularFile! {
                            paths.append(fileURL.path)
                        }
                    } catch {
                        print(error, fileURL)
                    }
                }
            }
        }
        
        // Now we have all file paths
        for path in paths {
            let fileUrl = URL(fileURLWithPath: path)
            let asset = AVAsset(url: fileUrl) as AVAsset
            
            // MARK: - This causes the issue
//            if asset.metadata.count > 0 {
//                // Do nothing
//            }
            
            // MARK: - This too
//            for metadataItem in asset.metadata {
//                // Do nothing
//            }
            
            // MARK: - This is completely fine, it runs longer than code without it but it doesn't consume so much memory as options above.
            // MARK:   So the problem must be connected to 'metadata' attribure of 'asset'
//            if asset.duration.seconds > 0 {
//                // Do nothing
//            }
        }
    }

}

