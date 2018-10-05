/*
 * Fill out the Person prototype
 * function "buyDrink" which given a drink object which looks like:
 * {
 *     name: "beer",
 *     cost: 8.50,
 *     alcohol: true
 * }
 * will add the cost to the person expences if the person
 * is
 *    1. old enough to drink (if the drink is alcohol)
 *    2. buying the drink will not push their tab over $1000
 *
 * in addition write a function "getRecipt" which returns a list as such
 * [
 *    {
 *        name: beer,
 *        count: 3,
 *        cost: 25.50
 *    }
 * ]
 *
 * which summaries all drinks a person bought by name in order
 * of when they were bought (duplicate buys are stacked)
 *
 * run with `node test.js <name> <age> <drinks file>`
 * i.e
 * `node test.js alex 76 drinks.json`
 */

function Person(name, age) {
    this.name = name;
    this.age = age;
    this.tab = 0;
    this.history = {};
    this.historyLen = 0;
    this.canDrink = function() {
      return this.age >= 18;
    };
    this.canSpend = function(cost) {
      return this.tab + cost <= 1000;
    }
}

// write me
Person.prototype.buyDrink = function(drink) {
    // console.log(drink);
    
    if (((drink.alcohol && this.canDrink())
            || (! drink.alcohol)) 
            && this.canSpend(drink.cost)) {
        if (this.history[drink.name]) {
            this.history[drink.name]['count'] += 1;
            this.history[drink.name]['total'] += drink.cost;
        } else {
            var block = {};
            block['name'] = drink.name;
            block['count'] = 1;
            block['total'] = drink.cost;
            this.history[drink.name] = block;
        }
        this.tab += drink.cost;
        this.historyLen++; 
    }
}
// write me
Person.prototype.getRecipt = function() {
    // console.log(this.history);
    var recipt = [];
    for (const item of Object.keys(this.history)) {
        recipt.push(this.history[item]);
    }
    return recipt;
}

module.exports = Person;
