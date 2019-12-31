#  Tweemio Model
#  Main controller & production implementation logic
#

'''
[1] download user handle twitter timeline << error check possibility first
    (error checking: (a) does user exist?  , (b) does user have sufficient # of tweets?)
[2] extract user timeline text, condense to configured condense factor
[3] vectorize user timeline (using saved countvectorizer) - i.e. last “x” tweets, whatever fits into single request
[4] pass timeline through each calibrated model (for each personality)
[5] for each, calc *average* (+ stdev) similarity score + get top 10 most similar tweets
[6] save summary results to JSON to persistence location or google bucket
[7] save top-line results into database table
'''




