//
//  QRReader.swift
//  RMS-2
//
//  Created by Pondz on 1/27/2560 BE.
//  Copyright © 2560 Pondz. All rights reserved.
//

import UIKit
import AVFoundation
import Font_Awesome_Swift

protocol QRReaderDelegate {
    func isFoundQRCode(qrCode : String)
}

class QRReader: UIViewController,AVCaptureMetadataOutputObjectsDelegate {
    
    @IBOutlet weak var backBtn: UIButton!

    var interactor : Interactor? = nil
    var captureSession : AVCaptureSession?
    var videoPreviewLayer : AVCaptureVideoPreviewLayer?
    var qrCodeFrameView : UIView?
    var delegate : QRReaderDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backBtn.setFAIcon(icon: FAType.FAChevronLeft, forState: .normal)
        
        let captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        
        do {
            let input = try AVCaptureDeviceInput.init(device: captureDevice)
            captureSession = AVCaptureSession()
            captureSession?.addInput(input)
            let captureMetaDataOutput = AVCaptureMetadataOutput()
            captureSession?.addOutput(captureMetaDataOutput)
            captureMetaDataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetaDataOutput.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
            
            qrCodeFrameView = UIView()
            if let qrCodeFrameView = qrCodeFrameView {
                qrCodeFrameView.layer.borderColor = UIColor.green.cgColor
                qrCodeFrameView.layer.borderWidth = 4
            }
            
        } catch  {
            print(error)
        }
        videoPreviewLayer = AVCaptureVideoPreviewLayer.init(session: captureSession)
        videoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        videoPreviewLayer?.frame = view.layer.bounds
        view.layer.addSublayer(videoPreviewLayer!)
        captureSession?.startRunning()
        view.bringSubview(toFront: backBtn)
        if(qrCodeFrameView == nil) { print("Cannot access to camera"); return }
        view.addSubview(qrCodeFrameView!)
        view.bringSubview(toFront: qrCodeFrameView!)
    }
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        if metadataObjects == nil || metadataObjects.count == 0{
            qrCodeFrameView?.frame = CGRect.zero
            return
        }
        
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        if metadataObj.type == AVMetadataObjectTypeQRCode {
            let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
            qrCodeFrameView?.frame = (barCodeObject?.bounds)!
            
            if metadataObj.stringValue != nil {
                captureSession?.stopRunning()
                self.dismiss(animated: true, completion: {_ in
                    self.delegate?.isFoundQRCode(qrCode: metadataObj.stringValue)
                })
                return
            }
        }
    }
    
    @IBAction func dismissSelf(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

}
