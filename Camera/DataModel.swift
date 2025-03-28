/*
See the License.txt file for this sample’s licensing information.
*/

import AVFoundation
import SwiftUI
import os.log
import Vision
import Combine
import CoreImage

//final class DataModel: ObservableObject {
//    let camera = Camera()
//    let photoCollection = PhotoCollection(smartAlbum: .smartAlbumUserLibrary)
//    var isPhotosLoaded = false
//    private let apiService = APIService.shared
//    private let textRecognitionService = TextRecognitionService.shared
//    @Published var capturedImage: UIImage?
//    @Published var showFullScreenImage: Bool = false
//    
//    //@Published var viewfinderImage: Image?
//    @Published var thumbnailImage: Image?
//    @Published var recognizedText: String = ""
//    @Published var prices: [String] = []
//    @Published var processedReceipt = APIReceipt()
//    @Published var isProcessing: Bool = false
//    @Published var isProcessingComplete: Bool = false
//    @Published var viewfinderImage: Image?
//    private var viewfinderCancellable: AnyCancellable?
//    private let context = CIContext()
//    
//    @Published var processingTime: TimeInterval = 0
//    private var processingStartTime: Date?
//    private var processingTimer: Timer?
//    
//    init() {
//        Task {
//            await handleCameraPreviews()
//        }
//        
//        Task {
//            await handleCameraPhotos()
//        }
//    }
//
//    func handleCameraPreviews() async {
//        let imageStream = camera.previewStream
//            .map { $0.image }
//
//        for await image in imageStream {
//            await MainActor.run {
//                viewfinderImage = image
//            }
//        }
//    }
//    
//    @MainActor
//    func handleCameraPhotos() async {
//        let unpackedPhotoStream = camera.photoStream
//            .compactMap { self.unpackPhoto($0) }
//        
//        for await photoData in unpackedPhotoStream {
//            await processPhoto(imageData: photoData.imageData)
//        }
//    }
final class DataModel: ObservableObject {
    let camera = Camera()
    let photoCollection = PhotoCollection(smartAlbum: .smartAlbumUserLibrary)
    var isPhotosLoaded = false
    private let apiService = APIService.shared
    private let textRecognitionService = TextRecognitionService.shared
    @Published var capturedImage: UIImage?
    @Published var showFullScreenImage: Bool = false

    @Published var thumbnailImage: Image?
    @Published var recognizedText: String = ""
    @Published var prices: [String] = []
    @Published var processedReceipt = APIReceipt()
    @Published var isProcessing: Bool = false
    @Published var isProcessingComplete: Bool = false
    @Published var viewfinderImage: Image?
    private var viewfinderCancellable: AnyCancellable?
    private let context = CIContext()

    @Published var processingTime: TimeInterval = 0
    private var processingStartTime: Date?
    private var processingTimer: Timer?

    init() {
        Task {
            await handleCameraPreviews()
        }

        Task {
            await handleCameraPhotos()
        }
    }

    func handleCameraPreviews() async {
        let imageStream = camera.previewStream
            .map { $0.image }

        for await image in imageStream {
            await MainActor.run {
                viewfinderImage = image
            }
        }
    }

    @MainActor
    func handleCameraPhotos() async {
        let unpackedPhotoStream = camera.photoStream
            .compactMap { self.unpackPhoto($0) }

        for await photoData in unpackedPhotoStream {
            if let image = UIImage(data: photoData.imageData) {
                self.capturedImage = image
                self.showFullScreenImage = true
            }
            await processPhoto(imageData: photoData.imageData)
        }
    }




    func processPhoto(imageData: Data) async {
        await MainActor.run {
            isProcessing = true
            isProcessingComplete = false
            processingStartTime = Date()
        }
        
        // Start a timer to update processing time
        await MainActor.run {
            self.processingTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
                guard let self = self, let startTime = self.processingStartTime else { return }
                self.processingTime = Date().timeIntervalSince(startTime)
            }
        }
        
        defer {
            Task { @MainActor in
                self.isProcessing = false
                self.isProcessingComplete = true
                self.processingTimer?.invalidate()
                self.processingTimer = nil
            }
        }
        
        do {
            let recognizedText = try await withCheckedThrowingContinuation { continuation in
                TextRecognitionService.shared.performTextRecognition(imageData: imageData) { result in
                    continuation.resume(returning: result)
                }
            }
            await MainActor.run {
                self.recognizedText = recognizedText
            }
            logger.debug("Recognized text: \(recognizedText)")
            
            let processedReceipt = try await apiService.sendExtractedTextToAPI(extractedText: recognizedText)
            await MainActor.run {
                self.processedReceipt = processedReceipt
            }
            print("Processed Receipt: \(processedReceipt)")
        } catch {
            await MainActor.run {
                logger.error("Error processing photo: \(error.localizedDescription)")
                self.processedReceipt = APIReceipt() // Clear any previous receipt in case of error
            }
        }
    }
    
    
    func importPhoto(image: UIImage) {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            logger.error("Failed to convert image to data")
            return
        }
        Task {
            await processPhoto(imageData: imageData)
        }
    }
    
    private func unpackPhoto(_ photo: AVCapturePhoto) -> PhotoData? {
        guard let imageData = photo.fileDataRepresentation() else { return nil }

        guard let previewCGImage = photo.previewCGImageRepresentation(),
           let metadataOrientation = photo.metadata[String(kCGImagePropertyOrientation)] as? UInt32,
              let cgImageOrientation = CGImagePropertyOrientation(rawValue: metadataOrientation) else { return nil }
        let imageOrientation = Image.Orientation(cgImageOrientation)
        let thumbnailImage = Image(decorative: previewCGImage, scale: 1, orientation: imageOrientation)
        
        let photoDimensions = photo.resolvedSettings.photoDimensions
        let imageSize = (width: Int(photoDimensions.width), height: Int(photoDimensions.height))
        let previewDimensions = photo.resolvedSettings.previewDimensions
        let thumbnailSize = (width: Int(previewDimensions.width), height: Int(previewDimensions.height))
        
        return PhotoData(thumbnailImage: thumbnailImage, thumbnailSize: thumbnailSize, imageData: imageData, imageSize: imageSize)
    }
    
    func savePhoto(imageData: Data) {
        Task {
            do {
                try await photoCollection.addImage(imageData)
                logger.debug("Added image data to photo collection.")
            } catch let error {
                logger.error("Failed to add image to photo collection: \(error.localizedDescription)")
            }
        }
    }
    
    func loadPhotos() async {
        guard !isPhotosLoaded else { return }
        
        let authorized = await PhotoLibrary.checkAuthorization()
        guard authorized else {
            logger.error("Photo library access was not authorized.")
            return
        }
        
        Task {
            do {
                try await self.photoCollection.load()
                await self.loadThumbnail()
            } catch let error {
                logger.error("Failed to load photo collection: \(error.localizedDescription)")
            }
            self.isPhotosLoaded = true
        }
    }
    
    func loadThumbnail() async {
        guard let asset = photoCollection.photoAssets.first  else { return }
        await photoCollection.cache.requestImage(for: asset, targetSize: CGSize(width: 256, height: 256))  { result in
            if let result = result {
                Task { @MainActor in
                    self.thumbnailImage = result.image
                }
            }
        }
    }
    

}

fileprivate struct PhotoData {
    var thumbnailImage: Image
    var thumbnailSize: (width: Int, height: Int)
    var imageData: Data
    var imageSize: (width: Int, height: Int)
}

fileprivate extension CIImage {
    var image: Image? {
        let ciContext = CIContext()
        guard let cgImage = ciContext.createCGImage(self, from: self.extent) else { return nil }
        return Image(decorative: cgImage, scale: 1, orientation: .up)
    }
}

fileprivate extension Image.Orientation {

    init(_ cgImageOrientation: CGImagePropertyOrientation) {
        switch cgImageOrientation {
        case .up: self = .up
        case .upMirrored: self = .upMirrored
        case .down: self = .down
        case .downMirrored: self = .downMirrored
        case .left: self = .left
        case .leftMirrored: self = .leftMirrored
        case .right: self = .right
        case .rightMirrored: self = .rightMirrored
        }
    }
}

fileprivate let logger = Logger(subsystem: "com.apple.swiftplaygroundscontent.capturingphotos", category: "DataModel")

