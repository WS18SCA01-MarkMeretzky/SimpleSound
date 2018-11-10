//
//  ViewController.swift
//  SimpleSound
//
//  Created by Mark Meretzky on 11/10/18.
//  Copyright © 2018 New York University School of Professional Studies. All rights reserved.
//

import UIKit;
import AudioToolbox;   //for SystemSoundID

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad();
        // Do any additional setup after loading the view, typically from a nib.
        
        //Play a sound file of less than 30 seconds.
        
        let filename: String = "meow";
        let fileExtensions: [String] = ["m4a", "wav", "mp3", "aac", "adts", "aif", "aiff", "aifc", "caf", "mp4"];
        var url: URL?;
        
        for fileExtention in fileExtensions {
    		url = Bundle.main.url(forResource: filename, withExtension: fileExtention);
            if url != nil {
                break;
            }
        }
        
        if url == nil {
        	print("Unable to find sound file with name '\(filename)'");
        	return;
        }
        let cfurl: CFURL = url! as CFURL;   //convert to Core Foundation
        
        var systemSoundID: SystemSoundID = 0;
        //The second argument is an inout argument.
        var status: OSStatus = AudioServicesCreateSystemSoundID(cfurl, &systemSoundID);
        if status != noErr || systemSoundID == 0 {
            print("Unable to create sound with URL: '\(cfurl)'");
            return;
        }
        
        status = AudioServicesAddSystemSoundCompletion(systemSoundID, nil, nil, completion, nil);
        if status != noErr {
            print("Unable to add system sound completion with SystemSoundID: '\(systemSoundID)'");
            return;
        }

        AudioServicesPlaySystemSound(systemSoundID);
    }
}

//This function is called when the sound has finished playing.
func completion(systemSoundID: SystemSoundID, _: UnsafeMutableRawPointer?) {
    print("Sound finished playing.");
    let status: OSStatus = AudioServicesDisposeSystemSoundID(systemSoundID);
    if status != noErr {
        print("Unable to dispose sound with SystemSoundID: '\(systemSoundID)'");
    }
}

