//
//  MaskOCRFunction.swift
//  
//
//  Created by 永田大祐 on 2021/07/18.
//

import VisionKit
import Vision
import AVFoundation

@available(iOS 14.0, *)
final public class MaskOCRFunction: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate, ObservableObject {

    @Published public var backView: MaskOCRBackView?
    public var previewLayer: CALayer!
    public var changeExecution: ((UIImage) -> Void)?

    @Published private var st = ""
    @Published private var ocrText = " "
    @Published private var ocrSplitText = ""
    private var takePhoto: Bool = false
    private var capturepDevice: AVCaptureDevice!
    private var captureSession = AVCaptureSession()
    private var textRecognitionRequest = VNRecognizeTextRequest()

    public override init() {
        super.init()

        prepareCamera()
        beginSession()
        textRecognitionRequest = VNRecognizeTextRequest(completionHandler: { (request, error) in
            if let results = request.results, !results.isEmpty {
                if let requestResults = request.results as? [VNRecognizedTextObservation] {
                    self.addRecognizedText(recognizedText: requestResults)
                }
            }
        })
    }

    public func initSet() {
        st = ""
        ocrText = " "
        previewLayer.isHidden = false
    }

    public func takePhotos() {
        takePhoto = true
    }

    public func setText(st: String) {
        ocrSplitText = st
    }

    public func setText() -> String {
        ocrText
    }

    public func startSession() {
        if captureSession.isRunning { return }
        captureSession.startRunning()
    }

    public func endSession() {
        if !captureSession.isRunning { return }
        captureSession.stopRunning()
    }

    public func process(image: UIImage) {
        processImage(image: image)
    }

    // MARK: - AVCaptureVideoDataOutputSampleBufferDelegate
    public func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        if takePhoto {
            takePhoto = false
            if let image = getImageFromSampleBuffer(buffer: sampleBuffer) {
                changeExecution?(image)
            }
        }
    }

    private func prepareCamera() {
        captureSession.sessionPreset = .photo

        if let availableDevice = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaType.video, position: .back).devices.first {
            capturepDevice = availableDevice
        }
    }

    private func beginSession() {
        do {
            let captureDeviceInput = try AVCaptureDeviceInput(device: capturepDevice)
            captureSession.addInput(captureDeviceInput)
        } catch {
            print(error.localizedDescription)
        }

        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        self.previewLayer = previewLayer
 
        let dataOutput = AVCaptureVideoDataOutput()
        dataOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String:kCVPixelFormatType_32BGRA]

        if captureSession.canAddOutput(dataOutput) {
            captureSession.addOutput(dataOutput)
        }

        captureSession.commitConfiguration()

        let queue = DispatchQueue(label: "FromF.github.com.AVFoundationSwiftUI.AVFoundation")
        dataOutput.setSampleBufferDelegate(self, queue: queue)
    }

    private func getImageFromSampleBuffer (buffer: CMSampleBuffer) -> UIImage? {
        if let pixelBuffer = CMSampleBufferGetImageBuffer(buffer) {
            let ciImage = CIImage(cvPixelBuffer: pixelBuffer)
            let context = CIContext()

            let imageRect = CGRect(x: 0, y: 0, width: CVPixelBufferGetWidth(pixelBuffer), height: CVPixelBufferGetHeight(pixelBuffer))

            if let image = context.createCGImage(ciImage, from: imageRect) {
                return UIImage(cgImage: image, scale: UIScreen.main.scale, orientation: .right)
            }
        }

        return nil
    }

    private func processImage(image: UIImage) {
        guard let cgImage = image.cgImage else {
            print("Failed to get cgimage from input image")
            return
        }

        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        do {
            try handler.perform([textRecognitionRequest])
        } catch {
            print(error)
        }

        textRecognitionRequest = VNRecognizeTextRequest(completionHandler: { (request, error) in
            if let results = request.results, !results.isEmpty {
                if let requestResults = request.results as? [VNRecognizedTextObservation] {
                    self.addRecognizedText(recognizedText: requestResults)
                }
            }
        })
        textRecognitionRequest.recognitionLevel = .accurate
        textRecognitionRequest.usesLanguageCorrection = true
    }
}

@available(iOS 14.0, *)
extension MaskOCRFunction {
    private func addRecognizedText(recognizedText: [VNRecognizedTextObservation]) {
        st = ""
        ocrText = ""
        let maximumCandidates = 1
        for observation in recognizedText {
            guard let candidate = observation.topCandidates(maximumCandidates).first else { continue }
            st += candidate.string
            st.forEach { s in
                if (s.description.range(of: "\(ocrSplitText)",
                                        options: .regularExpression,
                                        range: nil,
                                        locale: nil) != nil) {
                    ocrText += s.description
                }
            }
        }
    }
}
