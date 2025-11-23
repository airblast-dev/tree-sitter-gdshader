void dothing() {
//   ^^^^^^^ definition.function
	do_call();
//      ^^^^^^^ reference.call
arr.len();
//  ^^^ reference.call
secret_type a;
//^^^^^^^^^ reference.class
}

struct MyStruct {
//     ^^^^^^^^ definition.class
	int epic_val;
	OtherStruct other_val;
//      ^^^^^^^^^^^ reference.class
};
