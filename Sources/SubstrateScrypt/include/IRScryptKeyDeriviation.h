//
//  IRScryptKeyDeriviation.h
//  IrohaCrypto
//
//  Created by Ruslan Rezin on 27.02.2020.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSUInteger, IRScryptKeyDeriviationError) {
    IRScryptFailed
};

@interface IRScryptKeyDeriviation : NSObject

- (nullable NSData*)deriveKeyFrom:(nonnull NSData *)password
                             salt:(nonnull NSData *)salt
                           length:(NSUInteger)length
                            error:(NSError*_Nullable*_Nullable)error;

- (nullable NSData*)deriveKeyFrom:(nonnull NSData *)password
                             salt:(nonnull NSData *)salt
                          scryptN:(NSUInteger)scryptN
                          scryptP:(NSUInteger)scryptP
                          scryptR:(NSUInteger)scryptR
                           length:(NSUInteger)length
                            error:(NSError*_Nullable*_Nullable)error;
@end
