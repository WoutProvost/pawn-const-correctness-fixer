#include <a_samp>

main() {
	new string[4 + 1];
	format(string, sizeof(string), "test");

	foo(string);
	bar(string);
	test(string, string);
	test2(string, string);
	test3(string, string);
}

foo(string[]) {
	print(string);
}

bar(string[]) {
	print(string);
}

test(string[], string2[]) {
	print(string);
	print(string2);
}

test2(const string[], string2[]) {
	print(string);
	print(string2);	
}

test3(string[], const string2[]) {
	print(string);
	print(string2);	
}