//
//  RSACrypt.m
//  DZHLotteryTicket
//
//  Created by Weirdln on 13-11-29.
//  Copyright (c) 2013年 Weirdln. All rights reserved.
//

#import "RSACrypt.h"

@interface RSACrypt ()
- (void)releaseRefData;
- (BOOL)initRSARefData:(NSData *)data;

@end

@implementation RSACrypt
@synthesize publicKeyCnts = _publicKeyCnts;
@synthesize generateKeyStatus   = _generateKeyStatus;

- (void)dealloc
{
    self.publicKeyCnts  = nil;
    [self releaseRefData];
    
    [super dealloc];
}


#pragma mark - private's method
- (void)releaseRefData
{
    if (publicKey)
    {
        CFRelease(publicKey);
        publicKey   = NULL;
    }
    
    if (certificate)
    {
        CFRelease(certificate);
        certificate = NULL;
    }
    
    if (trust)
    {
        CFRelease(trust);
        trust = NULL;
    }
    
    if (policy)
    {
        CFRelease(policy);
        policy = NULL;
    }
}

- (BOOL)initRSARefData:(NSData *)data
{
    BOOL bRet = NO;
    certificate = SecCertificateCreateWithData(kCFAllocatorDefault, ( __bridge CFDataRef)data);
    if (certificate)
    {
        policy = SecPolicyCreateBasicX509();
        OSStatus returnCode = SecTrustCreateWithCertificates(certificate, policy, &trust);
        if (returnCode == 0)
        {
            SecTrustResultType trustResultType;
            returnCode = SecTrustEvaluate(trust, &trustResultType);
            
            if (returnCode == 0)
            {
                publicKey = SecTrustCopyPublicKey(trust);
                if (publicKey)
                {
                    maxPlainLen = SecKeyGetBlockSize(publicKey) - 12;
                    bRet = YES;
                }
            }
        }
    }
    
    return bRet;
}

#pragma mark - public's method
- (void)setPublicKeyCnts:(NSData *)data
{
    [data retain];
    [_publicKeyCnts release];
    _publicKeyCnts = data;
    
    [self releaseRefData];
    _generateKeyStatus = [self initRSARefData:data];
}

- (NSData *)encryptWithData:(NSData *)content
{
    NSData *result = nil;
    
    size_t plainLen = [content length];
    
    if (plainLen > maxPlainLen)
    {
        NSLog(@"content(%ld) is too long, must < %ld", plainLen, maxPlainLen);
        return nil;
    }

    void *plain = malloc(plainLen);
    
    if (plain)
    {
        [content getBytes:plain length:plainLen];
        
        size_t cipherLen = 128; // 当前RSA的密钥长度是128字节
        void *cipher = malloc(cipherLen);
        if (cipher)
        {
            OSStatus returnCode = SecKeyEncrypt(publicKey, kSecPaddingPKCS1, plain, plainLen, cipher, &cipherLen);

            if (returnCode != 0)
            {
                NSLog(@"SecKeyEncrypt fail. Error Code: %ld", returnCode);
            }
            else
            {
                result = [NSData dataWithBytes:cipher length:cipherLen];
            }
            
            free(cipher);
        }
        
        free(plain);
    }
    
    return result;
}

- (NSData *)encryptWithString:(NSString *)content
{
    return [self encryptWithData:[content dataUsingEncoding:NSUTF8StringEncoding]];
}

@end
