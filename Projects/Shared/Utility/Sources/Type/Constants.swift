//
//  Constants.swift
//  Utility
//
//  Created by 조용인 on 6/24/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation

public enum Constants {
  public static let naver_map_client_id = Bundle.main.infoDictionary?["NMCLIENTID"] as? String
  public static let base_url = Bundle.main.infoDictionary?["BASE_URL"] as? String
}
