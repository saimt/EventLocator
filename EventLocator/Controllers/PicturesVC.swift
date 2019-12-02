//
//  PicturesVC.swift
//  EventLocator
//
//  Created by Saim on 19/11/2019.
//  Copyright © 2019 Saim. All rights reserved.
//

import UIKit
import TRMosaicLayout
import MediaBrowser
import SDWebImage
class PicturesVC: BaseVC {

    //MARK: Outlets
    @IBOutlet weak var cvPictures: UICollectionView!
    @IBOutlet weak var btnAddPictures: UIButton!
    @IBOutlet weak var btnClose: UIBarButtonItem!
    
    //MARK: Variables
    var eventData: EventMapper!
    var isInVicinity = false
    var mediaArray = [Media]()
    
    //MARK: Load
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        
        let distance = Global.userData.userLocation.calculateDistance(eventLocation: eventData.eventLocation)
        if distance <= 30 {
            isInVicinity = true
        }
        
    }
    
    //MARK: Methods
    func initView() {
        let mosaicLayout = TRMosaicLayout()
        self.cvPictures?.collectionViewLayout = mosaicLayout
        mosaicLayout.delegate = self
        
        for picture in eventData.pictures {
            let image = self.webMediaPhoto(url: picture.pictureUrl, caption: nil)
            self.mediaArray.append(image)
        }
        
    }
    
    func webMediaPhoto(url: String, caption: String?) -> Media {
        guard let validUrl = URL(string: url) else {
            fatalError("Image is nil")
        }
        
        var photo = Media()
        if let _caption = caption {
            photo = Media(url: validUrl, caption: _caption)
        } else {
            photo = Media(url: validUrl)
        }
        return photo
    }

    //MARK: Actions
    @IBAction func btnCloseAction(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func btnAddPictureAction(_ sender: UIButton) {
        if !isInVicinity {
            self.showToast("You should be in atleast 30 meter radius of event to add pictures.")
            return
        }
        ImagePickerManager.init().pickImage(self) { (image) in
            self.showLoader()
            ApiManager.uploadEventPicture(event: self.eventData, picture: image) { (pictureData, error) in
                self.hideLoader()
                if error == nil {
                    self.eventData.pictures.append(pictureData!)
                    self.cvPictures.reloadData()
                }
                else {
                    self.showToast(error!.localizedDescription)
                }
            }
        }
    }
}

extension PicturesVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return eventData.pictures.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GalleryCVCell", for: indexPath) as! GalleryCVCell
        let imageView = UIImageView()
        imageView.frame = cell.frame
        imageView.layer.cornerRadius = 10
        cell.backgroundView = imageView
        imageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
        imageView.sd_setImage(with: URL(string: eventData.pictures[indexPath.row].pictureThumbnailUrl), placeholderImage: UIImage(named: "placeholder"), options: .continueInBackground, context: nil, progress: nil, completed: nil)
        return cell
    }
}

extension PicturesVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let displayActionButton = true
        let displaySelectionButtons = false
        let displayMediaNavigationArrows = false
        let enableGrid = false
        let startOnGrid = false
        let autoPlayOnAppear = false
        let browser = MediaBrowser(delegate: self)
        browser.displayActionButton = displayActionButton
        browser.displayMediaNavigationArrows = displayMediaNavigationArrows
        browser.displaySelectionButtons = displaySelectionButtons
        browser.alwaysShowControls = displaySelectionButtons
        browser.zoomPhotosToFill = true
        browser.enableGrid = enableGrid
        browser.startOnGrid = startOnGrid
        browser.enableSwipeToDismiss = true
        browser.autoPlayOnAppear = autoPlayOnAppear
        browser.cachingImageCount = 2
        browser.setCurrentIndex(at: indexPath.row)
        let nc = UINavigationController.init(rootViewController: browser)
        nc.modalTransitionStyle = .crossDissolve
        self.present(nc, animated: true, completion: nil)
    }
}

extension PicturesVC: TRMosaicLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, mosaicCellSizeTypeAtIndexPath indexPath: IndexPath) -> TRMosaicCellType {
        return indexPath.item % 3 == 0 ? TRMosaicCellType.big : TRMosaicCellType.small
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: TRMosaicLayout, insetAtSection: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3)
    }
    
    func heightForSmallMosaicCell() -> CGFloat {
      return 150
    }
}

extension PicturesVC: MediaBrowserDelegate {
    func numberOfMedia(in mediaBrowser: MediaBrowser) -> Int {
        return mediaArray.count
    }
    
    func media(for mediaBrowser: MediaBrowser, at index: Int) -> Media {
        return mediaArray[index]
    }
}
