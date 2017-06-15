#include <iostream>
using namespace std;

int phash(int key) {
    int i5 = 718264;
    int i6 = 884035;
    int i4 = i5 >> (i6 & 15);
    int i3 = i4 ^ i6;
    int i2 = i3 ^ i5;
    int i1 = key;
    int i0 = i1 >> (i2 & 15);
    return i0;
}


int main() {
	std::cout << phash(65906) << std::endl;  

std::cout << phash(85162) << std::endl;  

std::cout << phash(43530) << std::endl;  

std::cout << phash(77141) << std::endl;  

std::cout << phash(57633) << std::endl;  

std::cout << phash(93849) << std::endl;  

std::cout << phash(52260) << std::endl;  

std::cout << phash(15426) << std::endl;  
std::cout << phash(97824) << std::endl;  

std::cout << phash(7369)  << std::endl; 
std::cout << phash(48831) << std::endl;  

	return 0;
}
