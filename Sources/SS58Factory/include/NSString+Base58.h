
#import <Foundation/Foundation.h>

@interface NSString (Base58)

+ (NSString *)base58WithData:(NSData *)d;
- (NSData *)base58ToData;
@end
