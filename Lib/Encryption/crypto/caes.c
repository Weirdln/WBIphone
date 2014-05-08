#include "caes.h"

//enum KeySize { Bits128, Bits192, Bits256 };  // key size, in bits, for construtor
typedef unsigned char   u1byte; /* an 8 bit unsigned character type */
typedef unsigned short  u2byte; /* a 16 bit unsigned integer type   */
typedef unsigned long   u4byte; /* a 32 bit unsigned integer type   */
typedef signed char     s1byte; /* an 8 bit signed character type   */
typedef signed short    s2byte; /* a 16 bit signed integer type     */
typedef signed long     s4byte; /* a 32 bit signed integer type     */
/* 2. Standard interface for AES cryptographic routines             */
/* These are all based on 32 bit unsigned values and may require    */
/* endian conversion for big-endian architectures                   */
#ifndef LITTLE_ENDIAN
#define LITTLE_ENDIAN
#endif

/* 3. Basic macros for speeding up generic operations               */
/* Circular rotate of 32 bit values                                 */
#define rotr(x,n)   (((x) >> ((int)(n))) | ((x) << (32 - (int)(n))))
#define rotl(x,n)   (((x) << ((int)(n))) | ((x) >> (32 - (int)(n))))
/* Invert byte order in a 32 bit variable                           */
#define bswap(x)    (rotl(x, 8) & 0x00ff00ff | rotr(x, 8) & 0xff00ff00)
/* Extract byte from a 32 bit quantity (little endian notation)     */
#define byte(x,n)   ((u1byte)((x) >> (8 * n)))
/* Input or output a 32 bit word in machine order     */
#ifdef LITTLE_ENDIAN
#define u4byte_in(x)  (*(u4byte*)(x))
#define u4byte_out(x, v) (*(u4byte*)(x) = (v))
#else
#define u4byte_in(x)  bswap(*(u4byte)(x))
#define u4byte_out(x, v) (*(u4byte*)(x) = bswap(v))
#endif

#define LARGE_TABLES

#define ff_mult(_t,a,b) (a && b ? (_t)->pow_tab [( (_t)->log_tab[a] + (_t)->log_tab[b]) % 255] : 0)

#define f_rn(_t,bo,bi,n,k)					\
    bo[n] =  (_t)->ft_tab[0][byte(bi[n],0)] ^			\
	(_t)->ft_tab[1][byte(bi[(n + 1) & 3],1)] ^		\
	(_t)->ft_tab[2][byte(bi[(n + 2) & 3],2)] ^		\
	(_t)->ft_tab[3][byte(bi[(n + 3) & 3],3)] ^ *(k + n)

#define i_rn(_t,bo,bi,n,k)					\
    bo[n] =  (_t)->it_tab[0][byte(bi[n],0)] ^			\
	(_t)->it_tab[1][byte(bi[(n + 3) & 3],1)] ^		\
	(_t)->it_tab[2][byte(bi[(n + 2) & 3],2)] ^		\
	(_t)->it_tab[3][byte(bi[(n + 1) & 3],3)] ^ *(k + n)

#ifdef LARGE_TABLES

#define ls_box(_t,x)						\
    ( (_t)->fl_tab[0][byte(x, 0)] ^				\
	(_t)->fl_tab[1][byte(x, 1)] ^				\
	(_t)->fl_tab[2][byte(x, 2)] ^				\
	(_t)->fl_tab[3][byte(x, 3)] )

#define f_rl(_t,bo,bi,n,k)					\
    bo[n] = (_t)->fl_tab[0][byte(bi[n],0)] ^			\
	(_t)->fl_tab[1][byte(bi[(n + 1) & 3],1)] ^		\
	(_t)->fl_tab[2][byte(bi[(n + 2) & 3],2)] ^		\
	(_t)->fl_tab[3][byte(bi[(n + 3) & 3],3)] ^ *(k + n)

#define i_rl(_t,bo,bi,n,k)					\
    bo[n] =  (_t)->il_tab[0][byte(bi[n],0)] ^			\
	(_t)->il_tab[1][byte(bi[(n + 3) & 3],1)] ^		\
	(_t)->il_tab[2][byte(bi[(n + 2) & 3],2)] ^		\
	(_t)->il_tab[3][byte(bi[(n + 1) & 3],3)] ^ *(k + n)

#else

#define ls_box(_t,x)						\
    ((u4byte) (_t)->sbx_tab[byte(x, 0)] <<  0) ^		\
    ((u4byte) (_t)->sbx_tab[byte(x, 1)] <<  8) ^		\
    ((u4byte) (_t)->sbx_tab[byte(x, 2)] << 16) ^		\
    ((u4byte) (_t)->sbx_tab[byte(x, 3)] << 24)

#define f_rl(_t,bo,bi,n,k)							\
    bo[n] = (u4byte) (_t)->sbx_tab[byte(bi[n],0)] ^				\
	rotl(((u4byte) (_t)->sbx_tab[byte(bi[(n + 1) & 3],1)]),  8) ^		\
	rotl(((u4byte) (_t)->sbx_tab[byte(bi[(n + 2) & 3],2)]), 16) ^		\
	rotl(((u4byte) (_t)->sbx_tab[byte(bi[(n + 3) & 3],3)]), 24) ^ *(k + n)

#define i_rl(_t,bo,bi,n,k)							\
    bo[n] = (u4byte) (_t)->isb_tab[byte(bi[n],0)] ^				\
	rotl(((u4byte) (_t)->isb_tab[byte(bi[(n + 3) & 3],1)]),  8) ^		\
	rotl(((u4byte) (_t)->isb_tab[byte(bi[(n + 2) & 3],2)]), 16) ^		\
	rotl(((u4byte) (_t)->isb_tab[byte(bi[(n + 1) & 3],3)]), 24) ^ *(k + n)

#endif

#define star_x(x) (((x) & 0x7f7f7f7f) << 1) ^ ((((x) & 0x80808080) >> 7) * 0x1b)

#define imix_col(y,x)			\
    u   = star_x(x);			\
    v   = star_x(u);			\
    w   = star_x(v);			\
    t   = w ^ (x);			\
	(y)  = u ^ v ^ w;		\
	(y) ^= rotr (u ^ t,  8) ^	\
	rotr (v ^ t, 16) ^		\
	rotr (t, 24)

typedef struct tables {
	u1byte  pow_tab [256];
	u1byte  log_tab [256];
	u1byte  sbx_tab [256];
	u1byte  isb_tab [256];
	u4byte  rco_tab [10];
	u4byte  ft_tab [4][256];
	u4byte  it_tab [4][256];
#ifdef  LARGE_TABLES
	u4byte  fl_tab[4][256];
	u4byte  il_tab[4][256];
#endif
	u4byte  tab_gen;
	
} tables_t;

static int tables_init (tables_t *tab)
{
	tab->tab_gen = 0;
	return 1;
}

static int tables_gen_tabs (tables_t *tab)
{   
	u4byte  i, t;
	u1byte  p, q;
	// log and power tables for GF(2**8) finite field with 
	// 0x011b as modular polynomial - the simplest prmitive
	// root is 0x03, used here to generate the tables      
	for(i = 0,p = 1; i < 256; ++i)
	{
		tab->pow_tab [i] = (u1byte)p;
		tab->log_tab [p] = (u1byte)i;
		p = p ^ (p << 1) ^ (p & 0x80 ? 0x01b : 0);
	}
	tab->log_tab [1] = 0; 
	p = 1;
	for(i = 0; i < 10; ++i)
	{
		tab->rco_tab [i] = p;
		p = (p << 1) ^ (p & 0x80 ? 0x1b : 0);
	}
	for(i = 0; i < 256; ++i)
	{  
		p = (i ? tab->pow_tab [255 - tab->log_tab [i]] : 0); q = p;
		q = (q >> 7) | (q << 1); p ^= q;
		q = (q >> 7) | (q << 1); p ^= q;
		q = (q >> 7) | (q << 1); p ^= q;
		q = (q >> 7) | (q << 1); p ^= q ^ 0x63;
		tab->sbx_tab [i] = p;
		tab->isb_tab [p] = (u1byte)i;
	}
	for(i = 0; i < 256; ++i)
	{
		p = tab->sbx_tab [i];
#ifdef  LARGE_TABLES       

		t = p; tab->fl_tab[0][i] = t;
		tab->fl_tab[1][i] = rotl (t,  8);
		tab->fl_tab[2][i] = rotl (t, 16);
		tab->fl_tab[3][i] = rotl (t, 24);
#endif
		t = ((u4byte)ff_mult (tab, 2, p)) |
			((u4byte)p <<  8) |
			((u4byte)p << 16) |
			((u4byte)ff_mult (tab, 3, p) << 24);

		tab->ft_tab [0][i] = t;
		tab->ft_tab [1][i] = rotl (t,  8);
		tab->ft_tab [2][i] = rotl (t, 16);
		tab->ft_tab [3][i] = rotl (t, 24);
		p = tab->isb_tab [i];
#ifdef  LARGE_TABLES       

		t = p; tab->il_tab[0][i] = t;
		tab->il_tab[1][i] = rotl (t,  8);
		tab->il_tab[2][i] = rotl (t, 16);
		tab->il_tab[3][i] = rotl (t, 24);
#endif
		t = ((u4byte)ff_mult (tab, 14, p)) |
			((u4byte)ff_mult (tab, 9, p) <<  8) |
			((u4byte)ff_mult (tab, 13, p) << 16) |
			((u4byte)ff_mult (tab, 11, p) << 24);

		tab->it_tab[0][i] = t;
		tab->it_tab[1][i] = rotl (t,  8);
		tab->it_tab[2][i] = rotl (t, 16);
		tab->it_tab[3][i] = rotl (t, 24);
	}
	tab->tab_gen = 1;
	return 1;
}

typedef struct rijndael {
	tables_t tab;
	u4byte  k_len;
	u4byte  e_key [64];
	u4byte  d_key [64];
} rijndael_t;

// initialise the key schedule from the user supplied key  
#define loop4(_r,_t,i)						\
{   t = ls_box (_t, rotr (t, 8)) ^ (_t)->rco_tab [i];		\
    t ^= (_r)->e_key [4 * i];     (_r)->e_key [4 * i + 4] = t;	\
    t ^= (_r)->e_key [4 * i + 1]; (_r)->e_key [4 * i + 5] = t;	\
    t ^= (_r)->e_key [4 * i + 2]; (_r)->e_key [4 * i + 6] = t;	\
    t ^= (_r)->e_key [4 * i + 3]; (_r)->e_key [4 * i + 7] = t;	\
}

#define loop6(_r,_t,i)						\
{   t = ls_box (_t, rotr (t, 8)) ^ (_t)->rco_tab [i];		\
    t ^= (_r)->e_key [6 * i];     (_r)->e_key [6 * i + 6] = t;	\
    t ^= (_r)->e_key [6 * i + 1]; (_r)->e_key [6 * i + 7] = t;	\
    t ^= (_r)->e_key [6 * i + 2]; (_r)->e_key [6 * i + 8] = t;	\
    t ^= (_r)->e_key [6 * i + 3]; (_r)->e_key [6 * i + 9] = t;	\
    t ^= (_r)->e_key [6 * i + 4]; (_r)->e_key [6 * i + 10] = t;	\
    t ^= (_r)->e_key [6 * i + 5]; (_r)->e_key [6 * i + 11] = t;	\
}

#define loop8(_r,_t,i)						\
{   t = ls_box (_t, rotr (t, 8)) ^ (_t)->rco_tab [i];		\
    t ^= (_r)->e_key [8 * i];     (_r)->e_key [8 * i + 8] = t;	\
    t ^= (_r)->e_key [8 * i + 1]; (_r)->e_key [8 * i + 9] = t;	\
    t ^= (_r)->e_key [8 * i + 2]; (_r)->e_key [8 * i + 10] = t;	\
    t ^= (_r)->e_key [8 * i + 3]; (_r)->e_key [8 * i + 11] = t;	\
    t  = (_r)->e_key [8 * i + 4] ^ ls_box (_t, t);		\
    (_r)->e_key [8 * i + 12] = t;				\
    t ^= (_r)->e_key [8 * i + 5]; (_r)->e_key [8 * i + 13] = t;	\
    t ^= (_r)->e_key [8 * i + 6]; (_r)->e_key [8 * i + 14] = t;	\
    t ^= (_r)->e_key [8 * i + 7]; (_r)->e_key [8 * i + 15] = t;	\
}

static int rijndael_set_key (rijndael_t *rij, const u1byte in_key[], const u4byte key_len)
{   
	u4byte  i, t, u, v, w;

	if (!rij->tab.tab_gen)
		tables_gen_tabs (&rij->tab);

	rij->k_len = (key_len + 31) / 32;
	rij->e_key [0] = u4byte_in (in_key     );
	rij->e_key [1] = u4byte_in (in_key +  4);
	rij->e_key [2] = u4byte_in (in_key +  8);
	rij->e_key [3] = u4byte_in (in_key + 12);

	switch (rij->k_len) {
	case 4: 
		t = rij->e_key[3];
		for(i = 0; i < 10; ++i)
			loop4 (rij, &rij->tab, i);
		break;
	case 6: 
		rij->e_key[4] = u4byte_in(in_key + 16); t = rij->e_key[5] = u4byte_in(in_key + 20);
		for(i = 0; i < 8; ++i)
			loop6 (rij, &rij->tab, i);
		break;
	case 8: 
		rij->e_key[4] = u4byte_in(in_key + 16); rij->e_key[5] = u4byte_in(in_key + 20);
		rij->e_key[6] = u4byte_in(in_key + 24); t = rij->e_key[7] = u4byte_in(in_key + 28);
		for(i = 0; i < 7; ++i)
			loop8 (rij, &rij->tab, i);
		break;
	}

	rij->d_key[0] = rij->e_key[0]; rij->d_key[1] = rij->e_key[1];
	rij->d_key[2] = rij->e_key[2]; rij->d_key[3] = rij->e_key[3];

	for(i = 4; i < 4 * rij->k_len + 24; ++i) {
		imix_col (rij->d_key[i], rij->e_key[i]);
	}
	return 1;
}

// encrypt a block of text 
#define f_nround(_t,bo,bi,k)		\
	f_rn (_t, bo, bi, 0, k);	\
	f_rn (_t, bo, bi, 1, k);	\
	f_rn (_t, bo, bi, 2, k);	\
	f_rn (_t, bo, bi, 3, k);	\
	k += 4

#define f_lround(_t,bo,bi,k)		\
	f_rl (_t, bo, bi, 0, k);	\
	f_rl (_t, bo, bi, 1, k);	\
	f_rl (_t, bo, bi, 2, k);	\
	f_rl (_t, bo, bi, 3, k)

static int rijndael_encrypt (rijndael_t *rij, const u1byte in_blk[16], u1byte out_blk[16])
{   
	u4byte  b0[4], b1[4], *kp;
	b0[0] = u4byte_in(in_blk    ) ^ rij->e_key[0]; b0[1] = u4byte_in(in_blk +  4) ^ rij->e_key[1];
	b0[2] = u4byte_in(in_blk + 8) ^ rij->e_key[2]; b0[3] = u4byte_in(in_blk + 12) ^ rij->e_key[3];
	kp = rij->e_key + 4;
	if (rij->k_len > 6) {
		f_nround (&rij->tab, b1, b0, kp);
		f_nround (&rij->tab, b0, b1, kp);
	}
	if (rij->k_len > 4) {
		f_nround (&rij->tab, b1, b0, kp);
		f_nround (&rij->tab, b0, b1, kp);
	}
	f_nround (&rij->tab, b1, b0, kp); f_nround (&rij->tab, b0, b1, kp);
	f_nround (&rij->tab, b1, b0, kp); f_nround (&rij->tab, b0, b1, kp);
	f_nround (&rij->tab, b1, b0, kp); f_nround (&rij->tab, b0, b1, kp);
	f_nround (&rij->tab, b1, b0, kp); f_nround (&rij->tab, b0, b1, kp);
	f_nround (&rij->tab, b1, b0, kp); f_lround (&rij->tab, b0, b1, kp);
	u4byte_out (out_blk,      b0[0]); u4byte_out (out_blk +  4, b0[1]);
	u4byte_out (out_blk +  8, b0[2]); u4byte_out (out_blk + 12, b0[3]);
	return 1;
}

// decrypt a block of text 
#define i_nround(_t,bo,bi,k)		\
	i_rn (_t, bo, bi, 0, k);	\
	i_rn (_t, bo, bi, 1, k);	\
	i_rn (_t, bo, bi, 2, k);	\
	i_rn (_t, bo, bi, 3, k);	\
	k -= 4

#define i_lround(_t,bo,bi,k)		\
	i_rl (_t, bo, bi, 0, k);	\
	i_rl (_t, bo, bi, 1, k);	\
	i_rl (_t, bo, bi, 2, k);	\
	i_rl (_t, bo, bi, 3, k)

static void rijndael_decrypt (rijndael_t *rij, const u1byte in_blk[16], u1byte out_blk[16])
{
	u4byte  b0[4], b1[4], *kp;
	b0[0] = u4byte_in(in_blk     ) ^ rij->e_key[4 * rij->k_len + 24];
	b0[1] = u4byte_in(in_blk +  4) ^ rij->e_key[4 * rij->k_len + 25];
	b0[2] = u4byte_in(in_blk +  8) ^ rij->e_key[4 * rij->k_len + 26];
	b0[3] = u4byte_in(in_blk + 12) ^ rij->e_key[4 * rij->k_len + 27];
	kp = rij->d_key + 4 * (rij->k_len + 5);
	if(rij->k_len > 6)
	{
		i_nround (&rij->tab, b1, b0, kp); i_nround (&rij->tab, b0, b1, kp);
	}
	if(rij->k_len > 4)
	{
		i_nround (&rij->tab, b1, b0, kp); i_nround (&rij->tab, b0, b1, kp);
	}

	i_nround (&rij->tab, b1, b0, kp); i_nround (&rij->tab, b0, b1, kp);
	i_nround (&rij->tab, b1, b0, kp); i_nround (&rij->tab, b0, b1, kp);
	i_nround (&rij->tab, b1, b0, kp); i_nround (&rij->tab, b0, b1, kp);
	i_nround (&rij->tab, b1, b0, kp); i_nround (&rij->tab, b0, b1, kp);
	i_nround (&rij->tab, b1, b0, kp); i_lround (&rij->tab, b0, b1, kp);
	u4byte_out(out_blk,     b0[0]); u4byte_out(out_blk +  4, b0[1]);
	u4byte_out(out_blk + 8, b0[2]); u4byte_out(out_blk + 12, b0[3]);
}

unsigned long enc_aes (unsigned char* content, unsigned long len, unsigned char* key, unsigned long klen, unsigned char* encrypted_content)
{
	unsigned long i = 0;
	rijndael_t rij;

	tables_init (&rij.tab);

	if (len / 16 * 16 != len)
		return 0;

	rijndael_set_key (&rij, key, klen * 8);

	for (i = 0; i < len; i+=16)
		rijndael_encrypt (&rij, content + i, encrypted_content + i);

	return len;
}

unsigned long dec_aes (unsigned char* encrypted_content, unsigned long len, unsigned char* key, unsigned long klen, unsigned char* decrypted_content)
{
	unsigned long i = 0;
	rijndael_t rij;

	tables_init (&rij.tab);

	if (len / 16 * 16 != len)
		return 0;

	rijndael_set_key (&rij, key, klen * 8);

	for (i = 0; i < len; i+=16)
		rijndael_decrypt (&rij, encrypted_content + i, decrypted_content + i);

	return len;
}
