//
//  RSAEncrypt.h
//  DZHLotteryTicket
//
//  Created by Weirdln on 13-12-3.
//  Copyright (c) 2013年 Weirdln. All rights reserved.
//

#include <openssl/rsa.h>
#include <openssl/pem.h>
#include <openssl/err.h>

typedef enum {
    KeyTypePublic,
    KeyTypePrivate
}KeyType;

typedef enum {
    RSA_PADDING_TYPE_NONE       = RSA_NO_PADDING,
    RSA_PADDING_TYPE_PKCS1      = RSA_PKCS1_PADDING,        // default
    RSA_PADDING_TYPE_SSLV23     = RSA_SSLV23_PADDING
}RSA_PADDING_TYPE;

@interface RSAEncryption : NSObject
+ (RSA *)importRSAKeyWithType:(KeyType)type keyFilePath:(NSString *)keyFilePath;
+ (BOOL)savePublicKeyPEM:(NSString *)keyContent filePath:(NSString *)filePath;
+ (BOOL)savePrivateKeyPEM:(NSString *)keyContent filePath:(NSString *)filePath;
+ (BOOL)saveKeyPEMCert:(NSString *)keyContent filePath:(NSString *)filePath;

+ (NSData *)encryptByRsa:(NSString*)content withKeyType:(KeyType)keyType keyFilePath:(NSString *)keyFilePath paddingType:(RSA_PADDING_TYPE)paddingType;
+ (NSData *)decryptByRsa:(NSString*)content withKeyType:(KeyType)keyType keyFilePath:(NSString *)keyFilePath paddingType:(RSA_PADDING_TYPE)paddingType;
+ (NSString *)makeBase64EncryptByRsa:(NSString*)content withKeyType:(KeyType)keyType keyFilePath:(NSString *)keyFilePath paddingType:(RSA_PADDING_TYPE)paddingType;
+ (NSString *)makeBase64DecryptByRsa:(NSString*)content withKeyType:(KeyType)keyType keyFilePath:(NSString *)keyFilePath paddingType:(RSA_PADDING_TYPE)paddingType;


@end
