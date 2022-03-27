//
//  FilterService.swift
//  CameraFilter
//
//  Created by 山本響 on 2022/03/27.
//

import UIKit
import CoreImage
import RxSwift

class FiltersService {
    
    private var context: CIContext
    
    init() {
        self.context = CIContext()
    }
    
    func applyFilter(to inputImage: UIImage) -> Observable<UIImage> {
        
        return Observable<UIImage>.create { observer in
            self.applyFilter(to: inputImage) { filteredImage in
                observer.onNext(filteredImage)
            }
            return Disposables.create()
        }
    }
    
    func applyFilter(to inputImage: UIImage, completion: @escaping ((UIImage) -> ())) {
        
        let filter = CIFilter(name: "CICMYKHalftone")!
        filter.setValue(5.0, forKey: kCIInputWidthKey)
        
        if let sourceImage = CIImage(image: inputImage) {
            filter.setValue(sourceImage, forKey: kCIInputImageKey)
            
            if let cgimag = self.context.createCGImage(filter.outputImage!, from: filter.outputImage!.extent) {
                
                let processdImage = UIImage(cgImage: cgimag, scale: inputImage.scale, orientation: inputImage.imageOrientation)
                completion(processdImage)
            }
        }
    }
}
