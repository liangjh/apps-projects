
Rails.logger.info("Initializing distributions...")


#  Binomial distribution init
Rails.logger.info("Initializing binomial distribution...")
Distributions::Binomial.ns
Distributions::Binomial.ps

#  Z distribution initi
Rails.logger.info("Initializing Z distribution...")
Distributions::Z.zvalues
Distributions::Z.min_alpha
Distributions::Z.max_alpha

#  T distribution init
Rails.logger.info("Initializing T distribution...")
Distributions::T.dfs
Distributions::T.alphas


Rails.logger.info("Completed distributions init...")

