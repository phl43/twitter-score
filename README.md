# twitter-score

A script that compute a score that is a better measure of someone's influence on Twitter than his number of followers. See this thread on Twitter for more details on the motivations and the computation of the score: https://twitter.com/phl43/status/946864280900653056.

# Installation

From within R, call
```
    > install.packages("rtweet")
```

This may require you to install other, non-R, dependency software. Once you
have everything installed, you must edit `Twitter_score.R` to include
details of your Twitter API keys. See the [rtweet documentation](https://rtweet.info/) for details. If you haven't done this, the script will nag you to do
so when you try to run it.

Then:
```
    > source("Twitter_score.R")
```

if all is well you should be prompted for the Twitter handle you're interested
in.
