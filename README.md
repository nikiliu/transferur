TransferUR
==========

Transfer request management application for the Math & Computer Science department
at the University of Richmond. This application was built as part of an independent
study course under Professor Lewis Barnett.

Setup:

    git clone git@github.com:nikiliu/transferur.git   # clone down the repo
    bundle install                                    # install all dependencies
    bundle exec rake db:migrate                       # migrate database
    bundle exec rake test:prepare                     # prepare test database
    bundle exec rake test                             # verify all tests pass
    rails s                                           # fire up the server
