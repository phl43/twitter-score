library(rtweet)

# compute the score for the user whose screen name is provided (at the moment
# this only works properly for people who have less than 90,000 followers)
compute_user_score <- function (screen_name) {
  # get the IDs of user's followers
  followers <- get_followers(screen_name, n = 75000, retryonratelimit = TRUE)
  
  # get the data on user's followers (this will only return the data on the first 90,000 followers,
  # so for the moment the script does not work properly for users who have more followers than that)
  data <- lookup_users(followers$user_id)
  
  # compute the score (there shouldn't be any user in data who doesn't follow anyone, but experience shows there
  # are, which I'm guessing is because if X subscribed to a list of which Y is a member, then X is listed as a
  # follower of Y even if X doesn't actually follow Y, so I just ignore those people in the calculation)
  sum(ifelse(data$friends_count > 0, data$followers_count/data$friends_count, 0))
}

# see https://rtweet.info to learn how to create a Twitter application and obtain the various keys you need here
consumer_key <- #YOUR_CONSUMER_KEY
consumer_secret <- #YOUR_CONSUMER_SECRET
access_token <- #YOUR_ACCESS_TOKEN
access_secret <- #YOUR_ACCESS_SECRET

  # set up the OAuth credentials
  create_token(consumer_key = consumer_key,
               consumer_secret = consumer_secret,
               access_token = access_token,
               access_secret = access_secret)

# ask for the screen name of the user whose score you want to calculate
user_screen_name <- readline(prompt = "Enter user's screen name: ")

# compute user's score
compute_user_score(user_screen_name)