//
//  ContentView.swift
//  Codesign Verifier
//
//  Created by David Wosk on 10/2/21.
//

import SwiftUI

struct ContentView: View {
    // Path to the dropped file
    @State var fileUrl: String = ""
    var body: some View {
        ZStack {
            if fileUrl.isEmpty {
                DropTargetView(fileUrl: $fileUrl)
            } else {
                CodeSignView(fileUrl: $fileUrl)
            }
        }
        .frame(width: 400, height: 600)
    }
}

struct CodeSignView: View {
    @Binding var fileUrl: String
    var body: some View {
        Text(fileUrl)
            .onAppear {
                execCodeSign(fileUrl: fileUrl)
            }
    }
}

func execCodeSign(fileUrl: String) {
    let task = Process()
    task.executableURL = URL(fileURLWithPath: "/usr/bin/codesign")
    task.arguments = ["-vvv", fileUrl]

    let outputPipe = Pipe()
    let errorPipe = Pipe()

    task.standardOutput = outputPipe
    task.standardError = errorPipe

    do {
        try task.run()

        let outputData = outputPipe.fileHandleForReading.readDataToEndOfFile()
        let errorData = errorPipe.fileHandleForReading.readDataToEndOfFile()

        let output = String(decoding: outputData, as: UTF8.self)
        let error = String(decoding: errorData, as: UTF8.self)

        task.waitUntilExit()
        let status = task.terminationStatus
        if status == 0 {
            print("Code signature is valid")
        } else {
            print("Invalid signature")
        }

        print("Output:  \(output)")
        print("Error:  \(error)")
    } catch {
        print("Unexpected error: \(error).")
    }
}

struct DropTargetView: View {
    @Binding var fileUrl: String
    var body: some View {
        ZStack {
            let radius: CGFloat = 20
            let backgroundRectangle = RoundedRectangle(cornerRadius: radius)
                .foregroundColor(Color.gray)
                .opacity(0.6)
            RoundedRectangle(cornerRadius: radius)
                .strokeBorder(Color.gray, lineWidth: 4)
                .background(backgroundRectangle)

            VStack {
                Text("Drop File here!")
                    .font(.largeTitle)
                    .padding()
            }
        }
        .padding(.all, 20.0)
        .onDrop(of: ["public.file-url"], delegate: FileDropDelegate(fileUrl: $fileUrl))
    }
}

struct FileDropDelegate: DropDelegate {
    @Binding var fileUrl: String
    func performDrop(info: DropInfo) -> Bool {
        print("Handling drop event")
        let supportedTypes = ["public.file-url"]
        guard info.hasItemsConforming(to: supportedTypes) else {
            return false
        }

        if let item = info.itemProviders(for: supportedTypes).first {
            item.loadItem(forTypeIdentifier: supportedTypes[0], options: nil) { (urlData, error) in
                DispatchQueue.main.async {
                    if let urlData = urlData as? Data {
                        let droppedFile = NSURL(absoluteURLWithDataRepresentation: urlData, relativeTo: nil) as URL
                        print(droppedFile.path)
                        fileUrl = droppedFile.path
                    }
                }
            }

            return true
        } else {
            return false
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.light)
        ContentView()
            .preferredColorScheme(.dark)
    }
}
