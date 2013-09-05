#script used for promoting code through a 3-branch heirarchy (master => qa => staging)
#step 1: reverse-merge all changes from staging => qa => master.  Push up to remote
#step 2: merge master => qa OR qa => staging.  Depends on parameter you pass in.
#step 3: run specs.  Push up to remote if specs pass.  Don't push if specs don't pass.

#if you have a project that is not using this 3-branch model, then go use git-flow and leave me alone.  


source ~/.bash_profile
if   [ $# -lt 1 ]; then
 echo "I understand you want me to merge something, but you have to tell me where (qa or staging)"
 exit
fi
git checkout master
git pull origin master
git checkout staging
git pull origin staging

git checkout qa
git pull origin qa
git merge staging
git push origin qa

git checkout master
git pull origin master
git merge qa
git push origin master

if   [ $1 == 'staging' ]; then
  echo "merging to qa to staging."
  git checkout staging
  git merge qa
  SUCESS_OUTPUT="\, 0 failures"
  bundle
  bundle exec rake db:migrate && bundle exec rake db:test:prepare && git checkout db/schema.rb
  echo "This script will run 'rake' command to make sure your test suite passes before pushing"
  exec 5>&1
  OUTPUT=$( rspec spec | tee /dev/fd/5)
  if  echo "$OUTPUT" | grep -q "$SUCESS_OUTPUT"; then
          echo 'Test passed! proceeding with the push'
          git push origin staging
          git checkout master
          exit
  else
          echo "Some test did not pass! Failed test are shown above. Push aborted!"
          git checkout master
          exit 1
  fi


elif [ $1 == 'qa' ];  then
  git checkout qa
  git merge master
  SUCESS_OUTPUT="\, 0 failures"
  bundle
  bundle exec rake db:migrate && bundle exec rake db:test:prepare && git checkout db/schema.rb
  echo "This script will run 'rake' command to make sure your test suite passes before pushing"
  exec 5>&1
  OUTPUT=$( rspec spec | tee /dev/fd/5)
  if  echo "$OUTPUT" | grep -q "$SUCESS_OUTPUT"; then
          echo 'Test passed! proceeding with the push'
          git push origin qa
          git checkout master
          exit
  else
          echo "Some test did not pass! Failed test are shown above. Push aborted!"
          git checkout master
          exit 1
  fi
  else
    echo "not gonna do it.  Wouldn't be prudent."
    exit
  fi

fi



