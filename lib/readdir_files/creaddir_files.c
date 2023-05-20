#include <assert.h>
#include <dirent.h>
#include <stdbool.h>
#include <stddef.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>

//
// this preserve program to be just a library
// when used build_c_test.sh need this HAVE_MAIN to be true
//
#define HAVE_MAIN false
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
    if (!(entry->d_type == DT_BLK) && (entry->d_off > 2)) {
      files_count++;
    }
  }

  closedir(folder);

  return files_count; // remove from the count the . .. directories
}

int creaddir_files(char *name_dir, char ***files_arr_ret, int *size_of_dir_t) {

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

#if false
    if (i == 3017) {
      // tmp_str = strdup(entry->d_name);
      printf("Type REG :: %d\n", entry->d_type == DT_REG);
      printf("Type :: %ld\n", entry->d_off);
      printf("name :#: %s\n", entry->d_name);
      printf("count :: %d", i);
    }
#endif
    if (!(entry->d_type == DT_DIR) &&
        (entry->d_off > 2)) { // ignore default linux directory [. ..]
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
  char *directory = "/bin";
  // char *directory =
  // "/home/synbian/git/clone/Odin/spawn-rune/readdir_files/test";

  int size_files = 0;
  int i = 0;

  creaddir_files(directory, &files_arr, &size_files);

#if true // to test performance of readding and free memory on C
  for (i = 0; i < size_files; i++) {

#if false
    if (strcmp("", files_arr[i]) == 0) {
      printf("|| %d", i);
      printf("%s\n", files_arr[i]);
      break;
    }
#endif
#if false
    if (i == 5017) {
      printf("|| %d", i);
      printf("%s\n", files_arr[i]);
      printf("---------\n");
    }
#endif
    // printf("file(%d) : %s\n", i, files_arr[i]);
    // if(files_arr[i] == NULL) continue;
    printf("%s\n", files_arr[i]);
  }
#endif

  // printf("# %d\n", size_files);

  for (i = 0; i < size_files; i++) {
    free(files_arr[i]);
  }

  free(files_arr);
}
#endif // HAVE_MAIN
