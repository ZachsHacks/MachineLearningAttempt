# MachineLearningAttempt
Training set of movie ratings is applied to predicting missing ratings in test set.


[![Code Climate](https://codeclimate.com/repos/58915eb4c9e04000740067f8/badges/f0700fccbaddf029aeea/gpa.svg)](https://codeclimate.com/repos/58915eb4c9e04000740067f8/feed)

Code Climate Report: https://codeclimate.com/repos/58915eb4c9e04000740067f8/code

Repo: https://github.com/ZachsHacks/MachineLearningAttempt/

The Algorithm: My prediction algorythm works by checking each user for their similar users and getting an idea from their reviews of said movie. 

The Analysis: I ended up changing the most_similar(u) method to memoize each user's "relatives". This way when a user produces similar users, the similar users assume to be their relative with similar arrays that are the subset of the first one. This isn't very accurate, but it needed to be done to speed up the process. 

Benchmarking: Correct: 6342, Incorrect: 13658, Percent Correct: 46.4%, Algorithm Speed: 104.154204 s
