//
//  RSAEncrypt.m
//  DZHLotteryTicket
//
//  Created by Weirdln on 13-12-3.
//  Copyright (c) 2013年 Weirdln. All rights reserved.
//

#import "RSAEncryption.h"
#import "NSString+Base64.h"
#import "NSData+Base64.h"


#define BUFFSIZE  1024


@interface RSAEncryption ()
+ (int)getBlockSizeWithRSA_PADDING_TYPE:(RSA *)_rsa paddingType:(RSA_PADDING_TYPE)padding_type;
+ (NSArray *)seperateStringByLen:(NSString *)content len:(int)len;

@end

@implementation RSAEncryption

+ (NSArray *)seperateStringByLen:(NSString *)content len:(int)len
{
    NSArray *retVal = nil;
    if (len > 0)
    {
        int cntLen  = [content length];
        int offset  = cntLen % len == 0 ? 0 : 1;
        int count   = cntLen / len + offset;
        
        NSMutableArray *keyArr = [NSMutableArray array];
        
        if (cntLen / len > 0)
        {
            for (int i = 0; i < count; i++)
            {
                [keyArr addObject:[[content substringFromIndex:i * len] substringToIndex:MIN(len, cntLen-i*len)]];
            }
            
            retVal = keyArr;
        }
        else
            retVal  = [NSArray arrayWithObjects:content, nil];
    }
    
    return retVal;
}

+ (RSA *)importRSAKeyWithType:(KeyType)type keyFilePath:(NSString *)keyFilePath
{
    FILE *file;
    RSA *_rsa;
    file = fopen([keyFilePath UTF8String], "rb");
    
    if (NULL != file)
    {
        if (type == KeyTypePublic)
        {
            _rsa = PEM_read_RSA_PUBKEY(file, NULL, NULL, NULL);
            assert(_rsa != NULL);
        }
        else
        {
            _rsa = PEM_read_RSAPrivateKey(file, NULL, NULL, NULL);
            assert(_rsa != NULL);
        }
        
        fclose(file);
        
        return _rsa;
    }
    
    return NULL;
}

+ (BOOL)savePublicKeyPEM:(NSString *)keyContent filePath:(NSString *)filePath
{
    BOOL bRet = NO;
    NSArray *keyArr = [[self class] seperateStringByLen:keyContent len:64];
    
    if (keyArr)
    {
        NSString *publicKeyStr = @"-----BEGIN PUBLIC KEY-----\n";
        for (int i = 0; i < [keyArr count]; i++)
        {
            publicKeyStr = [publicKeyStr stringByAppendingString:[NSString stringWithFormat:@"%@\n", [keyArr objectAtIndex:i]]];
        }
        publicKeyStr = [publicKeyStr stringByAppendingString:@"-----END PUBLIC KEY-----"];
        
        bRet = [publicKeyStr writeToFile:filePath atomically:YES encoding:NSASCIIStringEncoding error:nil];
    }
    
    return bRet;
}

+ (BOOL)savePrivateKeyPEM:(NSString *)keyContent filePath:(NSString *)filePath
{
    BOOL bRet = NO;
    NSArray *keyArr = [[self class] seperateStringByLen:keyContent len:64];
    
    if (keyArr)
    {
        NSString *publicKeyStr = @"-----BEGIN ENCRYPTED PRIVATE KEY-----\n";
        for (int i = 0; i < [keyArr count]; i++)
        {
            publicKeyStr = [publicKeyStr stringByAppendingString:[NSString stringWithFormat:@"%@\n", [keyArr objectAtIndex:i]]];
        }
        publicKeyStr = [publicKeyStr stringByAppendingString:@"-----END ENCRYPTED PRIVATE KEY-----"];
        
        bRet = [publicKeyStr writeToFile:filePath atomically:YES encoding:NSASCIIStringEncoding error:nil];
    }
    
    return bRet;
}

+ (BOOL)saveKeyPEMCert:(NSString *)keyContent filePath:(NSString *)filePath
{
    BOOL bRet = [keyContent writeToFile:filePath atomically:YES encoding:NSASCIIStringEncoding error:nil];
    return bRet;
}

+ (NSData *)encryptByRsa:(NSString*)content withKeyType:(KeyType)keyType keyFilePath:(NSString *)keyFilePath paddingType:(RSA_PADDING_TYPE)paddingType
{
    RSA *_rsa = [[self class] importRSAKeyWithType:keyType keyFilePath:keyFilePath];
    if (!_rsa)
        return nil;
    NSData *bRetVal = nil;
    
    int status;
    int length  = [content length];
    unsigned char input[length + 1];
    bzero(input, length + 1);
    int i = 0;
    for (; i < length; i++)
    {
        input[i] = [content characterAtIndex:i];
    }
    
    NSInteger flen = [[self class] getBlockSizeWithRSA_PADDING_TYPE:_rsa paddingType:paddingType];
    
    char *encData = (char*)malloc(flen);
    bzero(encData, flen);
    
    switch (keyType) {
        case KeyTypePublic:
            status = RSA_public_encrypt(length, (unsigned char*)input, (unsigned char*)encData, _rsa, paddingType);
            break;
            
        default:
            status = RSA_private_encrypt(length, (unsigned char*)input, (unsigned char*)encData, _rsa, paddingType);
            break;
    }
    
    if (status)
    {
        bRetVal = [NSData dataWithBytes:encData length:status];
//        bRetVal = [returnData base64EncodedString];
    }
    
    free(encData);
    encData = NULL;
    
    RSA_free(_rsa);
    _rsa = NULL;
    
    return bRetVal;
}

+ (NSData *)decryptByRsa:(NSString*)content withKeyType:(KeyType)keyType keyFilePath:(NSString *)keyFilePath paddingType:(RSA_PADDING_TYPE)paddingType
{
    RSA *_rsa = [[self class] importRSAKeyWithType:keyType keyFilePath:keyFilePath];
    if (!_rsa)
        return nil;
    
    NSData *bRetVal = nil;
    
    int status;
    
    NSData *data = [content base64DecodedData];
    int length = [data length];
    
    NSInteger flen = [[self class] getBlockSizeWithRSA_PADDING_TYPE:_rsa paddingType:paddingType];
    char *decData = (char*)malloc(flen);
    bzero(decData, flen);
    
    switch (keyType) {
        case KeyTypePublic:
            status = RSA_public_decrypt(length, (unsigned char*)[data bytes], (unsigned char*)decData, _rsa, paddingType);
            break;
            
        default:
            status = RSA_private_decrypt(length, (unsigned char*)[data bytes], (unsigned char*)decData, _rsa, paddingType);
            break;
    }
    
    if (status)
    {
        //        [NSString stringWithCString:decData encoding:NSASCIIStringEncoding];
        bRetVal = [NSData dataWithBytes:decData length:strlen(decData)];
    }
    
    free(decData);
    decData = NULL;
    
    RSA_free(_rsa);
    _rsa = NULL;
    
    return bRetVal;
}

+ (NSString *)makeBase64EncryptByRsa:(NSString*)content withKeyType:(KeyType)keyType keyFilePath:(NSString *)keyFilePath paddingType:(RSA_PADDING_TYPE)paddingType
{
    NSData *retVal = [[self class] encryptByRsa:content withKeyType:keyType keyFilePath:keyFilePath paddingType:paddingType];
    return [retVal base64EncodedString];
}

+ (NSString *)makeBase64DecryptByRsa:(NSString*)content withKeyType:(KeyType)keyType keyFilePath:(NSString *)keyFilePath paddingType:(RSA_PADDING_TYPE)paddingType
{
    NSData *retVal = [[self class] decryptByRsa:content withKeyType:keyType keyFilePath:keyFilePath paddingType:paddingType];
    return [retVal base64EncodedString];
}

+ (int)getBlockSizeWithRSA_PADDING_TYPE:(RSA *)_rsa paddingType:(RSA_PADDING_TYPE)padding_type
{
    int len = RSA_size(_rsa);
    
    if (padding_type == RSA_PADDING_TYPE_PKCS1 || padding_type == RSA_PADDING_TYPE_SSLV23) {
        len -= 11;
    }
    
    return len;
}

/*
 + (NSString *)encryptDataWithPublicKeyPath:(NSString *)publicKeyPath content:(NSData *)content
 {
 NSString *base64Str = nil;
 
 FILE *publicKeyFile;
 RSA *_rsa;
 publicKeyFile = fopen([publicKeyPath cStringUsingEncoding:NSASCIIStringEncoding], "rb");
 
 if (NULL != publicKeyFile) {
 const char *publicKeyFileName = [publicKeyPath cStringUsingEncoding:NSASCIIStringEncoding];
 BIO *bpubKey = NULL;
 bpubKey = BIO_new(BIO_s_file());
 BIO_read_filename(bpubKey, publicKeyFileName);
 _rsa = PEM_read_bio_RSA_PUBKEY(bpubKey, NULL, NULL, NULL); //PEM_read_RSAPublicKey(file,NULL, NULL, NULL);
 
 char *InBuff = (char *)[content bytes];
 
 //encrypt with public key
 int flen = RSA_size(_rsa);
 char *encData =  (char *)malloc(flen);
 bzero(encData, flen);
 
 //encrypt
 int status =  RSA_public_encrypt(flen,
 (unsigned char*)InBuff,
 (unsigned char*)encData,
 _rsa,
 RSA_NO_PADDING);
 
 if (status) {
 NSData *data = [NSData dataWithBytes:encData length:status];
 base64Str = [data base64Encoding];
 }
 
 BIO_free_all(bpubKey);
 }
 
 return base64Str;
 }
 + (NSString *)encryptDataWithRSAPublicKey:(NSData *)publicKeyData content:(NSData *)content
 {
 NSString *base64Str = nil;
 if (publicKeyData)
 {
 NSString *astr = [[NSString alloc] initWithData:publicKeyData encoding:NSUTF8StringEncoding];
 char *pkey = (char *)[publicKeyData bytes];
 char *InBuff = (char *)[content bytes];
 //        RSA *_rsa = RSA_generate_key(512, RSA_F4,NULL,NULL);
 int len = strlen(pkey);
 RSA *_rsa = d2i_RSAPublicKey(NULL, (const unsigned char**)&pkey, [publicKeyData length]);
 
 //encrypt with public key
 int flen = RSA_size(_rsa);
 char *encData =  (char *)malloc(flen);
 bzero(encData, flen);
 
 //encrypt
 int status =  RSA_public_encrypt(flen,
 (unsigned char*)InBuff,
 (unsigned char*)encData,
 _rsa,
 RSA_NO_PADDING);
 
 if (status) {
 NSData *data = [NSData dataWithBytes:encData length:status];
 base64Str = [data base64Encoding];
 }
 }
 
 return base64Str;
 }
 
 + (NSData *)decryptDataWithRSAPrivateKey:(NSData *)privateKeyData content:(NSData *)content
 {
 return nil;
 }
 
 + (NSString *)RSAEncryptDataWithPublicKey:(NSData *)publicKeyData
 {
 unsigned char InBuff[64], OutBuff[64];
 memset(InBuff, 0, sizeof(InBuff));
 memset(OutBuff, 0, sizeof(OutBuff));
 //    unsigned char *tmpInput = "As23432sfgdsfgkk89011bnn6yuhb3jd";
 strcpy((char *)InBuff, "As23432sfgdsfgkk89011bnn6yuhb3jd");
 RSA *_rsa = RSA_generate_key(1024, RSA_F4,NULL,NULL);
 
 
 //encrypt with public key
 int flen = RSA_size(_rsa);
 char *encData =  (char *)malloc(flen);
 bzero(encData, flen);
 
 //encrypt
 int status =  RSA_public_encrypt(flen,
 (unsigned char*)InBuff,
 (unsigned char*)encData,
 _rsa,
 RSA_NO_PADDING);
 
 if (status) {
 NSData *data = [NSData dataWithBytes:encData length:status];
 NSString *base64Str = [data base64Encoding];
 NSLog(@"base64Str:%@", base64Str);
 
 
 flen = RSA_size(_rsa);
 char *decData =  (char *)malloc(flen);
 bzero(decData, flen);
 
 //decrypt
 status =  RSA_public_decrypt(flen,
 (unsigned char*)[data bytes],
 (unsigned char*)decData,
 _rsa,
 RSA_NO_PADDING);
 if (status) {
 NSLog(@"\n ------------\ndecData is %s\n---------------\n",decData);
 
 }else
 NSLog(@"----error RSA_public_decrypt");
 
 free(decData);
 encData = NULL;
 }else
 NSLog(@"----error RSA_private_encrypt");
 
 free(encData);
 encData = NULL;
 return nil;
 
 // 1. 产生RSA密钥对
 // 产生512字节公钥指数为RSA_F4的密钥对，公钥指数有RSA_F4和RSA_3两种
 RSA *ClientRsa = RSA_generate_key(512, RSA_F4, NULL, NULL);
 //
 //    // 2. 从RSA结构中提取公钥到BUFF，以便将它传输给对方
 //    // 512位的RSA其公钥提出出来长度是74字节，而私钥提取出来有超过300字节
 //    // 为保险起见，建议给它们预留一个512字节的空间
 //    unsigned char PublicKey[512];
 //    unsigned char *PKey = PublicKey; // 注意这个指针不是多余，是特意要这样做的，
 unsigned char *pkey = (unsigned char *)[publicKeyData bytes];
 unsigned char *tmpK = (unsigned char *)[publicKeyData bytes];
 int publicKeyLen = i2d_RSAPublicKey(ClientRsa, &tmpK);
 
 RSA *EncryptRsa = d2i_RSAPublicKey(NULL, (const unsigned char**)&pkey, publicKeyLen);
 //    unsigned char Seed[32]; // 可以采用Rand()等方法来构造随机信息
 unsigned char *Seed = "As23432sfgdsfgkk89011bnn6yuhb3jd";
 
 NSString *strAESSeed = [NSString stringWithFormat:@"%s", Seed];
 
 strcpy((char *)InBuff, "As23432sfgdsfgkk89011bnn6yuhb3jd");
 RSA_public_encrypt(64, (const unsigned char*)InBuff, OutBuff, EncryptRsa, RSA_PKCS1_PADDING); // 加密
 NSString *strRSAEncryptAESKey = [NSString stringWithUTF8String:OutBuff];
 
 //    AES_KEY AESEncryptKey, AESDecryptKey;
 //    AES_set_encrypt_key(Seed, 256, &AESEncryptKey);
 //    AES_set_decrypt_key(Seed, 256, &AESDecryptKey);
 
 
 return nil;
 }
 
 + (void)test
 {
 // 1. 产生RSA密钥对
 // 产生512字节公钥指数为RSA_F4的密钥对，公钥指数有RSA_F4和RSA_3两种
 // 我不清楚它们的区别，就随便选定RSA_F4
 // 可以使用RSA_print_fp()看看RSA里面的东西
 RSA *ClientRsa = RSA_generate_key(512, RSA_F4, NULL, NULL);
 
 // ---------
 // 2. 从RSA结构中提取公钥到BUFF，以便将它传输给对方
 // 512位的RSA其公钥提出出来长度是74字节，而私钥提取出来有超过300字节
 // 为保险起见，建议给它们预留一个512字节的空间
 unsigned char PublicKey[512];
 unsigned char *PKey = PublicKey; // 注意这个指针不是多余，是特意要这样做的，
 int PublicKeyLen = i2d_RSAPublicKey(ClientRsa, &PKey);
 
 // 不能采用下面的方法，因为i2d_RSAPublicKey()会修改PublicKey的值
 // 所以要引入PKey，让它作为替死鬼
 // unsigned char *PublicKey = (unsigned char *)malloc(512);
 // int PublicKeyLen = i2d_RSAPublicKey(ClientRsa, &PublicKey);
 NSData *keyData = [NSData dataWithBytes:PublicKey length:PublicKeyLen];
 NSLog(@"keyData:%d", keyData.length);
 
 // 逐个字节打印PublicKey信息
 printf("PublicKeyBuff, Len=%d\n", PublicKeyLen);
 for (int i=0; i<PublicKeyLen; i++)
 {
 printf("0x%02x, ", *(PublicKey+i));
 }
 printf("\n");
 
 
 // ---------
 // 3. 跟据上面提出的公钥信息PublicKey构造一个新RSA密钥(这个密钥结构只有公钥信息)
 PKey = PublicKey;
 RSA *EncryptRsa = d2i_RSAPublicKey(NULL, (const unsigned char**)&PKey, PublicKeyLen);
 
 // ---------
 // 4. 使用EncryptRsa加密数据，再使用ClientRsa解密数据
 // 注意, RSA加密/解密的数据长度是有限制，例如512位的RSA就只能最多能加密解密64字节的数据
 // 如果采用RSA_NO_PADDING加密方式，512位的RSA就只能加密长度等于64的数据
 // 这个长度可以使用RSA_size()来获得
 unsigned char InBuff[64], OutBuff[64];
 
 strcpy((char *)InBuff, "1234567890abcdefghiklmnopqrstuvwxyz.");
 RSA_public_encrypt(64, (const unsigned char*)InBuff, OutBuff, EncryptRsa, RSA_NO_PADDING); // 加密
 
 memset(InBuff, 0, sizeof(InBuff));
 RSA_private_decrypt(64, (const unsigned char*)OutBuff, InBuff, ClientRsa, RSA_NO_PADDING); // 解密
 printf("RSADecrypt OK: %s \n", InBuff);
 
 
 // ----------
 // 5. 利用随机32字节Seed来产生256位的AES密钥对
 unsigned char Seed[32]; // 可以采用Rand()等方法来构造随机信息
 AES_KEY AESEncryptKey, AESDecryptKey;
 AES_set_encrypt_key(Seed, 256, &AESEncryptKey);
 AES_set_decrypt_key(Seed, 256, &AESDecryptKey);
 
 // ----------
 // 6. 使用AES密钥对来加密/解密数据
 // 注意，256位的AES密钥只能加密/解密16字节长的数据
 strcpy((char *)InBuff, "a1b2c3d4e5f6g7h8?");
 AES_encrypt(InBuff, OutBuff, &AESEncryptKey);
 
 memset(InBuff, 0, sizeof(InBuff));
 AES_decrypt(OutBuff, InBuff, &AESDecryptKey);
 printf("AESDecrypt OK: %s \n", InBuff);
 
 
 // ----------
 // 7. 谨记要释放RSA结构
 RSA_free(ClientRsa);
 RSA_free(EncryptRsa);
 }
 */
@end
