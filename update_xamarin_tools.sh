CURRENT_DIR=$(pwd)
WORKING_DIR=$(dirname `readlink -f $0`)
mkdir -p $HOME/xamarin
mkdir -p $HOME/xamarin/log
LOG_DIR=$HOME/xamarin/log
NOW=$(date +"%Y_%m_%d_%H_%M_%S")
LOG=$LOG_DIR/build_${NOW}.log
touch $LOG
${WORKING_DIR}/__internal_build.sh 2>&1 | tee $LOG
cd $CURRENT_DIR
