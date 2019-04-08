library(rtweet)

# compute the score for the user whose screen name is provided
compute_user_score <- function (user_screen_name) {
  # get the IDs of user's followers
  followers <- get_followers(user_screen_name, n = 100000000, retryonratelimit = TRUE)
  
  # store the number of followers
  nb_followers <- nrow(followers)
  
  # create the structure in which the data on users will be stored
  followers_data <- NULL
  
  # get the data on followers all at once if their number is inferior
  #  to the limit, but otherwise we need to fetch the data by chunks
  if (nb_followers <= rate_limit(query = "lookup_users")$remaining * 100) {
    followers_data <- lookup_users(followers$user_id)
  } else {
    # initialize the variables where the indices corresponding to the beginning
    # and end of the chunk of data to be fetched will be stored
    start <- end <- 1
    
    # fetch the data on followers chunk by chunk until there aren't any left
    while (start <= nb_followers) {
      # wait for the rate limit to reset before proceeding
      Sys.sleep(ceiling(as.numeric(rate_limit(query = "lookup_users")$reset) * 60))
      
      # update the variable with the index of the end of the chunk of data to be fetched
      end <- ifelse(start + 89999 < nb_followers, start + 89999, nb_followers)
      
      # fetch the data for that chunk and add it to the data already retrieved
      followers_data <- rbind(followers_data, lookup_users(followers$user_id[start:end]))
      
      # update the variable with the index of the beginning of the chunk of data to be fetched next
      start <- end + 1
    }
  }
  
  # compute the score (there shouldn't be any user in data who doesn't follow anyone, but experience shows there
  # are, which I'm guessing is because if X subscribed to a list of which Y is a member, then X is listed as a
  # follower of Y even if X doesn't actually follow Y, so I just ignore those people in the calculation)
  sum(ifelse(followers_data$friends_count > 0, followers_data$followers_count/followers_data$friends_count, 0))
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