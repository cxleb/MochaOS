#ifndef device_h
#define device_h

struct device{

  char* name;
  size_t (*write) (char* buffer, size_t, size_t offset);
  size_t (*read) (char* buffer, size_t, size_t offset);

};

typedef device device_t;

#endif
