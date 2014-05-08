//
//  RSACrypt.h
//  DZHLotteryTicket
//
//  Created by Weirdln on 13-11-29.
//  Copyright (c) 2013年 Weirdln. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RSACrypt : NSObject
{
    SecKeyRef publicKey;
    SecCertificateRef certificate;
    SecPolicyRef policy;
    SecTrustRef trust;
    size_t maxPlainLen;
}
@property (nonatomic, retain, setter = setPublicKeyCnts:) NSData *publicKeyCnts;
@property (nonatomic, readonly) BOOL generateKeyStatus;

- (NSData *)encryptWithData:(NSData *)content;
- (NSData *)encryptWithString:(NSString *)content;

@end
