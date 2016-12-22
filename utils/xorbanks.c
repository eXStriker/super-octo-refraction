#include <stdio.h>
#include <stdlib.h>

int main(int, char **);
void * create_bank_patch(const unsigned char *, const unsigned char *, unsigned short *);

int main (int argc, char ** argv) {
  if (argc != 4) {
    fprintf(stderr, "usage: %s <source ROM> <target ROM> <XOR patch>\n", *argv);
    return 1;
  }
  FILE * source = fopen(argv[1], "rb");
  FILE * target = fopen(argv[2], "rb");
  if (!(source && target)) {
    fprintf(stderr, "error: could not open ROMs for reading\n");
    return 1;
  }
  unsigned short * bank_lengths = NULL;
  void ** bank_patches = NULL;
  unsigned banks = 0;
  unsigned char source_buffer[16384], target_buffer[16384];
  int rv;
  while (1) {
    if (!(fread(source_buffer, 1, 16384, source) + fread(target_buffer, 1, 16384, target))) break;
    bank_patches = realloc(bank_patches, sizeof(void *) * (banks + 1));
    bank_lengths = realloc(bank_lengths, sizeof(unsigned short) * (banks + 1));
    bank_patches[banks] = create_bank_patch(source_buffer, target_buffer, bank_lengths + banks);
    banks ++;
  }
  fclose(source);
  fclose(target);
  FILE * patch = fopen(argv[3], "wb");
  if (!patch) {
    fprintf(stderr, "error: could not open %s for writing\n", argv[3]);
    return 1;
  }
  unsigned char length[2];
  unsigned bank;
  for (bank = 0; bank < banks; bank ++) {
    *length = bank_lengths[bank];
    length[1] = bank_lengths[bank] >> 8;
    if ((fwrite(length, 1, 2, patch) != 2)) {
      fprintf(stderr, "error: could not write to %s\n", argv[3]);
      return 1;
    }
    if (!bank_lengths[bank]) continue;
    if (fwrite(bank_patches[bank], 1, bank_lengths[bank], patch) != bank_lengths[bank]) {
      fprintf(stderr, "error: could not write to %s\n", argv[3]);
      return 1;
    }
  }
  fclose(patch);
  return 0;
}

void * create_bank_patch (const unsigned char * source, const unsigned char * target, unsigned short * length) {
  *length = 16384;
  while (*length && (target[*length - 1] == 0xff)) (*length) --;
  if (!*length) return NULL;
  unsigned char * result = malloc(*length);
  unsigned short pos;
  for (pos = 0; pos < *length; pos ++) result[pos] = source[pos] ^ target[pos];
  return result;
}
