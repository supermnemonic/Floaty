//
//  ViewController.swift
//  KCFloatingActionButton
//
//  Created by LeeSunhyoup on 2015. 10. 4..
//  Copyright © 2015년 kciter. All rights reserved.
//

import UIKit

class ViewController: UIViewController, FloatyDelegate {
    
    var floaty = Floaty()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //FloatyManager.defaultInstance().font = UIFont.boldSystemFont(ofSize: 6)
        layoutFAB()
    }

    @IBAction func endEditing() {
        view.endEditing(true)
    }
    
    @IBAction func customImageSwitched(_ sender: UISwitch) {
        if sender.isOn == true {
            floaty.buttonImage = UIImage(named: "custom-add")
        } else {
            floaty.buttonImage = nil
        }
    }
    
    func layoutFAB() {
        let item = FloatyItem()
        item.hasShadow = true
        item.titleShadowColor = UIColor.blue
        item.titleLabelPosition = .right
        item.title = "titlePosition right"
        item.handler = { item in
            
        }

        floaty.buttonColor = .blue
        floaty.buttonColorOpen = .white
        floaty.plusColor = .white
        floaty.plusColorOpen = .blue
        floaty.hasShadow = false
        floaty.itemShadowColor = .clear
        floaty.addItem(title: "I got a title asdqwe asdzxchh")
        floaty.addItem("I got a icon", icon: UIImage(named: "icShare"))
        floaty.addItem("I got a handler", icon: UIImage(named: "icMap"), handler: { item in
            let alert = UIAlertController(title: "Hey", message: "I'm hungry...", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Me too", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        })
        floaty.addItem(item: item)
        floaty.paddingX = self.view.frame.width/2 - floaty.frame.width/2
        floaty.fabDelegate = self
        
        self.view.addSubview(floaty)

    }
    
    // MARK: - Floaty Delegate Methods
    func floatyWillOpen(_ floaty: Floaty) {
        print("Floaty Will Open")
    }
    
    func floatyDidOpen(_ floaty: Floaty) {
        print("Floaty Did Open")
    }
    
    func floatyWillClose(_ floaty: Floaty) {
        print("Floaty Will Close")
    }
    
    func floatyDidClose(_ floaty: Floaty) {
        print("Floaty Did Close")
    }
}
