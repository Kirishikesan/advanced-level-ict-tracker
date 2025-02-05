//
//  MainViewController.swift
//  Finance Calculator
//
//  Created by ABC on 12/4/20.
//

import UIKit

class MainViewController: UIViewController {

    // outlets
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var appName: UILabel!
    @IBOutlet weak var welcomeMsg: UILabel!
    @IBOutlet weak var headerBg: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    // variables
    let cellWidth = 100
    var buttonList = [HomeButton]()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
    }

    // onOrientationChange
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        onOrientationChange()
    }
    
    override func viewWillAppear(_ animated: Bool) {
         self.navigationController?.isNavigationBarHidden = true
    }
    
    // custom methods
    
    func setUpUI()
    {
        onOrientationChange()
        prepareButtons()
        animations()
        self.view.backgroundColor = UIColor.backgroundColor()
    }
    
    // prepare main view buttons
    func prepareButtons()
    {
        buttonList.append(HomeButton(title: NSLocalizedString("Past Papers", comment: ""),photoName: "SavingsMain.png"))
        buttonList.append(HomeButton(title: NSLocalizedString("School Papers", comment: ""),photoName: "MortgageMain.png"))
        buttonList.append(HomeButton(title: NSLocalizedString("Tutorials", comment: ""),photoName: "LoanMain.png"))
        buttonList.append(HomeButton(title: NSLocalizedString("Profile", comment: ""),photoName: "ProfileMain.png"))
        buttonList.append(HomeButton(title: NSLocalizedString("help", comment: ""),photoName: "HelpMain.png"))
    }
    
    func animations()
    {
        self.welcomeMsg.alpha = 0
        UIView.animate(withDuration: 1, delay:1.0, animations: {
               self.welcomeMsg.alpha = 1
        }, completion: nil)
    }

    // remove header background radius for landscape views
    func onOrientationChange()
    {
        if UIDevice.current.orientation.isLandscape {
           self.headerBg.layer.cornerRadius = 0

        } else {
             self.headerBg.layer.cornerRadius = 20
             self.headerBg.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        }
        
        self.collectionView.collectionViewLayout.invalidateLayout()
    }
}

extension MainViewController: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return buttonList.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ButtonIdentifier", for: indexPath) as! HomeButtonView
        cell.title.text = buttonList[indexPath.row].title
        cell.image.image = UIImage(named: buttonList[indexPath.row].photoName)!
        
        //simple animation for cells. alpha 0 to 1.
        cell.alpha = 0
        cell.transform = CGAffineTransform(scaleX: 5.9, y: 0.4)
        UIView.animate(withDuration: 2, delay:1.0, animations: {
                cell.alpha = 2
                cell.transform = .identity
        }, completion: nil)
        return cell
    }
}

// extensions

extension MainViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        if(indexPath.row != 4)
        {
            let tabBarController = storyboard.instantiateViewController(withIdentifier:"tabBarController") as! TabBarController
            // pass the index to identify and change titles accordingly
            tabBarController.selectedPassedIndex = indexPath.row
            navigationController?.pushViewController(tabBarController,animated: true)
        }
        else
        {
            // help view
            let helpController = storyboard.instantiateViewController(withIdentifier:"helpVC") as! HelpViewController
            self.present(helpController, animated: true, completion: nil)

        }
    }
}


extension MainViewController : UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        // programatically identifying and setting the space between cells
        let count = UIDevice.current.orientation.isLandscape ? 4 : 1;
        let deviceWidth = Int(UIScreen.main.bounds.width)
        let boundsWidth = cellWidth * count + 20*(count - 1)
        let diff = CGFloat(deviceWidth - boundsWidth)
        
        return UIEdgeInsets(top: 20, left: diff/2, bottom: 20, right: diff/2)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: cellWidth + 100, height:  cellWidth + 10)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
}

