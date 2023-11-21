#!/bin/sh

if /bin/exists /data/bootid
then
  echo $((`cat /data/bootid` + 1)) > /data/bootid
else
  echo 1 > /data/bootid
fi

chmod 644 /data/bootid

# Initialize the random number seed
echo "Initializing random number generator..."

RSEED=/data/random_seed
URANDOM=/dev/urandom
if /bin/exists $RSEED
then
  cat $RSEED >$URANDOM
else
  # This is our first boot, we need to initialize the kernel's random
  # number generator as it has very little entropy.  Otherwise, early
  # users of /dev/urandom (like our initial client id) will not be random.
  # See b/9487011.
  #
  # Since we don't have a RTC or any h/w random number generator support,
  # we rely on two other sources.
  #
  # 1) Our client certificate (encrypted) private key is both device unique
  # and not available externally to a user.  This by, by itself, should
  # solve the client id generation propblem.  However, it still leaves
  # open the possibility that we could know the initial seed (potentially
  # causing other problems).
  #
  # 2) Our nsec resolution high resolution timers via /proc/timer_list
  # (including the value of 'now' should be, while not random, very hard
  # to predict).
  #

  # Feed our private key
  cat "$CAST_CLIENT_PRIVKEY" >$URANDOM

  # Feed our current timer values
  cat /proc/timer_list >$URANDOM

  touch $RSEED
fi

# Always save the entropy pool for use at the next boot so
# that every boot is different.
chmod 600 $RSEED
dd if=$URANDOM of=$RSEED bs=512 count=1 2>/dev/null
