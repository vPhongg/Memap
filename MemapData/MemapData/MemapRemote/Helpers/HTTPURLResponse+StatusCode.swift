//
//  HTTPURLResponse+StatusCode.swift
//  MemapData
//
//  Created by Vu Dinh Phong on 16/04/2026.
//

import Foundation

extension HTTPURLResponse {
	private static var statusCode200: Int { return 200 }

	var statusCodeIs200: Bool {
		return statusCode == HTTPURLResponse.statusCode200
	}
}
