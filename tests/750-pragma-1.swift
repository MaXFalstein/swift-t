import io;
/*
 * Test that we can define new work types and use them for foreign
 * functions.
 */

// COMPILE-ONLY-TEST
// SKIP-THIS-TEST

pragma worktypedef a_new_work_type;

@dispatch=a_new_work_type
f1() "turbine" "0.0" [
  "puts {f1 ran}"
];

// Should not be case-sensitive
@dispatch=A_NEW_WORK_TYPE
f2() "turbine" "0.0" [
  "puts {f2 ran}"
];

main () {
  f1();
  f2();
}
