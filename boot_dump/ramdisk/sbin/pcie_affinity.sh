FILE="/proc/interrupts"
while read LINE; do
  #echo "This is a line: $LINE"
  V_ISR=`echo $LINE|xargs|cut -d " " -f 1|cut -d ":" -f 1`
  #echo "virtual isr is $V_ISR"
  PHY_ISR=`echo $LINE|xargs|cut -d " " -f 5`
  #echo "phy_isr $PHY_ISR"
  DRV_NAME=`echo $LINE|xargs|cut -d " " -f 7`
  #echo "drv name $DRV_NAME"

  case $DRV_NAME in
    *"tdm_bridge"*|*"dwc_otg"*) echo 2 > /proc/irq/$V_ISR/smp_affinity;;
    *) ;;
  esac
done < $FILE
