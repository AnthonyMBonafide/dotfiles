# "Platformctl All" (gets all secrets from a service, with optional grep)

function pltctlALL
  if [ $argv[1] = "-h" ]
    or [ $argv[1] = "--help" ]
    echo ""
    echo "example:  get purgatory"
    echo "          get purgatory FORMAT"
    echo ""
  else
    if [ $argv[3] ]
        platformctl config $argv[1] $argv[2] --target k8s --group app --environment staging    --role webserver --region us-central1 | grep $argv[3]
        platformctl config $argv[1] $argv[2] --target k8s --group app --environment staging    --role webserver --region us-east4    | grep $argv[3]
        platformctl config $argv[1] $argv[2] --target k8s --group app --environment staging    --role worker    --region us-central1 | grep $argv[3]
        platformctl config $argv[1] $argv[2] --target k8s --group app --environment staging    --role worker    --region us-east4    | grep $argv[3]
        platformctl config $argv[1] $argv[2] --target k8s --group app --environment production --role webserver --region us-central1 | grep $argv[3]
        platformctl config $argv[1] $argv[2] --target k8s --group app --environment production --role webserver --region us-east4    | grep $argv[3]
        platformctl config $argv[1] $argv[2] --target k8s --group app --environment production --role worker    --region us-central1 | grep $argv[3]
        platformctl config $argv[1] $argv[2] --target k8s --group app --environment production --role worker    --region us-east4    | grep $argv[3]
    else
        platformctl config $argv[1] $argv[2] --target k8s --group app --environment staging    --role webserver --region us-central1
        platformctl config $argv[1] $argv[2] --target k8s --group app --environment staging    --role webserver --region us-east4
        platformctl config $argv[1] $argv[2] --target k8s --group app --environment staging    --role worker    --region us-central1
        platformctl config $argv[1] $argv[2] --target k8s --group app --environment staging    --role worker    --region us-east4
        platformctl config $argv[1] $argv[2] --target k8s --group app --environment production --role webserver --region us-central1
        platformctl config $argv[1] $argv[2] --target k8s --group app --environment production --role webserver --region us-east4
        platformctl config $argv[1] $argv[2] --target k8s --group app --environment production --role worker    --region us-central1
        platformctl config $argv[1] $argv[2] --target k8s --group app --environment production --role worker    --region us-east4
    end
  end

end
