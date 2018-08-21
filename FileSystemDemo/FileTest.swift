import Foundation

class FileTest {
    static let shared = FileTest()

    func test() {
        getBundleResources()
        getContainerDirectories()

        // check document directory contents
        checkDocumentDirectoryContents()

        // create a file
        let fileName = "message1.txt"
        createDocFile(fileName: fileName, content: "hello swift")
        checkDocumentDirectoryContents()

        // now delete the file
        deleteDocFile(fileName: fileName)
        checkDocumentDirectoryContents()
    }

    func getBundleResources() {
        print("get bundle resources")

        if let imagePath = Bundle.main.path(forResource: "swift-og", ofType: "png"),             let attrs = try? FileManager.default.attributesOfItem(atPath: imagePath) {
            print("image path: \(imagePath)")
            print("attributes: \(attrs[FileAttributeKey.size] ?? "unknown")")
        }

        print("Bundle resource path: ", Bundle.main.resourcePath ?? "")

        if let resourceURL = Bundle.main.resourceURL,
            let contents = try? FileManager.default.contentsOfDirectory(at: resourceURL, includingPropertiesForKeys: nil, options: []) {
            print("resource path: \(resourceURL)")
            print("contents at resourcePath: ")
            for url in contents {
                print(url)
            }
        }


        print("bundle count: ", Bundle.allBundles.count)

        print("frameworks count \(Bundle.allFrameworks.count)")
    }

    // there are about 27 searchPathDirectories
    func getContainerDirectories() {
        print("temp directory: ", FileManager.default.temporaryDirectory)

        print("document directory: ", FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))

        print("library directory: ", FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask))

        print("application directory: ", FileManager.default.urls(for: .applicationDirectory, in: .userDomainMask))

        print("caches directory: ", FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask))

        print("developer directory: ", FileManager.default.urls(for: .developerDirectory, in: .userDomainMask))

        print("user directory: ", FileManager.default.urls(for: .userDirectory, in: .userDomainMask))
    }

    func getContainerDirectoryPaths() {
        print("temp dir path: ", NSTemporaryDirectory())
        print("document dir path: ", NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, false))
    }

    func checkDocumentDirectoryContents() {
        print("accessing contents with URLs")
        if let docDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first,
            let urls = try? FileManager.default.contentsOfDirectory(at: docDir, includingPropertiesForKeys: nil, options: []) {
            print("document directory contents: ", urls)

            for url in urls {
                if let str = try? String(contentsOf: url) {
                    print("file content: ", str)
                }
            }
        } else {
            print("document directory is empty")
        }

    }

    func checkDocumentsContentsWithPaths() {
        print("accessing contents with path strings")
        if let docPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first,
            let fileNames = try? FileManager.default.contentsOfDirectory(atPath: docPath) {
            print("document directory contents: ", fileNames)

            for f in fileNames {
                if let str = try? String(contentsOfFile: f) {
                    print("file content: ", str)
                }
            }
        } else {
            print("document directory is empty")
        }
    }

    func createDocFile(fileName: String, content: String) {
        guard let docDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }

        let fileURL = docDir.appendingPathComponent(fileName)
        print("file url: ", fileURL)

        if FileManager.default.fileExists(atPath: fileURL.absoluteString) {
            print("file exists")
            return
        }

        do {
            print("writing data to file...")
            try content.write(to: fileURL, atomically: true, encoding: .utf8)

            let newString = try String(contentsOf: fileURL)
            print("new string: ", newString)
        } catch {
            print("data writing error \(error)")
        }

    }

    func createDocFileWithPaths(fileName: String, content: String) {
        if let docDirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first {
            let filePath = docDirPath + "/" + fileName
            FileManager.default.createFile(atPath: filePath,
                                           contents: content.data(using: .utf8),
                                           attributes: nil)

            if FileManager.default.fileExists(atPath: filePath) {
                print("file exists")
                return
            }
        }
    }

    func deleteDocFile(fileName: String) {
        guard let docDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }

        let fileURL = docDir.appendingPathComponent(fileName)
        print("deleting file url: ", fileURL)

        try? FileManager.default.removeItem(at: fileURL)
    }

    func deleteDocFileWithPath(fileName: String) {
        guard let docPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first else { return }

        let filePath = docPath + "/" + fileName
        print("deleting file url: ", filePath)

        try? FileManager.default.removeItem(atPath: filePath)
    }

}
