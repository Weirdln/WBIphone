//
//  AESCrypt.m
//  Gurpartap Singh
//
//  Created by Gurpartap Singh on 06/05/12.
//  Copyright (c) 2012 Gurpartap Singh
// 
// 	MIT License
// 
// 	Permission is hereby granted, free of charge, to any person obtaining
// 	a copy of this software and associated documentation files (the
// 	"Software"), to deal in the Software without restriction, including
// 	without limitation the rights to use, copy, modify, merge, publish,
// 	distribute, sublicense, and/or sell copies of the Software, and to
// 	permit persons to whom the Software is furnished to do so, subject to
// 	the following conditions:
// 
// 	The above copyright notice and this permission notice shall be
// 	included in all copies or substantial portions of the Software.
// 
// 	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
// 	EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
// 	MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
// 	NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
// 	LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
// 	OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
// 	WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#import "AESCrypt.h"
#import "NSData+Base64.h"
#import "NSString+Base64.h"
#import "NSData+CommonCrypto.h"
#import <CommonCrypto/CommonCrypto.h>

@implementation AESCrypt

+ (NSString *)generate32ByteAESKey
{
    NSString *randVal = @"";
    // 生成32位加密密钥
    NSArray *generateNumberList = [NSArray arrayWithObjects:@"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"a", @"b", @"c", @"d", @"e", @"f", @"g", @"h", @"i", @"j", @"k", @"l", @"m", @"n", @"o", @"p", @"q", @"r", @"s", @"t", @"u", @"v", @"w", @"x", @"y", @"z", @"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z", nil];
    
    for (int i = 0; i < 32; i++)
    {
//        time_t time1 = time(0) + i;
//        srand(time1);
        int idx = arc4random() % [generateNumberList count];
        randVal = [randVal stringByAppendingString:[generateNumberList objectAtIndex:idx]];
    }
    
    NSString *retVal = [randVal length] > 0 ? randVal : nil;
    return retVal;
}

+ (NSData *)encryptData:(NSString *)message password:(NSString *)password
{
    NSData *encryptedData = [[self class] encryptDataWithByteKey:message password:[password UTF8String]];
//    NSData *encryptedData = [[message dataUsingEncoding:NSUTF8StringEncoding] AES256EncryptedDataUsingKey:[[password dataUsingEncoding:NSUTF8StringEncoding] SHA256Hash] error:nil];
    
    return encryptedData;
}

+ (NSData *)encryptDataWithByteKey:(NSString *)message password:(const void *)password
{
    NSData *encryptedData = nil;
    //对于块加密算法，输出大小总是等于或小于输入大小加上一个块的大小
    //所以在下边需要再加上一个块的大小
    NSData *noEncryptedData = [message dataUsingEncoding:NSUTF8StringEncoding];
    NSUInteger dataLength = [noEncryptedData length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding/*这里就是刚才说到的PKCS7Padding填充了*/ | kCCOptionECBMode,
                                          password, kCCKeySizeAES128,
                                          NULL,/* 初始化向量(可选) */
                                          [noEncryptedData bytes], dataLength,/*输入*/
                                          buffer, bufferSize,/* 输出 */
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess)
    {
        encryptedData = [NSData dataWithBytes:buffer length:numBytesEncrypted];
    }
    free(buffer);//释放buffer
    return encryptedData;
}

+ (NSString *)encrypt:(NSString *)message password:(NSString *)password
{
  NSData *encryptedData = [[self class] encryptData:message password:password];
  NSString *base64EncodedString = [NSString base64StringFromData:encryptedData length:[encryptedData length]];
  return base64EncodedString;
}

+ (NSString *)encryptWithByteKey:(NSString *)message password:(const void *)password
{
    NSData *encryptedData = [[self class] encryptDataWithByteKey:message password:password];
    NSString *base64EncodedString = [NSString base64StringFromData:encryptedData length:[encryptedData length]];
    return base64EncodedString;
}

+ (NSString *)decrypt:(NSString *)base64EncodedString password:(NSString *)password
{
  NSData *encryptedData = [NSData dataFromBase64String:base64EncodedString];
  NSData *decryptedData = [[self class] decryptData:encryptedData password:password];
  return [[[NSString alloc] initWithData:decryptedData encoding:NSUTF8StringEncoding] autorelease];
}

+ (NSString *)decryptWithByteKey:(NSString *)base64EncodedString password:(const void *)password
{
    NSData *encryptedData = [NSData dataFromBase64String:base64EncodedString];
    NSData *decryptedData = [[self class] decryptDataWithByteKey:encryptedData password:password];
    return [[[NSString alloc] initWithData:decryptedData encoding:NSUTF8StringEncoding] autorelease];
}

+ (NSData *)decryptData:(NSData *)data password:(NSString *)password
{
    NSData *decryptData = [[self class] decryptDataWithByteKey:data password:[password UTF8String]];
    return decryptData;
}

+ (NSData *)decryptDataWithByteKey:(NSData *)data password:(const void *)password
{
    NSData *decryptData = nil;
    //同理，解密中，密钥也是32位的
    //对于块加密算法，输出大小总是等于或小于输入大小加上一个块的大小
    //所以在下边需要再加上一个块的大小
    if (password)
    {
        NSUInteger dataLength = [data length];
        size_t bufferSize = dataLength + kCCBlockSizeAES128;
        void *buffer = malloc(bufferSize);
        
        size_t numBytesDecrypted = 0;
        CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmAES128,
                                              kCCOptionPKCS7Padding/*这里就是刚才说到的PKCS7Padding填充了*/ | kCCOptionECBMode,
                                              password, kCCKeySizeAES128,
                                              NULL,/* 初始化向量(可选) */
                                              [data bytes], dataLength,/* 输入 */
                                              buffer, bufferSize,/* 输出 */
                                              &numBytesDecrypted);
        if (cryptStatus == kCCSuccess) {
            decryptData = [NSData dataWithBytes:buffer length:numBytesDecrypted];
        }
        free(buffer);
    }
    return decryptData;
}

@end
