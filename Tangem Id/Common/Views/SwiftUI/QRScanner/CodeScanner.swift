//
//  CodeScannerView.swift
//
//  Created by Paul Hudson on 10/12/2019.
//  Copyright © 2019 Paul Hudson. All rights reserved.
//

import AVFoundation
import SwiftUI

/// A SwiftUI view that is able to scan barcodes, QR codes, and more, and send back what was found.
/// To use, set `codeTypes` to be an array of things to scan for, e.g. `[.qr]`, and set `completion` to
/// a closure that will be called when scanning has finished. This will be sent the string that was detected or a `ScanError`.
/// For testing inside the simulator, set the `simulatedData` property to some test data you want to send back.
public struct CodeScannerView: UIViewControllerRepresentable {
    public enum ScanError: Error {
        case badInput, badOutput
    }

    public class ScannerCoordinator: NSObject, AVCaptureMetadataOutputObjectsDelegate {
        var parent: CodeScannerView
        var codeFound = false

        init(parent: CodeScannerView) {
            self.parent = parent
        }

        public func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
            if let metadataObject = metadataObjects.first {
                guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
                guard let stringValue = readableObject.stringValue else { return }
                guard codeFound == false else { return }

                AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
                found(code: stringValue)

                // make sure we only trigger scans once per use
                codeFound = true
            }
        }

        func found(code: String) {
            parent.completion(.success(code))
        }

        func didFail(reason: ScanError) {
            parent.completion(.failure(reason))
        }
    }

    public class ScannerViewController: UIViewController {
        var captureSession: AVCaptureSession!
        var previewLayer: AVCaptureVideoPreviewLayer!
        var delegate: ScannerCoordinator?
		
		private let overlayName = "overlay"
		private let overlaySize = CGSize(width: 300, height: 200)
		
		private var metadataOutput: AVCaptureMetadataOutput!
		
		private var overlayRect: CGRect {
			CGRect(x: view.frame.width / 2 - overlaySize.width / 2,
				   y: view.frame.height / 2 - overlaySize.height / 2,
				   width: overlaySize.width,
				   height: overlaySize.height)
		}
		
        override public func viewDidLoad() {
            super.viewDidLoad()

            NotificationCenter.default.addObserver(self,
                                                   selector: #selector(updateOrientation),
                                                   name: Notification.Name("UIDeviceOrientationDidChangeNotification"),
                                                   object: nil)

            view.backgroundColor = UIColor.black
            captureSession = AVCaptureSession()

            guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
            let videoInput: AVCaptureDeviceInput

            do {
                videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
            } catch {
                return
            }

            if (captureSession.canAddInput(videoInput)) {
                captureSession.addInput(videoInput)
            } else {
                delegate?.didFail(reason: .badInput)
                return
            }

			metadataOutput = AVCaptureMetadataOutput()

            if (captureSession.canAddOutput(metadataOutput)) {
                captureSession.addOutput(metadataOutput)
				
                metadataOutput.setMetadataObjectsDelegate(delegate, queue: DispatchQueue.main)
                metadataOutput.metadataObjectTypes = delegate?.parent.codeTypes
            } else {
                delegate?.didFail(reason: .badOutput)
                return
            }
				
		}
		
        override public func viewWillLayoutSubviews() {
            previewLayer?.frame = view.layer.bounds
        }

        @objc func updateOrientation() {
            guard let orientation = UIApplication.shared.windows.first?.windowScene?.interfaceOrientation else {
                return
            }
            let previewConnection = captureSession.connections[1]
            previewConnection.videoOrientation = AVCaptureVideoOrientation(rawValue: orientation.rawValue) ?? .portrait
        }

        override public func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
			let viewBounds = view.layer.bounds
            previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            previewLayer.frame = viewBounds
            previewLayer.videoGravity = .resizeAspectFill
            view.layer.addSublayer(previewLayer)
			
			if !(previewLayer?.sublayers?.contains(where: { $0.name == overlayName }) ?? false) {
				
				let pathBigRect = UIBezierPath(rect: viewBounds)
				let pathSmallRect = UIBezierPath(rect: overlayRect)

				pathBigRect.append(pathSmallRect)
				pathBigRect.usesEvenOddFillRule = true

				let fillLayer = CAShapeLayer()
				fillLayer.name = overlayName
				fillLayer.path = pathBigRect.cgPath
				fillLayer.fillRule = .evenOdd
				fillLayer.fillColor = UIColor.black.cgColor
				fillLayer.opacity = 0.6
				
				let borders = CAShapeLayer()
				borders.path = overlayBorder().cgPath
				borders.lineWidth = 2
				borders.strokeColor = UIColor.green.cgColor
				borders.fillColor = UIColor.clear.cgColor
				
				let line = CAShapeLayer()
				line.path = UIBezierPath(rect: CGRect(origin: CGPoint(x: overlayRect.origin.x, y: viewBounds.height / 2 - 1),
													  size: CGSize(width: overlayRect.width, height: 2))).cgPath
				line.fillColor = UIColor.red.cgColor
				
				let opacityAnim = CABasicAnimation(keyPath: "opacity")
				opacityAnim.fromValue = line.opacity
				opacityAnim.toValue = 0
				opacityAnim.repeatCount = .infinity
				opacityAnim.duration = 0.4
				opacityAnim.autoreverses = true
				line.add(opacityAnim, forKey: "opacity")
				previewLayer?.addSublayer(fillLayer)
				previewLayer?.addSublayer(borders)
				previewLayer?.addSublayer(line)
			}
            updateOrientation()
			
            captureSession.startRunning()
			
			let rectOfInterest = previewLayer.metadataOutputRectConverted(fromLayerRect: overlayRect)
			metadataOutput.rectOfInterest = rectOfInterest
        }
		
		private func overlayBorder() -> UIBezierPath {
			let borderPath = UIBezierPath()
			let lineLength: CGFloat = 30
			let size = overlayRect.size
			let origin = overlayRect.origin
			let rt = CGPoint(x: origin.x + size.width, y: origin.y)
			let rb = CGPoint(x: rt.x, y: rt.y + size.height)
			let lb = CGPoint(x: origin.x, y: origin.y + size.height)
			borderPath.move(to: CGPoint(x: origin.x, y: origin.y + lineLength))
			borderPath.addLine(to: origin)
			borderPath.addLine(to: CGPoint(x: origin.x + lineLength, y: origin.y))
			borderPath.move(to: CGPoint(x: rt.x - lineLength, y: origin.y))
			borderPath.addLine(to: rt)
			borderPath.addLine(to: CGPoint(x: rt.x, y: rt.y + lineLength))
			borderPath.move(to: CGPoint(x: rb.x, y: rb.y - lineLength))
			borderPath.addLine(to: rb)
			borderPath.addLine(to: CGPoint(x: rb.x - lineLength, y: rb.y))
			borderPath.move(to: CGPoint(x: lb.x + lineLength, y: lb.y))
			borderPath.addLine(to: lb)
			borderPath.addLine(to: CGPoint(x: lb.x, y: lb.y - lineLength))
			borderPath.stroke()
			return borderPath
		}

        override public func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)

            if (captureSession?.isRunning == false) {
                captureSession.startRunning()
            }
        }

        override public func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)

            if (captureSession?.isRunning == true) {
                captureSession.stopRunning()
            }

            NotificationCenter.default.removeObserver(self)
        }

        override public var prefersStatusBarHidden: Bool {
            return true
        }

        override public var supportedInterfaceOrientations: UIInterfaceOrientationMask {
            return .all
        }
    }

    public let codeTypes: [AVMetadataObject.ObjectType]
    public var simulatedData = ""
    public var completion: (Result<String, ScanError>) -> Void

    public init(codeTypes: [AVMetadataObject.ObjectType], simulatedData: String = "", completion: @escaping (Result<String, ScanError>) -> Void) {
        self.codeTypes = codeTypes
        self.simulatedData = simulatedData
        self.completion = completion
    }

    public func makeCoordinator() -> ScannerCoordinator {
        return ScannerCoordinator(parent: self)
    }

    public func makeUIViewController(context: Context) -> ScannerViewController {
        let viewController = ScannerViewController()
        viewController.delegate = context.coordinator
        return viewController
    }

    public func updateUIViewController(_ uiViewController: ScannerViewController, context: Context) {

    }
}

struct CodeScannerView_Previews: PreviewProvider {
    static var previews: some View {
        CodeScannerView(codeTypes: [.qr]) { result in
            // do nothing
        }
    }
}
