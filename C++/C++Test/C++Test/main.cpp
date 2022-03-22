//
//  main.cpp
//  C++Test
//
//  Created by FSKJ on 2022/2/15.
//

#include <iostream>

using namespace std;

// 类型别名
typedef bool BOOL;

// 枚举
enum Color {
	red,
	yellow
};
// 结构体
struct Books {
    string title;
    string name;
    string id;
};

// 定义变量
extern int a, b;

static int j = 10;
void test() {
	// auto 自动推断类型
//    auto f = 1.1;
//    auto s = "hello"; // const char*
//    auto z = new auto(9); // int*
//    cout << f << " " << sizeof(f) << endl;
//    cout << s << " " << sizeof(s) << endl;
//    cout << z << " " << sizeof(z) << endl;

	// static
	static int i = 5;
	i++;
	cout << "i: " << i << endl;
	cout << "count: " << j << endl;
}

int dd;
extern void write_extern();

void arraytest() {
    int* p = new int[1];
    for (int i = 0; i < 10; i ++) {
        p[i] = i;
        cout << p[i] << endl;
    }
    delete [] p;
}

void stringtest() {
    string str1 = "hello";
    string str2 = "world";
    string str3;
    
    // 复制
    str3 = str1;
    cout << "str3: " << str3 << endl;
    
    // 连接
    str3 = str1 + str2;
    cout << "str1 + str2 : " << str3 << endl;
    cout << "len : " << str3.size() << endl;
    
}
// 指针
void pointer_test() {
    int var = 20;
    int *ip = NULL;
    
    cout << ip << endl;
    
    ip = &var;
    
    cout << var << endl;
    cout << ip << endl;
    cout << *ip << endl;
    
    int varint[3] = {1,2,3};
    int *ptr[3];
    for (int i = 0; i < 3; i ++) {
        cout << "&varint[i]: " << &varint[i] << endl;
        ptr[i] = &varint[i];
    }
    for (int i = 0; i < 3; i ++) {
        cout << *ptr[i] << endl;
    }
    
    // 指针的指针
    int t;
    int *pt;
    int **ppt;
    
    t = 1;
    
    pt = &t;
    ppt = &pt;
    
    cout << t << endl;
    cout << *pt << endl;
    cout << **ppt << endl;
    
    string name;
    cout << "请输入名称";
    cin >> name;
    cout << "name: " << name << endl;
    cerr << "error";
}

extern void box();

void constTest() {
    int a = 1, b = 3;
    int * const c = &a;
//    c = &b;
    *c = 3;
    
    cout << *c << endl;
    a = 2;
    cout << *c << endl;
    
    int const *d = &a;
    
//    *d = 4;
    d = &b;
    cout << *d << endl;
    
//    const int *d = &a;
//    cout << d << endl;
    
}

// 主函数
/*
   主函数
 */
int main(int argc, const char * argv[]) {
    constTest();
//    arraytest();
//    stringtest();
//    pointer_test();
//    Books book1;
//    book1.title = "book1";
//    cout << book1.name << endl;
//    box();
    return 0;

	// 随机数
	/*
	   要取得 [a,b) 的随机整数，使用 (rand() % (b-a))+ a;
	   要取得 [a,b] 的随机整数，使用 (rand() % (b-a+1))+ a;
	   要取得 (a,b] 的随机整数，使用 (rand() % (b-a))+ a + 1;
	   通用公式: a + rand() % n；其中的 a 是起始值，n 是整数的范围。
	   要取得 a 到 b 之间的随机整数，另一种表示：a + (int)b * rand() / (RAND_MAX + 1)。
	   要取得 0～1 之间的浮点数，可以使用 rand() / double(RAND_MAX)。

	 */
	int z = 1, h = 5;
	for (int i = 0; i < 10; i++) {
		int j = (rand() % (z - h)) + z;
		cout << "随机数：" << j << endl;
	}
	return 0;

	// 匿名函数
	// [capture](parameters)->return-type{body}
	auto func = [] (int x, int y) -> int {
			    int z = x + y; return z + x;
		    };
	cout << func(1, 2);


	dd = 4;
	write_extern();


//    while (j > 0) {
//        j --;
//        test();
//    }

	// 变量
	int a = 1;
	int b = 2;
	cout << a << b << endl;
	// 常量
    #define T 10
	const int WIDTH = 10;
	cout << WIDTH << endl;
	cout << T << endl;

	// 修饰符
	short int i; // 有符合
	short unsigned int j; // 无符号
	i = 50000;
	j = 50000;
	cout << i << " " << j << endl;

	std::cout << "Hello, World!\n";


	cout << "enum: \t\t" << "所占字节数：" << sizeof(Color) << endl;

	cout << "bool: \t\t" << "所占字节数：" << sizeof(BOOL);
	cout << "\t最大值：" << (numeric_limits<bool>::max)();
	cout << "\t\t最小值：" << (numeric_limits<bool>::min)() << endl;
	cout << "char: \t\t" << "所占字节数：" << sizeof(char);
	cout << "\t最大值：" << (numeric_limits<char>::max)();
	cout << "\t\t最小值：" << (numeric_limits<char>::min)() << endl;
	cout << "signed char: \t" << "所占字节数：" << sizeof(signed char);
	cout << "\t最大值：" << (numeric_limits<signed char>::max)();
	cout << "\t\t最小值：" << (numeric_limits<signed char>::min)() << endl;
	cout << "unsigned char: \t" << "所占字节数：" << sizeof(unsigned char);
	cout << "\t最大值：" << (numeric_limits<unsigned char>::max)();
	cout << "\t\t最小值：" << (numeric_limits<unsigned char>::min)() << endl;
	cout << "wchar_t: \t" << "所占字节数：" << sizeof(wchar_t);
	cout << "\t最大值：" << (numeric_limits<wchar_t>::max)();
	cout << "\t\t最小值：" << (numeric_limits<wchar_t>::min)() << endl;
	cout << "short: \t\t" << "所占字节数：" << sizeof(short);
	cout << "\t最大值：" << (numeric_limits<short>::max)();
	cout << "\t\t最小值：" << (numeric_limits<short>::min)() << endl;
	cout << "int: \t\t" << "所占字节数：" << sizeof(int);
	cout << "\t最大值：" << (numeric_limits<int>::max)();
	cout << "\t最小值：" << (numeric_limits<int>::min)() << endl;
	cout << "unsigned: \t" << "所占字节数：" << sizeof(unsigned);
	cout << "\t最大值：" << (numeric_limits<unsigned>::max)();
	cout << "\t最小值：" << (numeric_limits<unsigned>::min)() << endl;
	cout << "long: \t\t" << "所占字节数：" << sizeof(long);
	cout << "\t最大值：" << (numeric_limits<long>::max)();
	cout << "\t最小值：" << (numeric_limits<long>::min)() << endl;
	cout << "unsigned long: \t" << "所占字节数：" << sizeof(unsigned long);
	cout << "\t最大值：" << (numeric_limits<unsigned long>::max)();
	cout << "\t最小值：" << (numeric_limits<unsigned long>::min)() << endl;
	cout << "double: \t" << "所占字节数：" << sizeof(double);
	cout << "\t最大值：" << (numeric_limits<double>::max)();
	cout << "\t最小值：" << (numeric_limits<double>::min)() << endl;
	cout << "long double: \t" << "所占字节数：" << sizeof(long double);
	cout << "\t最大值：" << (numeric_limits<long double>::max)();
	cout << "\t最小值：" << (numeric_limits<long double>::min)() << endl;
	cout << "float: \t\t" << "所占字节数：" << sizeof(float);
	cout << "\t最大值：" << (numeric_limits<float>::max)();
	cout << "\t最小值：" << (numeric_limits<float>::min)() << endl;
	cout << "size_t: \t" << "所占字节数：" << sizeof(size_t);
	cout << "\t最大值：" << (numeric_limits<size_t>::max)();
	cout << "\t最小值：" << (numeric_limits<size_t>::min)() << endl;
	cout << "string: \t" << "所占字节数：" << sizeof(string) << endl;
	// << "\t最大值：" << (numeric_limits<string>::max)() << "\t最小值：" << (numeric_limits<string>::min)() << endl;
	cout << "type: \t\t" << "************size**************"<< endl;

	return 0;
}

