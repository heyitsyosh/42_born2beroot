#!bin/bash

ARCHITECTURE=$(uname -a)
CPU=$(lscpu | awk 'FNR == 5 {print $2}')
VCPU=$(cat /proc/cpuinfo | grep processor | wc -l)
USEDRAM=$(free -m | grep Mem: | awk '{print $3}')
MAXRAM=$(free -m | grep Mem: | awk '{print $2}')
RAMPERCENT=$(free -t | awk 'NR == 2 {printf("%.2f%"), $3/$2*100}')
USEDDISK=$(df --total -m | grep tota | awk '{print $3}')
MAXDISK=$(df --total -BG | grep total | awk '{print $2}')
DISKPERCENT=$(df --total | grep total | awk '{printf("%.2f%"), $3/$4*100}')
CPUPERCENT=$(top -b -n1 | grep Cpu | cut -c 36-40 | awk '{printf("%.2f%"), 100-$0}}')
LASTBOOT=$(who -b | awk '{s = ""; for (i = 3; i <= NF; i++) s = s $i " "; print s}')
LVMCHECK=$(lsblk | grep "lvm" | wc -l)
LVM=$(if [ ${LVMCHECK} -eq 0 ]; then echo no; else echo yes; fi)
TCPCOUNT=$(netstat -a | grep tcp | wc -l)
USERCOUNT=$(w | awk 'NR>2' | wc -l)
IP=$(hostname -I)
MAC=$(ip link show | grep "link/ether" | awk '{print $2}')
CMD=$(cat /var/log/sudo/sudo.log | grep "COMMAND=" | wc -l)

echo "#Architecture: ${ARCHITECTURE}"
echo "#CPU physical : ${CPU}"
echo "#vCPU : ${VCPU}"
echo "#Memory Usage: ${USEDRAM}/${MAXRAM}MB (${RAMPERCENT})"
echo "#Disk Usage: ${USEDDISK}/${MAXDISK}b (${DISKPERCENT})"
echo "#CPU load: ${CPUPERCENT}"
echo "#Last boot: ${LASTBOOT}"
echo "#LVM use: ${LVM}"
echo "#Connections TCP : ${TCPCOUNT} ESTABLISHED"
echo "#User log: ${USERCOUNT}"
echo "#Network : IP ${IP} (${MAC})"
echo "#Sudo : ${CMD} cmd"

# No worries about permissions because crontab runs script as root.
