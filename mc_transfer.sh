#Verify file exists
if [ -d "$HOME/Library/Application Support/minecraft/saves/Aincrad" ]; then
  world_path="$HOME/Library/Application Support/minecraft/saves"
  world=Aincrad

  cd "$world_path"

  #copy file to new filename with timestamp

  # Compress
  echo "Most recent world save found: $world"
  echo "Compressing..."
  tar -cvf $world.tar $world

  # Move .tar to the server
  read -r -p "Transfer tarball to remote host? [y/N] " response
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    printf "Sending $world to remote..."
    scp $world.tar josh@107.170.3.94:minecraft
    echo "done!"

    # Remove .tar
    printf "Removing $world.tar..."
    echo "done!"
    rm $world.tar

    # Remove original file
    printf "Removing $world..."
    echo "done!"
    rm -rf $world

  else
    echo "Doing nothing."
  fi

  # Run script on remote host
  ssh josh@107.170.3.94 'source scripts/process_map.sh'

  # Announce job completion
  echo "====================================="
  echo "Done! Go to http://mc.minecraft.com"
  echo "====================================="

else 
  echo "No recent world saves found."
fi
