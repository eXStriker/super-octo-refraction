#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdarg.h>

const struct {
  unsigned char byte;
  const char * compressed;
} huffman_data[] = {
  // not the most efficient way of storing this, but it hardly matters
  {0x44, "10100100"},
  {0x45, "00000111001000"},
  {0x46, "00000111001001"},
  {0x47, "1010011110010"},
  {0x48, "1010011110011"},
  {0x49, "000101111"},
  {0x4A, "00101101"},
  {0x4B, "1010011110000110"},
  {0x4D, "1010011110000111"},
  {0x4E, "101001111000010"},
  {0x4F, "011110"},
  {0x50, "011100110000"},
  {0x51, "0000000"},
  {0x52, "10100111100011"},
  {0x53, "000100110101111"},
  {0x54, "0000011100101"},
  {0x55, "0101010"},
  {0x56, "10100111100010"},
  {0x57, "101001101"},
  {0x58, "000001110011"},
  {0x59, "00010100"},
  {0x5A, "01101100"},
  {0x5B, "011100110001"},
  {0x75, "10100111100000"},
  {0x7F, "100"},
  {0x80, "101011"},
  {0x81, "00010010"},
  {0x82, "01101101"},
  {0x83, "11100000"},
  {0x84, "000101110"},
  {0x85, "01010011"},
  {0x86, "011000010"},
  {0x87, "0110001"},
  {0x88, "0111010"},
  {0x89, "00010011001"},
  {0x8A, "00010011000"},
  {0x8B, "11000111"},
  {0x8C, "00010101"},
  {0x8D, "000001111"},
  {0x8E, "0111011"},
  {0x8F, "11100001"},
  {0x90, "0001001101010"},
  {0x91, "011100100"},
  {0x92, "0101000"},
  {0x93, "001010"},
  {0x94, "011100111"},
  {0x95, "00000111000"},
  {0x96, "0110111"},
  {0x97, "0001001101011011"},
  {0x98, "011100101"},
  {0x99, "000100110101110"},
  {0x9A, "1010000"},
  {0x9B, "1010001"},
  {0x9C, "01110001"},
  {0x9D, "00101111"},
  {0x9E, "011000011"},
  {0x9F, "011100000"},
  {0xA0, "1101"},
  {0xA1, "0101011"},
  {0xA2, "011001"},
  {0xA3, "11001"},
  {0xA4, "0011"},
  {0xA5, "110000"},
  {0xA6, "111001"},
  {0xA7, "01001"},
  {0xA8, "00011"},
  {0xA9, "1010011100"},
  {0xAA, "01010010"},
  {0xAB, "11101"},
  {0xAC, "011111"},
  {0xAD, "00100"},
  {0xAE, "00001"},
  {0xAF, "0001000"},
  {0xB0, "00010110011"},
  {0xB1, "01011"},
  {0xB2, "01000"},
  {0xB3, "1011"},
  {0xB4, "011010"},
  {0xB5, "00000110"},
  {0xB6, "101010"},
  {0xB7, "1010011101"},
  {0xB8, "0000010"},
  {0xB9, "00010011011"},
  {0xD0, "11000110"},
  {0xD1, "011100001"},
  {0xD2, "00101100"},
  {0xD3, "00101110"},
  {0xD4, "1100010"},
  {0xD5, "101001100"},
  {0xD6, "01100000"},
  {0xDA, "00010011010110100"},
  {0xE3, "0000001"},
  {0xE6, "10100101"},
  {0xE7, "1110001"},
  {0xE8, "11110"},
  {0xE9, "000100111"},
  {0xF3, "0000011101"},
  {0xF4, "11111"},
  {0xF6, "0001011000"},
  {0xF7, "0001011010"},
  {0xF8, "0111001101"},
  {0xF9, "00010110010"},
  {0xFA, "10100111111"},
  {0xFB, "0001011011"},
  {0xFC, "000100110100"},
  {0xFD, "10100111101"},
  {0xFE, "10100111110"},
  {0xFF, "01110011001"},
  {0, ""}
};

const char * special_16_header = "00010011010110101";
const char * special_64_header = "000100110101100";

const unsigned char special_16_bytes[] = {0x4C, 0xD7, 0xD8, 0xD9, 0xE4, 0xE5, 0xEA, 0xEB, 0xEC, 0xED, 0xEE, 0xEF, 0xF0, 0xF1, 0xF2, 0xF5};

const struct {
  unsigned char count;
  unsigned char offset;
  unsigned char accumulated;
} special_64_ranges[] = {
  {0x19, 0x5C, 0x00},
  {0x09, 0x76, 0x19},
  {0x16, 0xBA, 0x22},
  {0x08, 0xDB, 0x38}
};

const struct {
  unsigned char value;
  const char * label;
} text_commands[] = {
  {0x4C, "scroll"},
  {0x4E, "next"},
  {0x4F, "line"},
  {0x51, "para"},
  {0x55, "cont"},
  {0x56, "sdone"},
  {0x57, "done"},
  {0x58, "prompt"},
  {0x5F, "nl"},
  {0, "db"},
  {0, NULL}
};

const unsigned char text_terminators[] = {0x50, 0x56, 0x57, 0x58, 0};

struct charmap_entry {
  unsigned char value;
  char string[];
};

int main(int, char **);
void error_exit(const char *, ...);
int find_unquoted_character(const char *, char);
char * duplicate_string(const char *);
char * trim_string(char *);
char ** extract_components_from_line(const char *);
void destroy_component_array(char **);
struct charmap_entry ** generate_charmap_from_file(FILE *, unsigned *);
int convert_string_to_number(const char *);
struct charmap_entry * create_charmap_entry_from_line(const char *);
void add_dummy_charmap_entries(struct charmap_entry ***, unsigned *, const char *);
int compare_charmap_entries(const void *, const void *);
void filter_duplicate_charmap_entries(struct charmap_entry ***, unsigned *);
char * read_line(FILE *);
unsigned char process_line(const char *, unsigned, unsigned char, struct charmap_entry **, unsigned, char **);
unsigned char get_next_character_from_string(char **, struct charmap_entry **, unsigned);
unsigned char generate_compressed_line(char **, unsigned char, int, unsigned char, struct charmap_entry **, unsigned, unsigned, char **);
unsigned char compress(const unsigned char *, unsigned, unsigned char, unsigned char **, unsigned *);
void process_next_byte(unsigned char, unsigned *);

int main (int argc, char ** argv) {
  if (argc != 4) {
    fprintf(stderr, "usage: %s <charmap.asm> <input> <output>\n", *argv);
    return 2;
  }
  FILE * fp = fopen(argv[1], "r");
  if (!fp) error_exit("could not read charmap file %s", argv[1]);
  unsigned charmap_length;
  struct charmap_entry ** charmap = generate_charmap_from_file(fp, &charmap_length);
  fclose(fp);
  char * line;
  char ** output_lines = NULL;
  unsigned output_count = 0;
  unsigned char mode = 0;
  unsigned current = 0;
  fp = fopen(argv[2], "r");
  if (!fp) error_exit("could not open file %s for reading", argv[2]);
  while (!feof(fp)) {
    line = read_line(fp);
    output_lines = realloc(output_lines, sizeof(char *) * (++ output_count));
    mode = process_line(line, ++ current, mode, charmap, charmap_length, output_lines + (output_count - 1));
    free(line);
  }
  fclose(fp);
  output_lines = realloc(output_lines, sizeof(char *) * (output_count + 1));
  output_lines[output_count] = NULL;
  fp = fopen(argv[3], "w");
  if (!fp) error_exit("could not open file %s for writing", argv[3]);
  for (current = 0; current < output_count; current ++) fprintf(fp, "%s\n", output_lines[current]);
  fclose(fp);
  destroy_component_array(output_lines);
  for (current = 0; current < charmap_length; current ++) free(charmap[current]);
  free(charmap);
  return 0;
}

void error_exit (const char * error, ...) {
  va_list ap;
  fprintf(stderr, "error: ");
  va_start(ap, error);
  vfprintf(stderr, error, ap);
  va_end(ap);
  putc('\n', stderr);
  exit(1);
}

int find_unquoted_character (const char * string, char character) {
  unsigned char in_quotes = 0;
  unsigned pos;
  const char * p;
  for (p = string, pos = 0; *p; p ++, pos ++) {
    if (*p == '"') {
      in_quotes ^= 1;
      continue;
    }
    if (in_quotes) continue;
    if (*p == character) return pos;
  }
  if (in_quotes) error_exit("mismatched quotes in string: %s", string);
  return -1;
}

char * duplicate_string (const char * string) {
  return strcpy(malloc(strlen(string) + 1), string);
}

char * trim_string (char * string) {
  while ((*string == ' ') || (*string == '\t')) string ++;
  unsigned effective_length = strlen(string);
  while (effective_length && ((string[effective_length - 1] == ' ') || (string[effective_length - 1] == '\t'))) effective_length --;
  char * result = malloc(effective_length + 1);
  memcpy(result, string, effective_length);
  result[effective_length] = 0;
  return result;
}

char ** extract_components_from_line (const char * line) {
  char * copy = duplicate_string(line);
  int pos = find_unquoted_character(copy, ';');
  if (pos >= 0) copy[pos] = 0;
  char * current = copy + strspn(copy, " \t");
  if ((!*current) || (current == copy)) {
    free(copy);
    return NULL;
  }
  pos = strcspn(current, " \t");
  char ** result;
  if (!current[pos]) {
    result = malloc(sizeof(char *) * 2);
    *result = duplicate_string(current);
    result[1] = NULL;
    return result;
  }
  result = malloc(sizeof(char *));
  current[pos] = 0;
  *result = duplicate_string(current);
  current += pos + 1;
  unsigned components = 1;
  char * component;
  while (pos >= 0) {
    pos = find_unquoted_character(current, ',');
    if (pos >= 0) current[pos] = 0;
    component = trim_string(current);
    if (pos >= 0) current += pos + 1;
    if (*component) {
      result = realloc(result, sizeof(char *) * (components + 1));
      result[components ++] = component;
    } else
      free(component);
  }
  result = realloc(result, sizeof(char *) * (components + 1));
  result[components] = NULL;
  return result;
}

void destroy_component_array (char ** array) {
  char ** current;
  for (current = array; *current; current ++) free(*current);
  free(array);
}

struct charmap_entry ** generate_charmap_from_file (FILE * fp, unsigned * count) {
  struct charmap_entry ** charmap = NULL;
  *count = 0;
  struct charmap_entry * entry;
  char * line;
  while (!feof(fp)) {
    line = read_line(fp);
    entry = create_charmap_entry_from_line(line);
    free(line);
    if (!entry) continue;
    charmap = realloc(charmap, sizeof(struct charmap_entry *) * (*count + 1));
    charmap[(*count) ++] = entry;
    if (strlen(entry -> string) > 1) add_dummy_charmap_entries(&charmap, count, entry -> string);
  }
  qsort(charmap, *count, sizeof(struct charmap_entry *), &compare_charmap_entries);
  filter_duplicate_charmap_entries(&charmap, count);
  charmap = realloc(charmap, sizeof(struct charmap_entry *) * (*count + 1));
  charmap[*count] = NULL;
  return charmap;
}

int convert_string_to_number (const char * string) {
  unsigned base = 10;
  switch (*string) {
    case 0:
      return 0x80000000;
    case '$':
      string ++;
      base = 16;
      break;
    case '%':
      string ++;
      base = 2;
  }
  char * error;
  long long result = strtoll(string, &error, base);
  if (*error) return 0x80000000;
  if ((result < -32768) || (result > 65535)) return 0x80000000;
  result &= 0xFFFF;
  if (result & 0x8000) result |= ~0xFFFF;
  return result;
}

struct charmap_entry * create_charmap_entry_from_line (const char * line) {
  char ** components = extract_components_from_line(line);
  if (!components) return NULL;
  struct charmap_entry * entry = NULL;
  if (strcmp(*components, "charmap")) goto done;
  if (!(components[1] && components[2]) || components[3]) goto done;
  if ((*(components[1]) != '"') || (components[1][strlen(components[1]) - 1] != '"')) goto done;
  int value = convert_string_to_number(components[2]);
  if ((value < -128) || (value > 255)) error_exit("invalid charmap entry for %s", components[1]);
  unsigned length = strlen(components[1]) - 2;
  entry = malloc(sizeof(struct charmap_entry) + length + 1);
  entry -> value = value;
  memcpy(entry -> string, components[1] + 1, length);
  entry -> string[length] = 0;
  done:
  destroy_component_array(components);
  return entry;
}

void add_dummy_charmap_entries (struct charmap_entry *** charmap, unsigned * count, const char * string) {
  struct charmap_entry * entry;
  unsigned length;
  for (length = strlen(string) - 1; length; length --) {
    entry = malloc(sizeof(struct charmap_entry) + length + 1);
    entry -> value = 0;
    memcpy(entry -> string, string, length);
    entry -> string[length] = 0;
    *charmap = realloc(*charmap, sizeof(struct charmap_entry *) * (*count + 1));
    (*charmap)[(*count) ++] = entry;
  }
}

int compare_charmap_entries (const void * first, const void * second) {
  struct charmap_entry ** entry1 = (struct charmap_entry **) first;
  struct charmap_entry ** entry2 = (struct charmap_entry **) second;
  return strcmp((**entry1).string, (**entry2).string);
}

void filter_duplicate_charmap_entries (struct charmap_entry *** charmap, unsigned * count) {
  unsigned pos = 0;
  unsigned char new_value;
  while ((*count > 1) && (pos <= (*count - 2)))
    if (strcmp(pos[*charmap] -> string, (pos + 1)[*charmap] -> string))
      pos ++;
    else {
      new_value = pos[*charmap] -> value ? pos[*charmap] -> value : (*charmap)[pos + 1] -> value;
      free(pos[*charmap]);
      memmove(*charmap + pos, *charmap + (pos + 1), ((-- (*count)) - pos) * sizeof(struct charmap_entry *));
      pos[*charmap] -> value = new_value;
    }
}

char * read_line (FILE * fp) {
  char * result = NULL;
  unsigned length = 0;
  int c;
  while (1) {
    c = getc(fp);
    if ((c == '\n') || (c == EOF)) break;
    result = realloc(result, length + 1);
    result[length ++] = c;
  }
  result = realloc(result, length + 1);
  result[length] = 0;
  return result;
}

unsigned char process_line (const char * line, unsigned number, unsigned char mode, struct charmap_entry ** charmap, unsigned charmap_length, char ** result) {
  char ** components = extract_components_from_line(line);
  if (!components) {
    *result = duplicate_string(line);
    return mode;
  }
  unsigned p;
  if (mode) {
    for (p = 0; text_commands[p].label; p ++) if (!strcmp(text_commands[p].label, *components)) break;
    if (!text_commands[p].label) error_exit("unknown text command at line %u: %s", number, *components);
    mode = generate_compressed_line(components + 1, mode, 0, text_commands[p].value, charmap, charmap_length, number, result);
    destroy_component_array(components);
    return mode;
  }
  if (!strcmp(*components, "ctxt"))
    mode = 1;
  else if (!strcmp(*components, "ct"))
    mode = 0;
  else {
    destroy_component_array(components);
    *result = duplicate_string(line);
    return 0;
  }
  mode = generate_compressed_line(components + 1, 1, mode, 0, charmap, charmap_length, number, result);
  destroy_component_array(components);
  return mode;
}

unsigned char get_next_character_from_string (char ** string, struct charmap_entry ** charmap, unsigned charmap_length) {
  unsigned current_length;
  unsigned found_length = 0;;
  unsigned char found_value = 0;
  struct charmap_entry * test_entry;
  struct charmap_entry ** found;
  for (current_length = 1; ; current_length ++) {
    test_entry = malloc(sizeof(struct charmap_entry) + current_length + 1);
    memcpy(test_entry -> string, *string, current_length);
    test_entry -> string[current_length] = 0;
    found = bsearch(&test_entry, charmap, charmap_length, sizeof(struct charmap_entry *), &compare_charmap_entries);
    free(test_entry);
    if (!found) break;
    if ((**found).value) {
      found_length = current_length;
      found_value = (**found).value;
    }
  }
  *string += found_length;
  return found_value;
}

unsigned char generate_compressed_line (char ** components, unsigned char mode, int compressed_flag, unsigned char line_type, struct charmap_entry ** charmap,
                                        unsigned charmap_length, unsigned line_number, char ** result) {
  unsigned buffer_length;
  unsigned char * buffer;
  int value;
  char * current;
  unsigned char character;
  if (line_type) {
    buffer = malloc(1);
    *buffer = line_type;
    buffer_length = 1;
  } else {
    buffer = NULL;
    buffer_length = 0;
  }
  for (; *components; components ++)
    if (**components == '"') {
      current = *components + 1;
      while (*current != '"') {
        character = get_next_character_from_string(&current, charmap, charmap_length);
        if (!character) error_exit("unknown character in string at line %u: %s", line_number, *components);
        buffer = realloc(buffer, buffer_length + 1);
        buffer[buffer_length ++] = character;
      }
      if (current[1]) error_exit("invalid argument at line %u: %s", line_number, *components);
    } else {
      value = convert_string_to_number(*components);
      if ((value < -128) || (value > 255)) error_exit("invalid argument at line %u: %s", line_number, *components);
      buffer = realloc(buffer, buffer_length + 1);
      buffer[buffer_length ++] = value;
    }
  unsigned char * compressed;
  unsigned compressed_length;
  mode = compress(buffer, buffer_length, mode, &compressed, &compressed_length);
  for (value = 0; value < buffer_length; value ++)
    if (strchr(text_terminators, buffer[value])) {
      if (mode > 1) {
        while (mode < 0x80) mode <<= 1;
        mode <<= 1;
        compressed = realloc(compressed, compressed_length + 1);
        compressed[compressed_length ++] = mode;
      }
      mode = 0;
      break;
    }
  free(buffer);
  *result = malloc(20 + 5 * compressed_length);
  strcpy(*result, compressed_flag ? "\tdb TX_COMPRESSED" : "\tdb ");
  current = *result + strlen(*result);
  // reusing a variable
  for (buffer_length = 0; buffer_length < compressed_length; buffer_length ++) {
    value = sprintf(current, "%s$%02hhx", (buffer_length || compressed_flag) ? ", " : "", compressed[buffer_length]);
    current += value;
  }
  *current = 0;
  free(compressed);
  return mode;
}

unsigned char compress (const unsigned char * buffer, unsigned length, unsigned char mode, unsigned char ** result, unsigned * result_length) {
  *result = NULL;
  *result_length = 0;
  unsigned extended_mode = mode;
  unsigned char bits;
  for (; length; buffer ++, length --) {
    process_next_byte(*buffer, &extended_mode);
    for (bits = 0; extended_mode >= (2 << bits); bits ++);
    while (bits >= 8) {
      bits -= 8;
      *result = realloc(*result, *result_length + 1);
      (*result)[(*result_length) ++] = extended_mode >> bits;
    }
    extended_mode &= (1 << bits) - 1;
    extended_mode |= 1 << bits;
  }
  return extended_mode;
}

void process_next_byte (unsigned char byte, unsigned * extended_mode) {
  if (byte < 0x44) error_exit("encountered 0x%02hhX byte while processing", byte);
  unsigned p;
  const char * string;
  unsigned char append, append_count;
  for (p = 0; huffman_data[p].byte; p ++) if (byte == huffman_data[p].byte) {
    string = huffman_data[p].compressed;
    append_count = 0;
    goto found;
  }
  for (p = 0; p < 16; p ++) if (byte == special_16_bytes[p]) {
    string = special_16_header;
    append = p;
    append_count = 4;
    goto found;
  }
  for (p = 0; p < 4; p ++) if ((byte >= special_64_ranges[p].offset) && (byte < (special_64_ranges[p].offset + special_64_ranges[p].count))) {
    string = special_64_header;
    append_count = 6;
    append = special_64_ranges[p].accumulated + (byte - special_64_ranges[p].offset);
    goto found;
  }
  error_exit("internal error while compressing byte 0x%02hhX", byte);
  found:
  while (*string) {
    *extended_mode <<= 1;
    if (*string == '1') *extended_mode |= 1;
    string ++;
  }
  for (p = append_count - 1; p < append_count; p --) *extended_mode = (*extended_mode << 1) | ((append >> p) & 1);
}
