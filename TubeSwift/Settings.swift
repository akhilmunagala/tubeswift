//
//  Settings.swift
//  TubeSwift
//
//  Created by Leo G Dion on 4/27/15.
//  Copyright (c) 2015 Leo G Dion. All rights reserved.
//

import Foundation
extension String {
	
	/// Percent escape value to be added to a URL query value as specified in RFC 3986
	///
	/// This percent-escapes all characters besize the alphanumeric character set and "-", ".", "_", and "~".
	///
	/// http://www.ietf.org/rfc/rfc3986.txt
	///
	/// :returns: Return precent escaped string.
	
	func stringByAddingPercentEncodingForURLQueryValue() -> String? {
		let characterSet = NSMutableCharacterSet.alphanumericCharacterSet()
		characterSet.addCharactersInString("-._~")
		
		return self.stringByAddingPercentEncodingWithAllowedCharacters(characterSet)
	}
	
}

extension Dictionary {
	
	/// Build string representation of HTTP parameter dictionary of keys and objects
	///
	/// This percent escapes in compliance with RFC 3986
	///
	/// http://www.ietf.org/rfc/rfc3986.txt
	///
	/// :returns: String representation in the form of key1=value1&key2=value2 where the keys and values are percent escaped
	
	func stringFromHttpParameters() -> String {
		return reduce(self, "", { (memo, pair) -> String in
			let (key, value) = pair
			if let percentEscapedKey = (key as? String)?.stringByAddingPercentEncodingForURLQueryValue(), let percentEscapedValue = (value as? String)?.stringByAddingPercentEncodingForURLQueryValue() {
				return memo + "&\(percentEscapedKey)=\(percentEscapedValue)"
			} else {
				return memo
			}
		})
	}
	
}

public struct Settings {
	public let auth_uri:String
	public let client_secret:String
	public let token_uri:String
	public let client_email:String?
	public let redirect_uris:[String]
	public let client_x509_cert_url:String?
	public let client_id:String
	public let auth_provider_x509_cert_url:String?
	
	public var redirect_uri : String {
		return redirect_uris.first!
	}
	
	public func authorize_url(scopes : [Scope]) -> NSURL? {
//		let scopeString = " ".join(scopes.map{"\($0)"})
		let scopeString = " ".join(scopes.map{$0.rawValue})
		let googleOAuthParameters = ["client_id" : self.client_id,
			"redirect_uri" : self.redirect_uri,
			"scope": scopeString,
			"response_type":"code"]
		let googleOAuthParametersString = googleOAuthParameters.stringFromHttpParameters()
		return NSURL(string: "\(self.auth_uri)?\(googleOAuthParametersString)")
	}
	
	public struct Default {
		public static let auth_uri = "https://accounts.google.com/o/oauth2/auth"
		public static let token_uri = "https://accounts.google.com/o/oauth2/token"
		public static let redirect_uris = ["urn:ietf:wg:oauth:2.0:oob", "oob"]
	}
	
	public init (
		client_id:String,
		client_secret:String,
		auth_provider_x509_cert_url:String?,
		auth_uri:String = Default.auth_uri,
		token_uri:String = Default.token_uri,
		redirect_uris:[String] = Default.redirect_uris,
		client_x509_cert_url:String? = nil,
		client_email:String? = nil) {
			self.auth_uri = auth_uri
			self.client_secret = client_secret
			self.token_uri = token_uri
			self.client_email = (client_email != nil && count(client_email!) > 0) ? client_email : nil
			self.redirect_uris = redirect_uris
			self.client_x509_cert_url = (client_x509_cert_url != nil && count(client_x509_cert_url!) > 0) ? client_x509_cert_url : nil
			self.client_id = client_id
			self.auth_provider_x509_cert_url = (auth_provider_x509_cert_url != nil && count(auth_provider_x509_cert_url!) > 0) ? auth_provider_x509_cert_url : nil

	}
}