//
//  generator24.hpp
//  TwentyFourPoints
//
//  Created by LegitMichel777 on 2021/3/5.
//

#ifndef generator24_hpp
#define generator24_hpp

#include <stdio.h>

struct myString {
    char* data;
    int sz;
};

struct problem24 {
    int c1,c2,c3,c4;
    struct myString res;
};

#ifdef __cplusplus
extern "C" {
#endif
struct myString solve24(int a,int b,int c,int d);
struct problem24 generateProblem(int upperBound);
#ifdef __cplusplus
}
#endif

#endif /* generator24_hpp */
