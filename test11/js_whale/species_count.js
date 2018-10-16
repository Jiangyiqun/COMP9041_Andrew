function species_count(target_species, whale_list) {
  let observation;
  let count = Number(0);
  for (observation of whale_list) {
    // console.log(observation.how_many);
    if (observation.species === target_species) {
        count += Number(observation.how_many);
    }
  }
  return count;
}

module.exports = species_count;
