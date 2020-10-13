//
//  ViewController.swift
//  NK_Native_ios
//
//  Created by Nikita on 13/10/20.
//  Copyright © 2020 Nikita. All rights reserved.
//

import UIKit
import Flutter


class ViewController: UIViewController {
    
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func loadBtnAction(_ sender: UIButton) {
        let flutterEngine = ((UIApplication.shared.delegate as? AppDelegate)?.flutterEngine)!
        let flutterViewController = FlutterViewController(engine: flutterEngine, nibName: nil, bundle: nil)
        self.present(flutterViewController, animated: true, completion: nil)
        let datachannel = FlutterMethodChannel(name: "com.nikita/flutterTest/data", binaryMessenger: flutterViewController as! FlutterBinaryMessenger)
        let jsonObject:NSMutableDictionary = NSMutableDictionary()
        jsonObject.setValue("im flutter screen, I was called from swift", forKey: "descriptionstr")
        
        var convertedString:String? = nil
        
        do{
        let data = try JSONSerialization.data(withJSONObject: jsonObject, options: [])
            
            convertedString = String(data: data, encoding: .utf8)
            
        }catch{
            print(error)
        }
        
        datachannel.invokeMethod("fromSwiftToFlutter", arguments: convertedString)
        
        
        datachannel.setMethodCallHandler {
            [weak self](call:FlutterMethodCall, result:FlutterResult) in
            if call.method == "fromFlutterToSwift"{
                flutterViewController.dismiss(animated: true, completion: nil)
                let dict = call.arguments as? NSDictionary
                if call.arguments != nil{
                    let text = dict?["value"] as? String
                    self?.descriptionLabel.text = text
                }
            }
        }
    }
    
}

