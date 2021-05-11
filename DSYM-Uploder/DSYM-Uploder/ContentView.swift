//
//  ContentView.swift
//  DSYM-Uploder
//
//  Created by Murat Yilmaz on 11.05.2021.
//

import SwiftUI

struct ContentView: View {
    
    @State var projectDirectory: URL?
    @State var dsymPath: URL?
    
    @State var processError: String?
    @State var showingAlert = false
    
    var body: some View {
        GeometryReader { geo in
            VStack {
                Button("Upload DSYM's") {
                    showProjectDirectoryDialog()
                }
            }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        }
        .alert(isPresented: $showingAlert, content: {
            Alert(title: Text("An Error occured"), message: Text(processError ?? "-"), dismissButton: .cancel())
        })
    }
    
    private func showProjectDirectoryDialog() {
        
        let dialog = NSOpenPanel()
        dialog.title = "Choose Project Directory"
        dialog.canChooseDirectories = false
        dialog.canChooseFiles = true
        dialog.allowedFileTypes = ["xcodeproj"]
        dialog.allowsMultipleSelection = false
        
        if (dialog.runModal() ==  NSApplication.ModalResponse.OK) {
            self.projectDirectory = dialog.urls.first
            DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
                showDSYMPathDialog()
            }
        }
    }
    
    private func showDSYMPathDialog() {
        
        let dialog = NSOpenPanel()
        dialog.title = "Choose DSYM's Path"
        dialog.canChooseDirectories = true
        dialog.canChooseFiles = false
        dialog.allowsMultipleSelection = false
        
        if (dialog.runModal() ==  NSApplication.ModalResponse.OK) {
            self.dsymPath = dialog.urls.first
            run()
        }
    }
    
    private func run() {
        
        guard let project = self.projectDirectory,
              let dsymPath = self.dsymPath else {
            return
        }
        
        let projectName = project.lastPathComponent.replacingOccurrences(of: ".xcodeproj", with: "")
        
        var mutableProject = project
        mutableProject.deleteLastPathComponent()
        
        let executableURL = URL(fileURLWithPath: "\(mutableProject.relativePath)/Pods/FirebaseCrashlytics/upload-symbols")
        let gspURL = "\(mutableProject.relativePath)/\(projectName)/GoogleService-Info.plist"
        
        let arguments = ["-gsp", gspURL, "-p", "ios", dsymPath.relativePath]
        
        do {
            try Process.run(executableURL, arguments: arguments,
                             terminationHandler: { _ in
                                print("completed...")
                             })
        } catch {
            processError = error.localizedDescription
            showingAlert = true
            print(error.localizedDescription)
        }
    }
    
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
