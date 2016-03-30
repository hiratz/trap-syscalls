#ifndef SYSTRAP_PRIVATE_H_
#define SYSTRAP_PRIVATE_H_

extern int debug_level __attribute__((visibility("hidden")));
extern int sleep_for_seconds __attribute__((visibility("hidden")));
extern int stop_self __attribute__((visibility("hidden")));
extern int self_pid __attribute__((visibility("hidden")));

#ifdef SYSTRAP_DEFINE_FILE
struct _IO_FILE;
typedef struct _IO_FILE FILE;
#endif
extern FILE *stderr;
extern FILE **p_err_stream;

extern char *getenv (const char *__name) __THROW __nonnull ((1)) __wur;
extern int atoi (const char *__nptr)
     __THROW __attribute_pure__ __nonnull ((1)) __wur;
/* avoid stdlib and stdio for sigset_t conflict reasons */
void *calloc(size_t, size_t);
void free(void*);
/* avoid stdio because of sigset_t conflict */
FILE *fdopen(int fd, const char *mode);
int fprintf(FILE *stream, const char *format, ...);
int vfprintf(FILE *stream, const char *format, va_list args);
int fflush(FILE *stream);

#define debug_printf(lvl, fmt, ...) do { \
    if ((lvl) <= debug_level) { \
      fprintf(*p_err_stream, fmt, ## __VA_ARGS__ ); \
      fflush(*p_err_stream); \
    } \
  } while (0)

#endif
