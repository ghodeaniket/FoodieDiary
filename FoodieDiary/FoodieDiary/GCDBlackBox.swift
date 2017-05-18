//
//  GCDBlackBox.swift
//  OnTheMap
//
//  Created by Aniket Ghode on 4/5/17.
//  Copyright © 2017 Aniket Ghode. All rights reserved.
//

import Foundation

func performUIUpdatesOnMain(_ updates: @escaping () -> Void) {
    DispatchQueue.main.async {
        updates()
    }
}
