/*
 *  DESEncryption.h
 *  Encryption
 *
 *  Created by donglg on 10-6-30.
 *  Copyright 2010 __DZH__. All rights reserved.
 *
 */

#ifndef _DES_H
#define _DES_H

#define SUCCESS 0
#define FAIL    1

#define DESENCRY 0
#define DESDECRY 1

#ifdef __cplusplus
extern "C"
{
#endif
	// Encryption
	int des(char *data, char *key,int readlen);
	// Decryption
	int Ddes(char *data,char *key,int readlen);
	
	int handle_data(unsigned long *left , int choice);
	int makedata(unsigned long  *left ,unsigned long  *right ,unsigned long number);
	int makefirstkey( unsigned long *keyP );
	int makekey(  unsigned long *keyleft,unsigned long *keyright ,unsigned long number);
	
	void InitIntArray(unsigned long buf[], int nSize);
	void InitIntArray2(unsigned long buf[][2], int nSize1, int nSize2);
	void copyFromIntArray(unsigned long toBuf[], unsigned long fromBuf[], int nSize);
	
#ifdef __cplusplus
};
#endif

#endif