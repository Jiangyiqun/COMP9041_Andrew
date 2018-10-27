function total_bill(bill_list) {
  let total = 0;
  for (const bill of bill_list) {
    for (const item of bill) {
      total = total + Number(item.price.slice(1));
    }
  }
  return total;

}

module.exports = total_bill;
