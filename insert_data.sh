#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT W_GOALS O_GOALS
do
  if [[ $YEAR != year ]]
  then
    #get game_id
    W_TEAM_ID=$($PSQL "select team_id from teams where '$WINNER'=name")
    O_TEAM_ID=$($PSQL "select team_id from teams where '$OPPONENT'=name")
    if [[ -z $W_TEAM_ID ]]
    then
      INSERT_WINNER=$($PSQL "insert into teams(name) values('$WINNER')")
      echo Inserted team $WINNER
    fi
    if [[ -z $O_TEAM_ID ]]
    then
      INSERT_OPPONENT=$($PSQL "insert into teams(name) values('$OPPONENT')")
      echo Inserted team $OPPONENT
    fi
    #get new game_id
    W_TEAM_ID=$($PSQL "select team_id from teams where '$WINNER'=name")
    O_TEAM_ID=$($PSQL "select team_id from teams where '$OPPONENT'=name")
    #insert game
    INSERT_GAME=$($PSQL "insert into games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) values($YEAR, '$ROUND', $W_TEAM_ID, $O_TEAM_ID, $W_GOALS, $O_GOALS)")
    echo Inserted Game $YEAR $ROUND

  fi
done