
function sum(list) {

  let sum = Number(0);
  let x;
  for (x of list) {
    sum = sum + Number(x);
  }
  return sum;
}

module.exports = sum;
