echo  "Trail for replacing IP address in the file"
NEW_IP="11.90.23.10"

sed -i "s/hostname:.*/hostname: \"${NEW_IP}\"/g" demo.yaml
