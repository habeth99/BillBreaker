//
//  CameraManager.swift
//  billbreaker
//
//  Created by Nick Habeth on 7/25/24.
//

import Foundation
import SwiftUI
import AVFoundation

class CameraManager: ObservableObject {
    @Published var session: AVCaptureSession?
    private var videoDeviceInput: AVCaptureDeviceInput?

    func setupCamera() {
        print("Setting up camera...")
        let session = AVCaptureSession()
        session.beginConfiguration()

        session.sessionPreset = .photo

        guard let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else {
            print("Failed to get the camera device")
            return
        }

        do {
            let videoDeviceInput = try AVCaptureDeviceInput(device: videoDevice)
            if session.canAddInput(videoDeviceInput) {
                session.addInput(videoDeviceInput)
                self.videoDeviceInput = videoDeviceInput
                print("Added video device input to the session")
            } else {
                print("Couldn't add video device input to the session")
                session.commitConfiguration()
                return
            }
        } catch {
            print("Couldn't create video device input: \(error)")
            session.commitConfiguration()
            return
        }

        let photoOutput = AVCapturePhotoOutput()
        if session.canAddOutput(photoOutput) {
            session.addOutput(photoOutput)
            print("Added photo output to the session")
        } else {
            print("Could not add photo output to the session")
            session.commitConfiguration()
            return
        }

        session.commitConfiguration()
        self.session = session
        print("Camera setup completed")
    }

    func startSession() {
        print("Starting camera session...")
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.session?.startRunning()
            print("Camera session started")
        }
    }

    func stopSession() {
        print("Stopping camera session...")
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.session?.stopRunning()
            print("Camera session stopped")
        }
    }
}

//struct CameraView2: UIViewRepresentable {
//    @ObservedObject var cameraManager: CameraManager
//    
//    func makeUIView(context: Context) -> UIView {
//        print("Creating CameraView")
//        let view = UIView(frame: UIScreen.main.bounds)
//        
//        if let session = cameraManager.session {
//            let previewLayer = AVCaptureVideoPreviewLayer(session: session)
//            previewLayer.frame = view.bounds
//            previewLayer.videoGravity = .resizeAspectFill
//            view.layer.addSublayer(previewLayer)
//            print("Added preview layer to view")
//        } else {
//            print("No session available for preview layer")
//        }
//        
//        return view
//    }
//    
//    func updateUIView(_ uiView: UIView, context: Context) {
//        print("Updating CameraView")
//    }
//}
struct CameraView2: UIViewRepresentable {
    @ObservedObject var cameraManager: CameraManager
    
    func makeUIView(context: Context) -> UIView {
        print("Creating CameraView")
        let view = UIView(frame: UIScreen.main.bounds)
        
        // Add this line to set a background color
        view.backgroundColor = .red
        
        if let session = cameraManager.session {
            let previewLayer = AVCaptureVideoPreviewLayer(session: session)
            previewLayer.frame = view.bounds
            previewLayer.videoGravity = .resizeAspectFill
            view.layer.addSublayer(previewLayer)
            print("Added preview layer to view")
        } else {
            print("No session available for preview layer")
        }
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        print("Updating CameraView")
    }
}

struct ScanCheckView2: View {
    @StateObject private var cameraManager = CameraManager()
    @State private var isCameraAuthorized = false

//    var body: some View {
//        Group {
//            if isCameraAuthorized {
//                CameraView2(cameraManager: cameraManager)
//            } else {
//                Text("If you're seeing this DocScanner is not displaying properly")
//            }
//        }
//        .onAppear {
//            print("ScanCheckView appeared")
//            checkCameraAuthorization()
//        }
//        .onDisappear {
//            print("ScanCheckView disappeared")
//            cameraManager.stopSession()
//        }
//    }
    
    var body: some View {
        Group {
            if isCameraAuthorized {
                CameraView2(cameraManager: cameraManager)
            } else {
                Text("If you're seeing this DocScanner is not displaying properly")
                    .background(Color.yellow) // Add this line
            }
        }
        .background(Color.blue) // Add this line
        .onAppear {
            print("ScanCheckView appeared")
            checkCameraAuthorization()
        }
        .onDisappear {
            print("ScanCheckView disappeared")
            cameraManager.stopSession()
        }
    }

    func checkCameraAuthorization() {
        print("Checking camera authorization")
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            print("Camera already authorized")
            isCameraAuthorized = true
            cameraManager.setupCamera()
            cameraManager.startSession()
        case .notDetermined:
            print("Requesting camera access")
            AVCaptureDevice.requestAccess(for: .video) { granted in
                DispatchQueue.main.async {
                    print("Camera access granted: \(granted)")
                    self.isCameraAuthorized = granted
                    if granted {
                        self.cameraManager.setupCamera()
                        self.cameraManager.startSession()
                    }
                }
            }
        case .denied, .restricted:
            print("Camera access denied or restricted")
            isCameraAuthorized = false
        @unknown default:
            print("Unknown camera authorization status")
            isCameraAuthorized = false
        }
    }
}
