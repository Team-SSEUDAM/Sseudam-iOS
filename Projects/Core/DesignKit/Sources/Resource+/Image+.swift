//
//  Image+.swift
//  DesignKit
//
//  Created by 조용인 on 6/9/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import SwiftUI

public enum ImageSet: String {
  case add = "add"
  case addSpot = "addSpot"
  case arrowCircleUp = "arrow_circle_up"
  case cancel = "cancel"
  case close = "close"
  case delete = "delete"
  case deleteFill = "delete_fill"
  case edit = "edit"
  case home = "home"
  case homeFilled = "home__filled"
  case info = "info"
  case interests = "interests"
  case leftChevron = "left_chevron"
  case lock = "lock"
  case myLocation = "my_location"
  case normalTrash = "normal_trash"
  case normalTrashPin = "normal_trash_pin"
  case person = "person"
  case personFilled = "person__filled"
  case recycle = "recycle"
  case recycleTrash = "recycle_trash"
  case recycleTrashPin = "recycle_trash_pin"
  case replay = "replay"
  case rightChevron = "right_chevron"
  case search = "search"
  case sentimentDissatisfied = "sentiment_dissatisfied"
  case settings = "settings"
  case verified = "verified"
  case apple = "apple"
  case kakao = "kakao"
  case check = "check"
  case feedback = "feedback"
  case notification = "notification"
  case attendanceSuccess = "attendance_success"
  case attendanceFail = "attendance_fail"
  case attendanceEmpty = "attendance_empty"
  case welcome = "welcome"
  case sseudam = "sseudam_img"
  case avartar = "avatar"
  public var swiftUIImage: DesignKitImages { DesignKitImages(name: self.rawValue) }
}
