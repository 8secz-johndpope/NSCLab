//
//  Global.swift
//  LittleItaly
//
//  Created by Ashutosh Jani on 06/06/19.
//  Copyright © 2019 Trec2go. All rights reserved.
//

import Foundation
import CoreLocation
import SwiftyJSON

var conferenceId = String()
var isSpeaker = false
var tittleHeader = String()
var path = String()
var ymdFormat = DateFormatter()
var dmyFormat = DateFormatter()
var dmmmyFormat = DateFormatter()
var hmaFormat = DateFormatter ()
var locationAddress = String()
var locationImageUrl = String()

struct Constants {

  struct NotificationKeys {
    static let SignedIn = "onSignInCompleted"
  }

  struct Segues {
    static let SignInToFp = "SignInToFP"
    static let FpToSignIn = "FPToSignIn"
  }

  struct MessageFields {
    static let name = "name"
    static let text = "text"
    static let photoURL = "photoUrl"
    static let imageURL = "imageUrl"
  }
}
