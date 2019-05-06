//
//  DetailReceiptViewController.swift
//  
//
//  Created by Bethany Bin on 5/9/18.
//

import UIKit

class DetailReceiptViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var imageView: UIImageView!
    var imageSegue: UIImage!

    @IBOutlet weak var scrollView: UIScrollView!
    var randomText: String!
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = imageSegue
        imageView.frame = scrollView.bounds
        scrollView.alwaysBounceVertical = false
        scrollView.alwaysBounceHorizontal = false
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = (imageView.image?.size.width)! / scrollView.frame.size.width;
        scrollView.zoomScale = 1.0;
        scrollView.delegate = self

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    
    @IBAction func shareAction(_ sender: Any) {
        let activityController = UIActivityViewController(activityItems: [imageView.image], applicationActivities: nil)
        present(activityController, animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
