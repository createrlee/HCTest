//
//  ShowViewController.swift
//  HCTest
//
//  Created by 이채원 on 2018. 5. 29..
//  Copyright © 2018년 david. All rights reserved.
//

import UIKit
import MBProgressHUD

class ShowViewController: UIViewController {
    
    @IBOutlet var imageView: UIImageView!
    
    var slideTerm: Int!
    
    var listIndex: Int = 5
    var mainImageList: [String] = []
    var bufferImageList: [String] = []
    
    var imageIndex: Int = 0
    var images: [UIImage] = []
    
    var timer: Timer!
    
    override func viewDidLoad() {
        
        self.startSlideShow()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.timer.invalidate()
        self.timer = nil
    }
    
    func startSlideShow() {
        
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        
        ImageAPI.loadImages(completion: { imageUrlList in
            self.mainImageList = imageUrlList
            
            // load first five images and show the first image
            self.loadInitialImages(completion: {
                
                DispatchQueue.main.async {
                    hud.hide(animated: true)
                    self.showNextImage()
                }
            })

            // start the slide show
            self.timer = Timer.scheduledTimer(timeInterval: TimeInterval(self.slideTerm), target: self, selector: #selector(self.showNextImage), userInfo: nil, repeats: true)
            
        })
        
        // Little bit of time gap must be needed
        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
            ImageAPI.loadImages(completion: { imageUrlList in
                self.bufferImageList = imageUrlList
            })
        }
    }
    
    //MARK: Loading the new image list
    func loadImageUrls() {
        
        self.mainImageList = self.bufferImageList
        
        ImageAPI.loadImages(completion: { imageUrlList in
            self.bufferImageList = imageUrlList
            print("a new image list loaded")
        })
    }
    
    //MARK: Showing the next image with animation
    @objc func showNextImage() {
        
        UIView.animate(withDuration: 0.5, animations: {
            self.imageView.alpha = 0
            
        }, completion: { isDone in
            UIView.animate(withDuration: 0.5, animations: {

                //print("\(self.imageIndex), \(self.listIndex)")
                
                self.imageView.image = self.images[self.imageIndex]
                
                self.loadImageFromUrlString(self.mainImageList[self.listIndex])
                
                self.listIndex += 1
                
                if self.listIndex == self.mainImageList.count {
                    self.loadImageUrls()
                    self.listIndex = 0
                }
                
                self.imageView.alpha = 1
            })
        })
    }
    
    //MARK: Loading the first five images and show the first image
    func loadInitialImages(completion: (() -> ())?) {
        
        var completionCount = 0
        
        for i in 0..<5 {
            if let url = URL(string: self.mainImageList[i]) {
                
                DispatchQueue.global().async {
                    do {
                        let imageData = try Data(contentsOf: url)
                        self.images.insert(UIImage(data: imageData)!, at: self.images.count)
                    } catch {
                        presentAlert(target: self, title: "wrong url")
                    }
                    
                    completionCount += 1
                    
                    if completion != nil && completionCount == 5 {
                        completion!()
                    }
                }
            }
        }
    }
    
    func loadImageFromUrlString(_ urlString: String) {
        if let url = URL(string: urlString) {
            
            DispatchQueue.global().async {
                do {
                    
                    let imageData = try Data(contentsOf: url)

                    self.images.remove(at: self.imageIndex)
                    self.images.insert(UIImage(data: imageData)!, at: self.imageIndex)
                    self.imageIndex = (self.imageIndex + 1) % 5

                } catch {
                    presentAlert(target: self, title: "wrong url")
                }
            }
        }
    }
    
    @IBAction func didStopButtonPressed(sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
