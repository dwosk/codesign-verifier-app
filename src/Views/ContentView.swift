//
//  ContentView.swift
//  Codesign Verifier
//
//  Created by David Wosk on 10/2/21.
//

import SwiftUI

struct ContentView: View {
    // absolute file URL of the dropped file
    @State var fileUrl: String = ""
    var body: some View {
        ZStack {
            if fileUrl.isEmpty {
                DropTargetView(fileUrl: $fileUrl)
            } else {
                Text(fileUrl)
            }
        }
        .frame(width: 400, height: 600)
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
                        print(droppedFile.absoluteString)
                        fileUrl = droppedFile.absoluteString
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
