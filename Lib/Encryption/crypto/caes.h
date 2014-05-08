#ifndef _AES_H
#define _AES_H

//aes, 待加密和待解密字符串的长度必须是  16字节 的整数倍
unsigned long enc_aes(unsigned char* content, unsigned long len, unsigned char* key, unsigned long klen, unsigned char* encrypted_content);
unsigned long dec_aes(unsigned char* encrypted_content, unsigned long len, unsigned char* key, unsigned long klen, unsigned char* decrypted_content);

#endif