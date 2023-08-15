#include <stdio.h>

int main(void) {
	char* path2 = "../../../../../../../../../../.git/HEAD";
	FILE* f;
	for (char* path=&path2[10*3]; path>=path2; path-=3) {
		if ((f=fopen(path, "r"))) {
			char* p;
			fscanf(f, "%m[^\n]", &p);
			puts(p);
			return 0;
		}
	}
	return 1;
}
