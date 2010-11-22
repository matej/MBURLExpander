//
//  MBURLExpander.h
//  URLExpander
//
//  Created by Matej Bukovinski on 21.11.10.
//  Copyright 2010 bukovinski.com. All rights reserved.
//

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
