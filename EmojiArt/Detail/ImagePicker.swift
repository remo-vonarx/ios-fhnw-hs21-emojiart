import Foundation
import SwiftUI
import UIKit

typealias ImagePickHandler = (UIImage?) -> Void
struct ImagePicker: UIViewControllerRepresentable {
    let sourceType: UIImagePickerController.SourceType
    let handlePickedImage: ImagePickHandler

    func makeUIViewController(context: Context) -> some UIViewController {
        let viewController = UIImagePickerController()
        viewController.sourceType = sourceType
        viewController.delegate = context.coordinator
        return viewController
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(handlePickedImage: handlePickedImage)
    }

    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let handlePickedImage: ImagePickHandler

        init(handlePickedImage: @escaping ImagePickHandler) {
            self.handlePickedImage = handlePickedImage
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            let image = info[.originalImage] as? UIImage
            handlePickedImage(image)
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            handlePickedImage(nil)
        }
    }
}
