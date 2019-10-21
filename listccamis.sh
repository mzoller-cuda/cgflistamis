#VERSION='800-0475'
VERSION=$1

ami_regions=($(aws ec2 describe-regions --output text | sed -e 's/^.*com[[:blank:]]//'))


num_regions=${#ami_regions[@]}

for i in "${ami_regions[@]}"
do
        echo "\"$i\" :"
        echo "{"
        filter='Name=name,Values=Cuda*CCBYOL-v'"$VERSION"'*'

        BYOLAMI=$(aws ec2 describe-images --owner aws-marketplace --region $i --filters $filter --query 'Images[*].{ID:ImageId}' --output text)
        echo "    \"BYOL\" : \"$BYOLAMI\""

        if [[ $i == ${ami_regions[${#ami_regions[@]}-1]} ]]
        then
                echo "}"
        else
                echo "},"
        fi

done
