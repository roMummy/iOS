//
//  support.cpp
//  C++Test
//
//  Created by FSKJ on 2022/2/16.
//

#include <iostream>
#include <vector>

using namespace std;

extern int dd;

void write_extern(void) {
    std::cout << "count is" << dd << std::endl;
}

class Box {
    // 默认是私有成员
    int age;
public:
    double length;
    double height;
    
    double get();
    void set(double len, double hei) {
        length = len;
        height = hei;
    }
    // 构造函数
    // Box(double len): length(len) 等于 length = len
    //
    Box(double len): length(len) {
        cout << "Box init" << endl;
        ptr = new int;
        *ptr = len;
    }
    Box () {}
    
    Box(const Box &obj) {
        cout << "拷贝对象" << endl;
        ptr = new int;
        *ptr = *obj.ptr; // 拷贝值
    }
    
    // 析构函数
    ~Box() {
        cout << "Box deinit" << endl;
        delete ptr;
    }
    
    Box operator+(const Box& b) {
        Box box;
        box.length = box.length + this->length;
        return box;
    }
    
private:
    int a;
    int b;
    int *ptr;
    
protected:
    int width;
};

double Box::get() {
    return length * height;
}

class SmallBox: public Box {
public:
    int getWidth() {
        return width;
    }
    SmallBox(double w):Box(10) {
        cout << "SmallBox init" << endl;
        width = w;
        cout << this->width << endl;
    }
    ~SmallBox() {
        cout << "SmallBox deinit" << endl;
    }
    
private:
    // 友元函数 可以访问私有变量
    friend void printWidth(SmallBox &box);
    // 友元类 可以访问私有变量
    friend class Test;
    
};
class Test {
public:
    Test(SmallBox &obj) {
        cout << "Test init - " << obj.width << endl;
    }
};

void printWidth(SmallBox &box) {
    cout << "width : " << box.width << endl;
}

class D
{
public:
    D(){cout<<"D()"<<endl;}
    ~D(){cout<<"~D()"<<endl;}
protected:
    int d;
};
// virtual 虚拟继承
class B:virtual public D
{
public:
    B(){cout<<"B()"<<endl;}
    ~B(){cout<<"~B()"<<endl;}
protected:
    int b;
};

class A:virtual public D
{
public:
    A(){cout<<"A()"<<endl;}
    ~A(){cout<<"~A()"<<endl;}
protected:
    int a;
};

class C:public B, public A
{
public:
    C(){cout<<"C()"<<endl;}
    ~C(){cout<<"~C()"<<endl;}
protected:
    int c;
};

// 泛型
template <typename  T>
inline T const& Max(T const& a, T const& b) {
    return  a < b ? b: a;
}

template <class E>
class Stack {
private:
    vector<E> elems;
public:
    void push(E const&);
    void pop();
    E top() const;
    bool empty() const {
        return elems.empty();
    }
};
template <class T>
void Stack<T>::push (T const& elem)
{
    // 追加传入元素的副本
    elems.push_back(elem);
    
}
template <class T>
void Stack<T>::pop ()
{
    if (elems.empty()) {
        throw out_of_range("Stack<>::pop(): empty stack");
    }
    // 删除最后一个元素
    elems.pop_back();
}
 
template <class T>
T Stack<T>::top () const
{
    if (elems.empty()) {
        throw out_of_range("Stack<>::top(): empty stack");
    }
    // 返回最后一个元素的副本
    return elems.back();
}


void box() {
    try {
        Stack<int> intStack;
        intStack.push(1);
        cout << intStack.top() << endl;
    } catch (exception const& ex) {
        cerr << ex.what() << endl;
    }
    
    
    cout << "Hello World!" << endl;
    C c;   //D, B, A ,C
    cout<<sizeof(c)<<endl;
    
    Box box1(10);
    Box box2 = box1;
    box1.set(12, 12);
    
    SmallBox sbox(5);
    printWidth(sbox);
    SmallBox *sptr;
    sptr = &sbox;
  
    Test test(sbox);
    
    cout << box1.length << endl;
    cout << box2.length << endl;
    cout << sbox.getWidth() << endl;
    cout << sbox.getWidth() << endl;
    cout << sptr->getWidth() << endl;
}
