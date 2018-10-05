/*
 * This code is broken! Can you figure out why
 * and fix it?
 */

function doubleIfEven(n) {
  var x = n;
  if(even(x)) return double(x);
  return x;
}

function even(a) {
  var x = a;
  if(x%2==0) x = true;
  else x = false;
  return x;
}

function double(a) {
  return a*2;
}


module.exports = doubleIfEven;
