#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "TRUNCATE teams, games")

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOAL OPPONENT_GOAL
do
if [[ $WINNER != "winner" ]]
  then
    TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")

  if [[ -z $TEAM_ID ]]
    then
    INSERT_WINNER_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")

    if [[ $INSERT_WINNER_RESULT == "INSERT 0 1" ]]
      then
        echo insert into names worked: $WINNER
    fi
    TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
  fi

  #opponents
    TEAM2_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")

  if [[ -z $TEAM2_ID ]]
    then
    INSERT_OPPONENT_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")

    if [[ $INSERT_OPPONENT_RESULT == "INSERT 0 1" ]]
      then
        echo insert into names worked: $OPPONENT
    fi
    TEAM2_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
  fi

  #games entry
GAME_ID=$($PSQL "SELECT game_id FROM games WHERE winner_id='$TEAM_ID' AND opponent_id='$TEAM2_ID'")

  if [[ -z $GAME_ID ]]
    then
    INSERT_GAME_RESULT=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES('$YEAR', '$ROUND', $TEAM_ID, $TEAM2_ID, $WINNER_GOAL, $OPPONENT_GOAL)")

    if [[ $INSERT_GAME_RESULT == "INSERT 0 1" ]]
      then
        echo insert into GAMES worked: $YEAR $ROUND
    fi
    GAME_ID=$($PSQL "SELECT game_id FROM games WHERE winner_id='$TEAM_ID' AND opponent_id='$TEAM2_ID'")
  fi

fi
done
