
#import <Foundation/Foundation.h>

@interface NSString (Base58)

+ (NSString *)base58WithData:(NSData *)d;
+ (NSString *)base58checkWithData:(NSData *)d;
- (NSData *)base58ToData;
- (NSData *)base58checkToData;
+ (NSString *)hexWithData:(NSData *)d;
- (NSData *)hexToData;
- (NSData *)addressToHash160;
+ (NSData*)fromHexString:(NSString*)str;
@end
