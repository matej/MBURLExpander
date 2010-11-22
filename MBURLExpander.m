//
//  MBURLExpander.m
//  URLExpander
//
//  Created by Matej Bukovinski on 21.11.10.
//  Copyright 2010 bukovinski.com. All rights reserved.
//

#import "MBURLExpander.h"


@interface MBURLExpander ()
- (NSString *)cacheFilePath;
- (void)loadCacheFromDisk;
- (void)storeCacheToDisk;
@end


@implementation MBURLExpander

#pragma mark -
#pragma mark Constants

NSString * const kMBURLExpanderFilename = @"URLExpanderCache.plist";
NSString * const kMBURLExpanderDictionary = @"URLExpander";

#pragma mark -
#pragma mark Singleton

static MBURLExpander *sharedExpander = nil;

+ (MBURLExpander *)sharedExpander {
	@synchronized(self) {
		if (sharedExpander == nil) {
			sharedExpander = [[self alloc] init];
		}
	}
	return sharedExpander;
}

+ (id)allocWithZone:(NSZone *)zone {
	@synchronized(self) {
		if (sharedExpander == nil) {
			sharedExpander = [super allocWithZone:zone];
			return sharedExpander;
		}
	}
	return nil;
}

- (id)copyWithZone:(NSZone *)zone {

#pragma unused(zone)

	return self;
}

- (NSUInteger)retainCount {
	return NSUIntegerMax;
}

- (id)retain {
	return self;
}

- (void)release {
}

- (id)autorelease {
	return self;
}

#pragma mark -
#pragma mark Accessors

@synthesize userAgent = _userAgent;

#pragma mark -
#pragma mark Lifecycle methods

- (id)init {
	self = [super init];
	if (self) {
		[self loadCacheFromDisk];
		self.userAgent = @"MBURLExpander";
	}
	return self;
}

#pragma mark -
#pragma mark Cache

- (NSString *)cacheFilePath {
	// i.e., Library/Caches/URLExpander
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES); 
	return [[paths objectAtIndex:0] stringByAppendingPathComponent:kMBURLExpanderDictionary];
}

- (void)loadCacheFromDisk {
	NSString *storePath = [self cacheFilePath];
	NSFileManager *fileManager = [[NSFileManager alloc] init];
	
	if (![fileManager fileExistsAtPath:storePath]) {
		// Path does not yet exist, create the directory and initialize a new empty cache in memory
		[fileManager createDirectoryAtPath:storePath withIntermediateDirectories:YES attributes:nil error:NULL];
		_cache = [[NSMutableDictionary alloc] init];
	} else {
		// Path does exist, load the existing cache to memory
		NSString *cachePath = [storePath stringByAppendingPathComponent:kMBURLExpanderFilename];
		_cache = [[NSMutableDictionary alloc] initWithContentsOfFile:cachePath];
		if (!_cache) {
			// Something went wrong, create a new cache
			_cache = [[NSMutableDictionary alloc] init];
		}
	}
	
	[fileManager release];
}

- (void)storeCacheToDisk {
	NSString *storePath = [self cacheFilePath];
	NSString *cachePath = [storePath stringByAppendingPathComponent:kMBURLExpanderFilename];
	
	// Just ignore if something goes wrong
	[_cache writeToFile:cachePath atomically:YES];
}

- (void)addShortURLToCache:(NSString *)shortURL withExpandedURL:(NSString *)expandedURL {
	[_cache setObject:expandedURL forKey:shortURL];
	// This will make sure that we don't write to disk too many times at once
	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(storeCacheToDisk) object:nil];
	[self performSelector:@selector(storeCacheToDisk) withObject:nil afterDelay:1];
}

#pragma mark -
#pragma mark Public

- (void)expandURLString:(NSString *)URLString fetchCallback:(void (^)(NSString *URLString, NSError *error))callback {
	
	// Check the cache
	NSString *expanded = [_cache objectForKey:URLString];
		
	if (expanded) {
		// Cached value found return immediately
		callback(expanded, nil);
		return;
	}
	
	// Cache miss, make a server request in the background
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
		NSString *format = @"http://api.longurl.org/v2/expand?url=";
		NSString *escapedURLString = [URLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
		NSString *requestString = [format stringByAppendingString:escapedURLString];
		NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:requestString]];
		[request setValue:_userAgent forHTTPHeaderField:@"User-Agent"];
		
		NSError *error = nil;
		NSURLResponse *response = nil;
		NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
		
		if (data && !error && [response isKindOfClass:[NSHTTPURLResponse class]] && 
			[(NSHTTPURLResponse *)response statusCode] == 200) {
			
			// We got something back that seems valid
			NSString *responseString = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
			NSRange start = [responseString rangeOfString:@"<long-url><![CDATA["];
			NSRange end = [responseString rangeOfString:@"]]></long-url>"];
			if (start.location == NSNotFound || end.location == NSNotFound) {
				// Nope, this isn't valid or the API was changes
				dispatch_async(dispatch_get_main_queue(), ^{
					callback(nil, nil);
				});
				return;
			}
			NSRange urlRange = NSMakeRange(start.location + start.length, end.location - (start.location + start.length));
			NSString *extractedURL = [responseString substringWithRange:urlRange];
			dispatch_async(dispatch_get_main_queue(), ^{
				[self addShortURLToCache:URLString withExpandedURL:extractedURL];
				callback(extractedURL, nil);
			});
		} else {
			dispatch_async(dispatch_get_main_queue(), ^{
				callback(nil, error);
			});
		}

	});
}

- (void)synchronize {
	// Cancel any previous store requests and store immediately
	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(storeCacheToDisk) object:nil];
	[self storeCacheToDisk];
}

@end
