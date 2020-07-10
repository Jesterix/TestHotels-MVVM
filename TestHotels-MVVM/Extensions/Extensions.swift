import UIKit

extension UILabel {
    convenience init(text: String = "") {
        self.init(frame: .zero)
        self.attributedText = .init(string: text)
    }
}

extension UIImage {
    func imageWithoutBorder(width: CGFloat) -> UIImage? {
        let croppedSize = CGSize(width: size.width - (width * 2), height: size.height - (width * 2))
        let imageView = UIImageView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: croppedSize))
        imageView.contentMode = .center
        imageView.image = self
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        imageView.layer.render(in: context)
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result
    }
}

