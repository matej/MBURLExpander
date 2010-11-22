//
//  MBURLExpander.h
//  URLExpander
//
//  Created by Matej Bukovinski on 21.11.10.
//  Copyright 2010 bukovinski.com. All rights reserved.
//

// This code is distributed under the terms and conditions of the MIT license. 

// Copyright (c) 2010 Matej Bukovinski
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import <Foundation/Foundation.h>


@interface MBURLExpander : NSObject <NSCopying> {

@private
	NSMutableDictionary *_cache;
	NSString *_userAgent;

}

+ (MBURLExpander *)sharedExpander;

/**
 * LongURL requres that this is set to an application specific identifier. 
 * Defaults to: "MBURLExpander"
 */
@property (nonatomic, retain) NSString *userAgent;

/**
 * Expands a short URL. 
 *
 * Uses a local cache is possible, otherwise connects to the LongURL service.
 * @see http://longurl.org/
 *
 * @param URLString the short URL to be expanded
 * @param callback a block that will get called once the URL is expanded. If and error occurs, URLString will be nil and 
 * error might hold some additional info (or is nil as well)
 */
- (void)expandURLString:(NSString *)URLString fetchCallback:(void (^)(NSString *URLString, NSError *error))callback;

/**
 * Writes the cache to disk. 
 */
- (void)synchronize;

@end
