/*
* Given a list of career stats for a team of rugby players,
* a list of player names, and a list of team names, in the format below:
*
* players
* {
*     "players": [
*         {
*             "id": 112814,
*             "matches": "123",
*             "tries": "11"
*         }
*     ],
*     "team": {
*         "id": 10,
*         "coach": "John Simmons"
*     }
* }
* names
* {
*     "names": [
*         {
*             "id": 112814,
*             "name": "Greg Growden"
*         }
*     ]
* }
* teams
* {
*     "teams": [
*         {
*             "id": 10,
*             "team": "NSW Waratahs"
*         }
*     ]
* }
* Write a program that returns a 'team sheet' that lists
* the team, coach, players in that order in the following list format.
*
* [
*     "Team Name, coached by CoachName",
*     "1. PlayerName",
*     "2. PlayerName"
*     ....
* ]
*
* Where each element is a string, and the order of the players
* is ordered by the most number of matches played to the least number of matches played.
*
* For example, the following input should match the
* following output exactly.
*
* input data
* {
*     "players": [
*         {"id": 1,"matches": "123", "tries": "11"},
*         {"id": 2,"matches": "1",   "tries": "1"},
*         {"id": 3,"matches": "2",   "tries": "5"}
*     ],
*     "team": {
*         "id": 10,
*         "coach": "John Simmons"
*     }
* }
*
* {
*     "names": [
*         {"id": 1, "John Fake"},
*         {"id": 2, "Jimmy Alsofake"},
*         {"id": 3, "Jason Fakest"}
*     ]
* }
*
* {
*     "teams": [
*         {"id": 10, "Greenbay Packers"},
*     ]
* }
*
* output
* [
*     "Greenbay Packers, coached by John Simmons",
*     "1. John Fake",
*     "2. Jason Fakest",
*     "3. Jimmy Alsofake"
* ]
*
* test with
* `node test.js team.json names.json teams.json`
*/


function getPlayerName(id, namesData) {
    for (const item of namesData) {
        if (item.id == id) {
            return item.name;
        }
    }
}



function makeTeamList(teamData, namesData, teamsData) {
    // console.log(teamData);
    // console.log(namesData);
    // console.log(teamsData);
    const coachName = teamData.team.coach;
    // console.log(coachName)
    var teamName;
    for (const item of teamsData) {
        // console.log(item.id);
        if (item.id == teamData.team.id) {
            teamName = item.team;
            break;
        }
    }
    const title = teamName + ", coached by " + coachName;
    // console.log(title);
    // console.log(teamData.players);
    var stats = [title];



    var sequence = 1;
    for (const item of teamData.players.sort(
            function(a, b){return(b.matches - a.matches)}
    )) {
        const player = sequence + ". " + getPlayerName(item.id, namesData);
        stats.push(player);
        sequence++;
    }

    return stats;
}

module.exports = makeTeamList;
