#ifndef PLAT
#define PLAT
#ifdef __ANDROID__
    #define _PLAT  0
#elif __linux__
    #define _PLAT  1
#elif __unix__
    #define _PLAT  1
#elif _WIN32
   #define _PLAT  2
#endif
#endif // PLAT

