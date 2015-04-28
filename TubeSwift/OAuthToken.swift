//
//  OAuthToken.swift
//  TubeSwift
//
//  Created by Leo G Dion on 4/27/15.
//  Copyright (c) 2015 Leo G Dion. All rights reserved.
//

import Foundation

public struct OAuthToken {
	public let access_token:String
	public let token_type:TokenType
	public let expires_in:NSTimeInterval?
	public let refresh_token:String?
	
	public static func parse(result: AnyObject?, refresh_token: String? = nil) -> OAuthToken? {
		if let tokenResponse = result as? [String: AnyObject], let access_token =  tokenResponse["access_token"] as? String {
			let token_type:TokenType?
			
			return OAuthToken(access_token: access_token, token_type: TokenType.Bearer, expires_in: tokenResponse["expires_in"] as? NSTimeInterval, refresh_token: tokenResponse["refresh_token"] as? String ?? refresh_token)
		} else {
			return nil
		}
	}
	
	
	public init (access_token:String,
		token_type:TokenType = TokenType.Bearer,
		expires_in:NSTimeInterval? = nil,
		refresh_token:String? = nil) {
			self.access_token = access_token
			self.expires_in = expires_in
			self.refresh_token = refresh_token
			self.token_type = token_type
	}
}