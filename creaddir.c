#include <assert.h>
#include <dirent.h>
#include <stdbool.h>
#include <stddef.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define HAVE_MAIN true
#define MAX_CARACTER_OF_FILE 180
#define MAX_BYTES_FILE_NAME sizeof(char) * MAX_CARACTER_OF_FILE

int count_files_dir(char *name_dir) {

  int files_count = 0;
  DIR *folder;
  struct dirent *entry;

  folder = opendir(name_dir);

  if (folder == NULL) {
    perror("Unable to read directory for count");
    return (-1);
  }

  while ((entry = readdir(folder))) {
    files_count++;
  }

  closedir(folder);

  return (files_count - 2); // remove from the count the . .. directories
}

int creaddir(char *name_dir, char ***files_arr_ret, int *size_of_dir_t) {

  DIR *folder;
  struct dirent *entry;
  int files_count = 0;
  int i = 0;
  char **files_arr = NULL;
  // char* tmp_str = NULL;

  files_count = count_files_dir(name_dir);

  assert(files_count > -1);

  if (files_count == 0)
    return -2;

  // not include . .. folders on list, that a ready have count on
  // count_files_dir()
  files_arr = (char **)calloc(sizeof(char **), files_count);

#if true
  for (i = 0; i < files_count; i++) {

    files_arr[i] = (char *)calloc(sizeof(char *), MAX_CARACTER_OF_FILE);
    // memset(files_arr_ret[i][0], 0, MAX_BYTES_FILE_NAME); // no need because
    // calloc
  }
#endif

  folder = opendir(name_dir);
  if (folder == NULL) {
    perror("Unable to read directory");
    return (1);
  }

  i = 0;
  while ((entry = readdir(folder))) {
    // tmp_str = strdup(entry->d_name);
    // printf("Type :: %c\n", entry->d_type);
    // printf("Type :: %ld\n", entry->d_off);
    if (entry->d_off > 2) { // ignore default linux directory [. ..]
      strcpy(files_arr[i], entry->d_name);
      i = i + 1;
    }
  }

  *files_arr_ret = files_arr;
  *size_of_dir_t = files_count;

  closedir(folder);

  return (0);
}

#if HAVE_MAIN
int main() {

  char **files_arr = NULL;
  // char *directory = "/bin";
  char *directory = "/home/synbian/git/clone/Odin/spawn-rune/test";

  int size_files = 0;
  int i = 0;

  creaddir(directory, &files_arr, &size_files);

#if true
  for (i = 0; i < size_files; i++) {

    printf("file(%d) : %s\n", i, files_arr[i]);
  }
#endif

  for (i = 0; i < size_files; i++) {
    free(files_arr[i]);
  }

  free(files_arr);
}
#endif
