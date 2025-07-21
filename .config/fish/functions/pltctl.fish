# "Platformctl" (cannot be used to login)

function pltctl
  if [ $argv[1] = "-h" ]
    or [ $argv[1] = "--help" ]
    or [ $argv[1] = "help" ]
    echo ""
    echo "example:  get purgatory stg wrk e"
    echo "         edit purgatory prd web c"
    echo ""

  else

    if [ $argv[3] = "stg" ]
      or [ $argv[3] = "staging" ]
      set environment "staging"
    else if [ $argv[3] = "prd" ]
      or [ $argv[3] = "production" ]
      set environment "production"
    else
      echo "Need a proper environment"
    end

    if [ $argv[4] = "wrk" ]
      or [ $argv[4] = "worker" ]
      set role "worker"
    else if [ $argv[4] = "web" ]
      or [ $argv[4] = "webserver" ]
      set role "webserver"
    else
      echo "Need a proper role"
    end

    if [ $argv[5] = "c" ]
      or [ $argv[5] = "central" ]
      or [ $argv[5] = "central1" ]
      set region "us-central1"
    else if [ $argv[5] = "e" ]
      or [ $argv[5] = "east" ]
      or [ $argv[5] = "east4" ]
      set region "us-east4"
    else
      echo "Need a proper region"
    end

    echo platformctl config $argv[1] $argv[2] \
      --target k8s \
      --group app \
      --environment "$environment" \
      --role "$role" \
      --region "$region"

    platformctl config $argv[1] $argv[2] \
      --target k8s \
      --group app \
      --environment "$environment" \
      --role "$role" \
      --region "$region"
  end

end

# platformctl config get shipt-metropolis --target k8s --group app --environment "staging" --role "web" --region us-central1
