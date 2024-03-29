import twitter
import re


class TwitterApi:
    
    def __init__(self, creds: dict={}):
        
        cred_keys = ['consumer_key', 'consumer_secret', 'access_token_key', 'access_token_secret']        
        if len(creds) < 1 or len(set(cred_keys) - set(creds)) > 0:
            raise Exception(f'all keys required: {cred_keys}')
        creds['tweet_mode'] = 'extended'

        self.creds = creds
        self.twapi = None
        self.check_connection()

        
    def check_connection(self):
        try:
            self.twapi.VerifyCredentials()
        except:
            self.twapi = twitter.Api(**self.creds)
    
    
    def user_exists(self, screen_name: str) -> bool:
        '''
        Check that a given user exists on twitter
        '''
        try:
            self.check_connection()
            self.twapi.GetUser(screen_name=screen_name)
        except:
            return False
        return True


    def user(self, screen_name: str) -> bool:
        '''
        Get user, if one actually exists w/ this user name
        '''
        try:
            self.check_connection()
            user = self.twapi.GetUser(screen_name=screen_name)
            return user
        except:
            return None


    def timeline(self, screen_name: str, recent: bool=True, condense_factor: int=1, filter_regex: str='^(http)') -> list:
        '''
        Returns a 'refined' timeline;  reverse ordered and condensed to the passed factor 
        '''
        tweet_timeline = self.timeline_raw(screen_name)
        timeline_text  = list(reversed([tli._json['full_text'] for tli in tweet_timeline]))
        return self.timeline_filter(timeline_text, condense_factor, filter_regex)


    def timeline_raw(self, screen_name: str, recent: bool=True) -> list:
        '''
        Retrieves a user's tweet timelines
        Excludes retweets, so only original content for the user
        '''
        
        timeline = []
        max_id = None
        iterations = 0

        self.check_connection()
        while True:        
            tweets = self.twapi.GetUserTimeline(screen_name=screen_name, include_rts=False, count=200, max_id=max_id)
            timeline += tweets

            #  Exceptions: (1) empty timeline, (2) recent-only
            if len(tweets) < 1:
                break        
            if recent and iterations > 1:
                break

            #  Iterate to next
            next_max_id = min(tweets, key=lambda t: t.id).id
            if next_max_id == max_id:
                break
            max_id = next_max_id
            iterations += 1
            
        return timeline


    @classmethod
    def timeline_filter(cls, timeline_text: list, condense_factor: int=1, filter_regex: str='^(http)') -> list:
        '''
        Filters and condenses timeline
        Separation to allow for utility use
        '''
        timeline_text  = [' '.join([('' if (re.search(filter_regex, word) != None) else word) for word in text.split()]) for text in timeline_text]
        timeline_text  = [t for t in timeline_text if len(t.strip()) > 0]

        #  Group by condense factor (i.e. grouping multiple tweets into single tweet)
        timeline_text = [' '.join(timeline_group) for timeline_group in
                                zip(*[timeline_text[n::condense_factor] for n in range(0, condense_factor)])]

        return timeline_text



